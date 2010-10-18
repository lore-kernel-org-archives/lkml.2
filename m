Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab0JRJk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 05:40:26 -0400
Received: from smtp.nokia.com ([192.100.122.233]:28983 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab0JRJkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 05:40:25 -0400
From: <samu.p.onkalo@nokia.com>
To: <samu.p.onkalo@nokia.com>, <khali@linux-fr.org>
CC: <tony@atomide.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 18 Oct 2010 11:38:44 +0200
Subject: RE: [PATCH 0/2] Short timeout for I2C transfers
Thread-Topic: [PATCH 0/2] Short timeout for I2C transfers
Thread-Index: ActsZ82pnIa0WGfKSjazAey3yqUnswCOGxXQAAFMGQA=
Message-ID: <62697B07E9803846BC582181BD6FB6B835EFD27D1C@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1286977510-16702-1-git-send-email-samu.p.onkalo@nokia.com>
 <20101015145149.2f688c9d@endymion.delvare>
 <62697B07E9803846BC582181BD6FB6B835EFD27C35@NOK-EUMSG-02.mgdnok.nokia.com>
In-Reply-To: <62697B07E9803846BC582181BD6FB6B835EFD27C35@NOK-EUMSG-02.mgdnok.nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 18 Oct 2010 09:40:06.0872 (UTC) FILETIME=[72BCAD80:01CB6EA8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: linux-i2c-owner@vger.kernel.org [mailto:linux-i2c-
>owner@vger.kernel.org] On Behalf Of ext samu.p.onkalo@nokia.com


>>The timeout is a symptom as the controller level. What is the root
>>cause at the LP5523 device level? What exactly happens on the wire?
>>
>
>Chip seems to release ACK signal too soon causing rising edge while
>SCL is high. This violates bus protocol and causes timeout at the
>controller. It is no recognized as ACK nor NACK.
>
>>I am asking because maybe some of the already available protocol
>>mangling flags would work for you, in particular I2C_M_IGNORE_NAK. See
>>Documentation/i2c/i2c-protocol.
>>
>>
>>You should also check why you hit the timeout condition. Ideally the
>>hardware would report problems as they happen, quickly, rather than
>>having to rely on the driver's timeout mechanism. The timeout should
>>really only be a safety mechanism, for when the bus controller itself
>>misbehaves at the hardware level.
>>

It seems that controller detects bus free condition when this happens.
So, instead of the timeout, bus free condition should be detected.
There is no such interrupt so this must be done by polling
the status register. In general this is not a good idea.

Would it make sense somehow tell that use polling and not
the interrupt / timeout control? I.e. by setting a flag that
this transfer doesn't end properly.

I2C_M_IGNORE_TIMEOUT?
In such case just either wait for bus free if supported by HW or
wait for some short time after start of the transmission

-Samu


