Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0JOMwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:52:00 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:10756 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab0JOMv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:51:58 -0400
Date: Fri, 15 Oct 2010 14:51:49 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: tony@atomide.com, linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Short timeout for I2C transfers
Message-ID: <20101015145149.2f688c9d@endymion.delvare>
In-Reply-To: <1286977510-16702-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1286977510-16702-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samu,

On Wed, 13 Oct 2010 16:45:08 +0300, Samu Onkalo wrote:
> There are chips which doesn't work perfectly in certain
> I2C operations. For example lp5523 led driver chip causes
> always I2C timeout when SW reset is commanded to the chip.

The timeout is a symptom as the controller level. What is the root
cause at the LP5523 device level? What exactly happens on the wire?

I am asking because maybe some of the already available protocol
mangling flags would work for you, in particular I2C_M_IGNORE_NAK. See
Documentation/i2c/i2c-protocol.

> Patches add a possibility to tell that this access is likely
> to cause time out and there is no need to wait normal time.
> For example in omap time out is 1 second and the bus is reserved
> all the time.

You should ask yourself whether a 1 second timeout is a sane thing to
have in the first place.

You should also check why you hit the timeout condition. Ideally the
hardware would report problems as they happen, quickly, rather than
having to rely on the driver's timeout mechanism. The timeout should
really only be a safety mechanism, for when the bus controller itself
misbehaves at the hardware level.

> By setting I2C_M_SHORT_TIMEOUT flag to i2c-message, adapter is
> requested to use shorter timeout.
> 
> Samu Onkalo (2):
>   drivers: i2c-core: Add a flag to allow short timeout
>   drivers: i2c-omap: Add support for shorten I2C timeout
> 
>  drivers/i2c/busses/i2c-omap.c |    9 ++++++++-
>  drivers/i2c/i2c-core.c        |    2 +-
>  include/linux/i2c.h           |    1 +
>  3 files changed, 10 insertions(+), 2 deletions(-)

I'm skeptical. If you know that the transfer will "fail" and you don't
care, why do you want to wait a short time, rather than not waiting at
all?

-- 
Jean Delvare
