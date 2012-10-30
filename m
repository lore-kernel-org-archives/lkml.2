Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2J3Hxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 03:53:37 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46830 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab2J3Hxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 03:53:35 -0400
Message-ID: <508F8779.8070300@linaro.org>
Date: Tue, 30 Oct 2012 08:53:29 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Ben Hutchings <bhutchings@solarflare.com>, netdev@vger.kernel.org,
        linaro-dev@lists.linaro.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH] net: dsa/slave: Fix compilation warnings
References: <5afab1ebe83e4361f1fd75bbea0c559af195bf02.1351529738.git.viresh.kumar@linaro.org> <1351540778.2721.7.camel@bwh-desktop.uk.solarflarecom.com> <CAKohponL_3m2KVytiWm8ZHyB5aimk8CzGrqr5J0LMy8MFGodHg@mail.gmail.com> <CAKohponOKk5e2Sxyhjw-XvzVxF3tNp66rsnYCwvwHazAPAauKw@mail.gmail.com>
In-Reply-To: <CAKohponOKk5e2Sxyhjw-XvzVxF3tNp66rsnYCwvwHazAPAauKw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2012 08:31 AM, Viresh Kumar wrote:
> On 30 October 2012 12:15, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> And so, if we select NET_DSA from these tagging drivers, then only slave.c will
>> get compiled. Otherwise slave.c dsa.c dsa_core.c wouldn't be compiled and so
>> no warnings.
> 
> If my above explanation/assumption is correct, then please review following
> patch:
> 
> --------------------------x-----------------------x----------------
> 
> From: Viresh Kumar <viresh.kumar@linaro.org>
> Date: Mon, 29 Oct 2012 22:19:14 +0530
> Subject: [PATCH] net: dsa/slave: Fix compilation warnings
> 
> Currently when none of CONFIG_NET_DSA_TAG_DSA, CONFIG_NET_DSA_TAG_EDSA and
> CONFIG_NET_DSA_TAG_TRAILER is defined, we get following compilation warnings:
> 
> net/dsa/slave.c:51:12: warning: 'dsa_slave_init' defined but not used
> [-Wunused-function]
> net/dsa/slave.c:60:12: warning: 'dsa_slave_open' defined but not used
> [-Wunused-function]
> net/dsa/slave.c:98:12: warning: 'dsa_slave_close' defined but not used
> [-Wunused-function]
> net/dsa/slave.c:116:13: warning: 'dsa_slave_change_rx_flags' defined
> but not used [-Wunused-function]
> net/dsa/slave.c:127:13: warning: 'dsa_slave_set_rx_mode' defined but
> not used [-Wunused-function]
> net/dsa/slave.c:136:12: warning: 'dsa_slave_set_mac_address' defined
> but not used [-Wunused-function]
> net/dsa/slave.c:164:12: warning: 'dsa_slave_ioctl' defined but not
> used [-Wunused-function]
> 
> Earlier approach to fix this was discussed here:
> 
> lkml.org/lkml/2012/10/29/549
> 
> This is another approach to fix it. This is done by some changes in config
> options, which make more sense than the earlier approach. As, atleast one
> tagging option must always be selected for using net/dsa/ infrastructure, this
> patch selects NET_DSA from tagging configs instead of having it as an selectable
> config.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/net/dsa/Kconfig |  1 -
>  net/dsa/Kconfig         | 16 +++++++++-------
>  2 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
> index dd151d5..96eae22 100644
> --- a/drivers/net/dsa/Kconfig
> +++ b/drivers/net/dsa/Kconfig
> @@ -1,5 +1,4 @@
>  menu "Distributed Switch Architecture drivers"
> -	depends on NET_DSA
> 
>  config NET_DSA_MV88E6XXX
>  	tristate
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index 274791c..f7c6cef 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -1,5 +1,5 @@
>  config NET_DSA
> -	tristate "Distributed Switch Architecture support"
> +	tristate
>  	default n
>  	depends on EXPERIMENTAL && NETDEVICES && !S390
>  	select PHYLIB
> @@ -8,19 +8,21 @@ config NET_DSA
>  	  the Distributed Switch Architecture.
> 
> 
> -if NET_DSA
> +menu "Distributed Switch Architecture support"
> 
>  # tagging formats
>  config NET_DSA_TAG_DSA
> -	bool
> +	bool "Original DSA packet tagging format"
> +	select NET_DSt

typo NET_DSA

>  	default n
> 
>  config NET_DSA_TAG_EDSA
> -	bool
> +	bool "Ethertype DSA packet tagging format"
> +	select NET_DSA
>  	default n
> 
>  config NET_DSA_TAG_TRAILER
> -	bool
> +	bool "Trailer DSA packet tagging format"
> +	select NET_DSA
>  	default n
> -
> -endif
> +endmenu
> 
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

