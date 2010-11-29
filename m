Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab0K2GcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 01:32:11 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56649 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab0K2GcJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 01:32:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=henud11UNibQUAQJgpWoOl0VxuevOvtcin55u1q2m326snKaWTpqQB6XvhvG9rSuc0
         L0EEgPzrLrtQpzTA2pw9oafM8r1lwI2hM5pEEATwRY0p0J3Qrj9jGl+FZhYGJubZ29Kg
         qqalziS8rq/vxiTnholXXY5TrzSvFfGOkQXvg=
MIME-Version: 1.0
In-Reply-To: <1290791168-21255-1-git-send-email-segoon@openwall.com>
References: <1290791168-21255-1-git-send-email-segoon@openwall.com>
Date: Mon, 29 Nov 2010 12:02:08 +0530
Message-ID: <AANLkTi==K=pYU-x5ZQQ9ACLD-MN8o9N61JbVqpBZnQWT@mail.gmail.com>
Subject: Re: [PATCH] arm: plat-spear: time: use IS_ERR() instead of NULL check
From: viresh kumar <viresh.linux@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, Viresh Kumar <viresh.kumar@st.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Shiraz HASHIM <shiraz.hashim@st.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 10:36 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> clk_get() returns ERR_PTR() on error, not NULL.
>
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Cannot compile this driver, so it is not tested at all.
>
>  arch/arm/plat-spear/time.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/plat-spear/time.c b/arch/arm/plat-spear/time.c
> index ab21165..678df18 100644
> --- a/arch/arm/plat-spear/time.c
> +++ b/arch/arm/plat-spear/time.c
> @@ -229,13 +229,13 @@ void __init spear_setup_timer(void)
>        }
>
>        gpt_clk = clk_get_sys("gpt0", NULL);
> -       if (!gpt_clk) {
> +       if (IS_ERR(gpt_clk)) {
>                pr_err("%s:couldn't get clk for gpt\n", __func__);
>                goto err_iomap;
>        }
>
>        pll3_clk = clk_get(NULL, "pll3_48m_clk");
> -       if (!pll3_clk) {
> +       if (IS_ERR(pll3_clk)) {
>                pr_err("%s:couldn't get PLL3 as parent for gpt\n", __func__);
>                goto err_iomap;
>        }

Compiled & tested.

Acked-by: Viresh Kumar <viresh.kumar@st.com>
