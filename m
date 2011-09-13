Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1IMIRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 04:17:08 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:40061 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755167Ab1IMIRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 04:17:06 -0400
X-Sasl-enc: xFz1DZ9cDt+F5eSpT3oyJG1tua/fjRmfkfmOEKpxqkD3 1315901824
Message-ID: <4E6F1194.80106@ladisch.de>
Date: Tue, 13 Sep 2011 10:17:24 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org
Subject: Re: [RFC] [PATCH 02/62] mpu401:snd_mpu401_uart_new(): split semantic
 of irq_flags
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>	<1315383059-3673-3-git-send-email-yong.zhang0@gmail.com>	<4E689E9A.8000407@ladisch.de>	<20110908133700.GB2310@zhy>	<4E68CA15.8000504@ladisch.de>	<20110908144519.GB3069@zhy>	<4E69253F.3090705@ladisch.de>	<20110909013143.GB18249@zhy>	<4E6CCF6C.2020301@ladisch.de>	<s5hvcsy6nr2.wl%tiwai@suse.de>	<4E6E061E.2010000@ladisch.de>	<4E6E6A34.8060104@ladisch.de> <s5hvcswvrty.wl%tiwai@suse.de>
In-Reply-To: <s5hvcswvrty.wl%tiwai@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> Clemens Ladisch wrote:
> > ALSA: mpu401: clean up interrupt specification
> > 
> > The semantics of snd_mpu401_uart_new()'s interrupt parameters are
> > somewhat counterintuitive:  To prevent the function from allocating its
> > own interrupt, either the irq number must be invalid, or the irq_flags
> > parameter must be zero.  At the same time, the irq parameter being
> > invalid specifies that the mpu401 code has to work without an interrupt
> > allocated by the caller.  This implies that, if there is an interrupt
> > and it is allocated by the caller, the irq parameter must be set to
> > a valid-looking number which then isn't actually used.
> > 
> > With the removal of IRQF_DISABLED, zero becomes a valid irq_flags value,
> > which forces us to handle the parameters differently.
> > 
> > This patch introduces a new flag MPU401_INFO_IRQ_HOOK for when the
> > device interrupt is handled by the caller, and makes the allocation of
> > the interrupt to depend only on the irq parameter.
> > 
> > Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> 
> This patch looks better indeed.
> 
> However, if we are going to remove IRQF_DISABLED in near future, and
> all the callers use IRQF_DISABLED when requesting an irq, why not
> remove this argument now?  Then the IRQF_DISABLED-removal patch will
> touch less code.

I wanted to change only the minimum amount of code needed to make the
IRQF_DISABLED-removal patch possible, and wait with further cleanups of
snd_mpu401_uart_new() until after that patch to avoid conflicts.

However, moving the IRQF_DISABLED into snd_mpu401_uart_new() avoids
those conflicts, so it's clearly better.


Regards,
Clemens
