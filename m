Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0JRItc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 04:49:32 -0400
Received: from smtp.nokia.com ([192.100.105.134]:34445 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab0JRItb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 04:49:31 -0400
From: <samu.p.onkalo@nokia.com>
To: <khali@linux-fr.org>
CC: <tony@atomide.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 18 Oct 2010 10:48:00 +0200
Subject: RE: [PATCH 0/2] Short timeout for I2C transfers
Thread-Topic: [PATCH 0/2] Short timeout for I2C transfers
Thread-Index: ActsZ82pnIa0WGfKSjazAey3yqUnswCOGxXQ
Message-ID: <62697B07E9803846BC582181BD6FB6B835EFD27C35@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1286977510-16702-1-git-send-email-samu.p.onkalo@nokia.com>
 <20101015145149.2f688c9d@endymion.delvare>
In-Reply-To: <20101015145149.2f688c9d@endymion.delvare>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 18 Oct 2010 08:49:03.0825 (UTC) FILETIME=[5104CC10:01CB6EA1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: ext Jean Delvare [mailto:khali@linux-fr.org]
>Sent: 15 October, 2010 15:52
>To: Onkalo Samu.P (Nokia-MS/Tampere)
>Cc: tony@atomide.com; linux-i2c@vger.kernel.org; linux-
>kernel@vger.kernel.org
>Subject: Re: [PATCH 0/2] Short timeout for I2C transfers
>
>Hi Samu,
>
>On Wed, 13 Oct 2010 16:45:08 +0300, Samu Onkalo wrote:
>> There are chips which doesn't work perfectly in certain
>> I2C operations. For example lp5523 led driver chip causes
>> always I2C timeout when SW reset is commanded to the chip.
>
>The timeout is a symptom as the controller level. What is the root
>cause at the LP5523 device level? What exactly happens on the wire?
>

Chip seems to release ACK signal too soon causing rising edge while
SCL is high. This violates bus protocol and causes timeout at the
controller. It is no recognized as ACK nor NACK.

>I am asking because maybe some of the already available protocol
>mangling flags would work for you, in particular I2C_M_IGNORE_NAK. See
>Documentation/i2c/i2c-protocol.
>
>> Patches add a possibility to tell that this access is likely
>> to cause time out and there is no need to wait normal time.
>> For example in omap time out is 1 second and the bus is reserved
>> all the time.
>
>You should ask yourself whether a 1 second timeout is a sane thing to
>have in the first place.

hmm.. 1 second is quite long time out for i2c.

>
>You should also check why you hit the timeout condition. Ideally the
>hardware would report problems as they happen, quickly, rather than
>having to rely on the driver's timeout mechanism. The timeout should
>really only be a safety mechanism, for when the bus controller itself
>misbehaves at the hardware level.
>
>> By setting I2C_M_SHORT_TIMEOUT flag to i2c-message, adapter is
>> requested to use shorter timeout.
>>
>> Samu Onkalo (2):
>>   drivers: i2c-core: Add a flag to allow short timeout
>>   drivers: i2c-omap: Add support for shorten I2C timeout
>>
>>  drivers/i2c/busses/i2c-omap.c |    9 ++++++++-
>>  drivers/i2c/i2c-core.c        |    2 +-
>>  include/linux/i2c.h           |    1 +
>>  3 files changed, 10 insertions(+), 2 deletions(-)
>
>I'm skeptical. If you know that the transfer will "fail" and you don't
>care, why do you want to wait a short time, rather than not waiting at
>all?

Well, at least some time should be spend to allow bits to go out.
Maybe controller provides something for that.

-Samu

