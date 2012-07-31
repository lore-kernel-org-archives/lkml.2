Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab2GaXam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 19:30:42 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:33889 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754811Ab2GaXak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 19:30:40 -0400
Message-ID: <50183E67.1060509@xenotime.net>
Date: Tue, 31 Jul 2012 13:21:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Salar Ali Mumtaz <salaarali@gmail.com>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xconfig: Display dependency values in debug_info
References: <1343256982-11421-1-git-send-email-salaarali@gmail.com> <50107EB7.8000009@xenotime.net> <CA+jpPM=nrbpDJpaka6xAp4dbEOQjJrtwQWtUXwi_gGS9b4yK-A@mail.gmail.com> <50117812.5080302@xenotime.net> <50182ACF.6070704@gmail.com>
In-Reply-To: <50182ACF.6070704@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 11:58 AM, Salar Ali Mumtaz wrote:

> Now the debug_info only shows y/n/m values.
> 


or no value at all??

for CONFIG_BINFMT_ELF:



Kernel support for ELF binaries (BINFMT_ELF)

type: boolean
unknown property: symbol
    dep: ( MMU y && (BROKEN n || !FRV ) ) =y
prompt: Kernel support for ELF binaries
    dep: ( MMU y && (BROKEN n || !FRV ) ) =y
default: y
    dep: ( MMU y && (BROKEN n || !FRV ) ) =y

defined at fs/Kconfig.binfmt:1

CONFIG_BINFMT_ELF:





> Signed-off-by: Salar Ali Mumtaz <salaarali@gmail.com>
> ---
>  scripts/kconfig/qconf.cc |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
> index df274fe..b6a7cc5 100644
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
> @@ -1152,11 +1157,18 @@ void ConfigInfoView::expr_print_help(void *data, struct symbol *sym, const char
>  {
>  	QString* text = reinterpret_cast<QString*>(data);
>  	QString str2 = print_filter(str);
> +	QString value;
>  
>  	if (sym && sym->name && !(sym->flags & SYMBOL_CONST)) {
> +		value = print_filter(sym_get_string_value(sym));
> +
>  		*text += QString().sprintf("<a href=\"s%p\">", sym);
>  		*text += str2;
>  		*text += "</a>";
> +		*text += "<b>   ";
> +		if(value == "y" || value == "m" || value == "n")
> +			*text += print_filter(sym_get_string_value(sym));
> +		*text += "</b>";
>  	} else
>  		*text += str2;
>  }



thanks,
-- 
~Randy
