Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab1INIz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 04:55:28 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:41101 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab1INIz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 04:55:27 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Sep 2011 04:55:27 EDT
Date: Wed, 14 Sep 2011 16:49:57 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org
Subject: Re: [RFC] [PATCH 02/62] mpu401:snd_mpu401_uart_new(): split semantic
 of irq_flags
Message-ID: <20110914084957.GB23710@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110908144519.GB3069@zhy>
 <4E69253F.3090705@ladisch.de>
 <20110909013143.GB18249@zhy>
 <4E6CCF6C.2020301@ladisch.de>
 <s5hvcsy6nr2.wl%tiwai@suse.de>
 <4E6E061E.2010000@ladisch.de>
 <4E6E6A34.8060104@ladisch.de>
 <s5hvcswvrty.wl%tiwai@suse.de>
 <4E6F1194.80106@ladisch.de>
 <4E6F2159.6060606@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4E6F2159.6060606@ladisch.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 11:24:41AM +0200, Clemens Ladisch wrote:
[snip]
> 
> completely untested:
> 
> --8<---------------------------------------------------------------->8--
> ALSA: mpu401: clean up interrupt specification
> 
> The semantics of snd_mpu401_uart_new()'s interrupt parameters are
> somewhat counterintuitive:  To prevent the function from allocating its
> own interrupt, either the irq number must be invalid, or the irq_flags
> parameter must be zero.  At the same time, the irq parameter being
> invalid specifies that the mpu401 code has to work without an interrupt
> allocated by the caller.  This implies that, if there is an interrupt
> and it is allocated by the caller, the irq parameter must be set to
> a valid-looking number which then isn't actually used.
> 
> With the removal of IRQF_DISABLED, zero becomes a valid irq_flags value,
> which forces us to handle the parameters differently.
> 
> This patch introduces a new flag MPU401_INFO_IRQ_HOOK for when the
> device interrupt is handled by the caller, and makes the allocation of
> the interrupt to depend only on the irq parameter.  As suggested by
> Takashi, the irq_flags parameter was dropped because, when used, it had
> the constant value IRQF_DISABLED.

Thanks Clemens. Your patch will eventually save much lines from mine ,
actually I only need to touch request_irq() in snd_mpu401_uart_new().

But do you have any idea by which tree this patch will go to mainline?
Thus I could make a new patch based on it :)

Thanks,
Yong
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
