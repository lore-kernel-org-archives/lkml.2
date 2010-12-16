Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0LPGRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 01:17:31 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:38698 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613Ab0LPGR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 01:17:28 -0500
Date: Thu, 16 Dec 2010 08:17:11 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] delay.h: add __must_check to msleep_interruptible
Message-ID: <20101216061711.GC26083@jasper.tkos.co.il>
References: <aed7ab07576c307653723b9bea04516879b3a3ed.1288860894.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aed7ab07576c307653723b9bea04516879b3a3ed.1288860894.git.baruch@tkos.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi lkml,

On Thu, Nov 04, 2010 at 10:55:41AM +0200, Baruch Siach wrote:
> Code calling msleep_interruptible() must be aware that sleep time might be
> shorter than intended as a result of a signal being caught. Code not checking
> the return value of msleep_interruptible() is probably buggy, unless it's doing
> the signal_pending() check itself, which is redundant.

Ping?
Any reason not to apply this? This patch could have saved me from an incorrect 
handling of signaled userspace processes.

baruch

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  include/linux/delay.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/delay.h b/include/linux/delay.h
> index a6ecb34..1be4994 100644
> --- a/include/linux/delay.h
> +++ b/include/linux/delay.h
> @@ -44,7 +44,7 @@ static inline void ndelay(unsigned long x)
>  extern unsigned long lpj_fine;
>  void calibrate_delay(void);
>  void msleep(unsigned int msecs);
> -unsigned long msleep_interruptible(unsigned int msecs);
> +unsigned long __must_check msleep_interruptible(unsigned int msecs);
>  void usleep_range(unsigned long min, unsigned long max);
>  
>  static inline void ssleep(unsigned int seconds)
> -- 
> 1.7.2.3

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
