Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab2KVUfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:35:04 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:50084 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2KVUe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:34:57 -0500
Message-ID: <8DA3043795C340758B9AEB1BCA791676@Chronos>
From: "Michael D. Burkey" <mdburkey@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <alan@lxorguk.ukuu.org.uk>,
        "Christoph Fritz" <chf.fritz@googlemail.com>,
        =?UTF-8?Q?Eric_B=C3=A9nard?= <eric@eukrea.com>,
        "Sascha Hauer" <s.hauer@pengutronix.de>
References: <20121122004212.371862690@linuxfoundation.org> <20121122004216.531273574@linuxfoundation.org>
In-Reply-To: <20121122004216.531273574@linuxfoundation.org>
Subject: Re: [ 35/83] ARM: imx: ehci: fix host power mask bit
Date: Wed, 21 Nov 2012 23:52:25 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Windows Mail 6.0.6002.18005
X-MimeOLE: Produced By Microsoft MimeOLE V6.1.7601.17609
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is definitely needed -- it is obviously setting the wrong bit --  
but I am still doing testing to see what other complications may arise from 
actually setting the RIGHT bit (i.e. I've seen some odd results so far and 
suspect some other code may have been changed historically to account for 
the wrong behaviour this bit was causing).

We're currently on vacation for Thanksgiving over here in the USA and I 
won't be back in the office til next week.

If you would, hold off on adding the patch to the stable kernel until I have 
a bit more time to check out a couple of things.

Thanks,
Michael Burkey

----- Original Message ----- 
From: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-kernel@vger.kernel.org>; <stable@vger.kernel.org>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>; 
<alan@lxorguk.ukuu.org.uk>; "Michael Burkey" <mdburkey@gmail.com>; 
"Christoph Fritz" <chf.fritz@googlemail.com>; "Eric Bénard" 
<eric@eukrea.com>; "Sascha Hauer" <s.hauer@pengutronix.de>
Sent: Wednesday, November 21, 2012 7:41 PM
Subject: [ 35/83] ARM: imx: ehci: fix host power mask bit


> 3.6-stable review patch.  If anyone has any objections, please let me 
> know.
>
> ------------------
>
> From: Christoph Fritz <chf.fritz@googlemail.com>
>
> commit 3d5e2abe6e265acc5e1fda810301243e9bac92b2 upstream.
>
> This patch sets HPM (Host power mask bit) to bit 16 according to i.MX
> Reference Manual. Falsely it was set to bit 8, but this controls pull-up
> Impedance.
>
> Reported-by: Michael Burkey <mdburkey@gmail.com>
> Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
> Acked-by: Eric Bénard <eric@eukrea.com>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
> arch/arm/mach-imx/ehci-imx25.c |    2 +-
> arch/arm/mach-imx/ehci-imx35.c |    2 +-
> 2 files changed, 2 insertions(+), 2 deletions(-)
>
> --- a/arch/arm/mach-imx/ehci-imx25.c
> +++ b/arch/arm/mach-imx/ehci-imx25.c
> @@ -30,7 +30,7 @@
> #define MX25_H1_SIC_SHIFT 21
> #define MX25_H1_SIC_MASK (0x3 << MX25_H1_SIC_SHIFT)
> #define MX25_H1_PP_BIT (1 << 18)
> -#define MX25_H1_PM_BIT (1 << 8)
> +#define MX25_H1_PM_BIT (1 << 16)
> #define MX25_H1_IPPUE_UP_BIT (1 << 7)
> #define MX25_H1_IPPUE_DOWN_BIT (1 << 6)
> #define MX25_H1_TLL_BIT (1 << 5)
> --- a/arch/arm/mach-imx/ehci-imx35.c
> +++ b/arch/arm/mach-imx/ehci-imx35.c
> @@ -30,7 +30,7 @@
> #define MX35_H1_SIC_SHIFT 21
> #define MX35_H1_SIC_MASK (0x3 << MX35_H1_SIC_SHIFT)
> #define MX35_H1_PP_BIT (1 << 18)
> -#define MX35_H1_PM_BIT (1 << 8)
> +#define MX35_H1_PM_BIT (1 << 16)
> #define MX35_H1_IPPUE_UP_BIT (1 << 7)
> #define MX35_H1_IPPUE_DOWN_BIT (1 << 6)
> #define MX35_H1_TLL_BIT (1 << 5)
>
> 

