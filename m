Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab2GYXTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 19:19:20 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:58325 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751456Ab2GYXTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 19:19:17 -0400
Message-ID: <50107EB7.8000009@xenotime.net>
Date: Wed, 25 Jul 2012 16:18:15 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Salar Ali Mumtaz <salaarali@gmail.com>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xconfig: Display dependency values in debug_info
References: <1343256982-11421-1-git-send-email-salaarali@gmail.com>
In-Reply-To: <1343256982-11421-1-git-send-email-salaarali@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 03:56 PM, Salar Ali Mumtaz wrote:

> Displays the current value of each of the dependencies of a menu item.
> Before, you needed to do tedious searching to find out the current values
> of the dependences. Now they all are included in the debug_info, making
> the task easier

Hi,
Would you please provide before and after examples?

I use xconfig quite a lot and it already shows me, e.g., for
CONFIG_DRM:


Symbol: DRM [=y]
Type : tristate
Prompt: Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)
Defined at drivers/gpu/drm/Kconfig:7
Depends on: HAS_IOMEM [=y] && (AGP [=y] || AGP [=y]=n) && !EMULATED_CMPXCHG && MMU [=y]
Location:
-> Device Drivers
-> Graphics support
Selects: I2C [=y] && I2C_ALGOBIT [=y] && DMA_SHARED_BUFFER [=y]




so what and where does this patch add debug info?

Thanks.


> Signed-off-by: Salar Ali Mumtaz <salaarali@gmail.com>
> ---
>  scripts/kconfig/qconf.cc |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
> index df274fe..abd500f 100644
> --- a/scripts/kconfig/qconf.cc
> +++ b/scripts/kconfig/qconf.cc
> @@ -1073,8 +1073,10 @@ QString ConfigInfoView::debug_info(struct symbol *sym)
>  		debug += " (choice)";
>  	debug += "<br>";
>  	if (sym->rev_dep.expr) {
> -		debug += "reverse dep: ";
> +		debug += "reverse dep: (";
>  		expr_print(sym->rev_dep.expr, expr_print_help, &debug, E_NONE);
> +		debug += " )  =";
> +		debug += print_filter(sym_get_string_value(sym));
>  		debug += "<br>";
>  	}
>  	for (struct property *prop = sym->prop; prop; prop = prop->next) {
> @@ -1108,7 +1110,10 @@ QString ConfigInfoView::debug_info(struct symbol *sym)
>  		}
>  		if (prop->visible.expr) {
>  			debug += "&nbsp;&nbsp;&nbsp;&nbsp;dep: ";
> +			debug += " ( ";
>  			expr_print(prop->visible.expr, expr_print_help, &debug, E_NONE);
> +			debug += " )  =";
> +			debug += print_filter(sym_get_string_value(sym));
>  			debug += "<br>";
>  		}
>  	}
> @@ -1157,6 +1162,9 @@ void ConfigInfoView::expr_print_help(void *data, struct symbol *sym, const char
>  		*text += QString().sprintf("<a href=\"s%p\">", sym);
>  		*text += str2;
>  		*text += "</a>";
> +		*text += "<b>   ";
> +		*text += print_filter(sym_get_string_value(sym));
> +		*text += "</b>";
>  	} else
>  		*text += str2;
>  }



-- 
~Randy
