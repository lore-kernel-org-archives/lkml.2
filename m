Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab0KSLiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 06:38:09 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:54518 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753091Ab0KSLiH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:38:07 -0500
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 06:38:07 EST
MIME-Version: 1.0
In-Reply-To: <20101119014029.GA26429@july>
References: <20101119014029.GA26429@july>
Date: Fri, 19 Nov 2010 05:30:14 -0600
Message-ID: <AANLkTikpAPLSTAzm2iPSV1_LL=B+zPbWzTPdhne3XFVc@mail.gmail.com>
Subject: Re: [PATCH] ARM: l2x0: Check the correct address range
From: "Kanigeri, Hari" <h-kanigeri2@ti.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Boojin Kim <boojin.kim@samsung.com>
>
> When flush or clean the 1MiB, it doesn't flush or clean all since it doesn't check the correct address. So Check the correct address range.

I saw this before but then I thought that the individual callers of
cache functions have to call with  +1 to the end address.

>
> Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
> index 170c9bb..50599d9 100644
> --- a/arch/arm/mm/cache-l2x0.c
> +++ b/arch/arm/mm/cache-l2x0.c
> @@ -195,7 +195,7 @@ static void l2x0_clean_range(unsigned long start, unsigned long end)
>        void __iomem *base = l2x0_base;
>        unsigned long flags;
>
> -       if ((end - start) >= l2x0_size) {
> +       if ((end - start + 1) >= l2x0_size) {

nitpick: probably will look more obvious if it is coded as  if ((end +
1) - start) >= l2x0_size)

>                l2x0_clean_all();
>                return;
>        }
> @@ -225,7 +225,7 @@ static void l2x0_flush_range(unsigned long start, unsigned long end)
>        void __iomem *base = l2x0_base;
>        unsigned long flags;
>
> -       if ((end - start) >= l2x0_size) {
> +       if ((end - start + 1) >= l2x0_size) {

same as above.


Thank you,
Best regards,
Hari Kanigeri
