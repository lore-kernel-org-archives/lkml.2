Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab2J3JDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:03:21 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:33868 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab2J3JDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:03:19 -0400
MIME-Version: 1.0
In-Reply-To: <508F9724.50804@linaro.org>
References: <5afab1ebe83e4361f1fd75bbea0c559af195bf02.1351529738.git.viresh.kumar@linaro.org>
	<1351540778.2721.7.camel@bwh-desktop.uk.solarflarecom.com>
	<CAKohponL_3m2KVytiWm8ZHyB5aimk8CzGrqr5J0LMy8MFGodHg@mail.gmail.com>
	<CAKohponOKk5e2Sxyhjw-XvzVxF3tNp66rsnYCwvwHazAPAauKw@mail.gmail.com>
	<508F8779.8070300@linaro.org>
	<CAKohpokmfFSFsADmtOyN9JRCX8aVdNs+tDFhUQuM6sSQ+dFfUA@mail.gmail.com>
	<508F9724.50804@linaro.org>
Date: Tue, 30 Oct 2012 14:33:19 +0530
Message-ID: <CAKohpon8C5O4U+h3nr=8gaEQ1f-K9pqafw=5jPrhaGup_3re=g@mail.gmail.com>
Subject: Re: [PATCH] net: dsa/slave: Fix compilation warnings
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>, netdev@vger.kernel.org,
        linaro-dev@lists.linaro.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 October 2012 14:30, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> It is very curious if we disable all the configs option, a slave
> creation raise a BUG (cf. dsa_slave_create). IIUC, booting with NET_DSA
> enabled and none of the NET_DSA_TAG* enabled will raise a BUG in the
> probe function, right ?
>
> Maybe we should force at least one config when none are set ?

I thought of it earlier. But found the one which i posted better. As we will not
compile DSA stuff now without these tags.

--
viresh

> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index 274791c..86326e3 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -1,8 +1,9 @@
> -config NET_DSA
> +menuconfig NET_DSA
>         tristate "Distributed Switch Architecture support"
>         default n
>         depends on EXPERIMENTAL && NETDEVICES && !S390
>         select PHYLIB
> +       select NET_DSA_TAG_DSA if (!NET_DSA_TAG_EDSA &&
> !NET_DSA_TAG_TRAILER)
>         ---help---
>           This allows you to use hardware switch chips that use
>           the Distributed Switch Architecture.
> @@ -12,15 +13,15 @@ if NET_DSA
>
>  # tagging formats
>  config NET_DSA_TAG_DSA
> -       bool
> +       bool "tag dsa"
>         default n
>
>  config NET_DSA_TAG_EDSA
> -       bool
> +       bool "tag edsa"
>         default n
>
>  config NET_DSA_TAG_TRAILER
> -       bool
> +       bool "tag trailer"
>         default n
>
>  endif
>
>
> --
>  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
>
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
>
