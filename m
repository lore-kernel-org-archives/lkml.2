Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab1G2SZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 14:25:30 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:46570 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751765Ab1G2SZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:25:29 -0400
Date: Fri, 29 Jul 2011 11:25:26 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, xiyou.wangcong@gmail.com, lacombar@gmail.com,
        sam@ravnborg.org, linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com
Subject: Re: [PATCH] kconfig: Introduce IS_ENABLED(), IS_BUILTIN() and
 IS_MODULE()
Message-Id: <20110729112526.db528361.rdunlap@xenotime.net>
In-Reply-To: <1311947497-4958-1-git-send-email-mmarek@suse.cz>
References: <1311634718-32588-1-git-send-email-mmarek@suse.cz>
	<1311947497-4958-1-git-send-email-mmarek@suse.cz>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011 15:51:37 +0200 Michal Marek wrote:

> Replace the config_is_*() macros with a variant that allows for grepping
> for usage of CONFIG_* options in the code. Usage:
> 
>   if (IS_ENABLED(CONFIG_NUMA))
> 
> or
> 
>   #if IS_ENABLED(CONFIG_NUMA)
> 
> The IS_ENABLED() macro evaluates to 1 if the argument is set (to either 'y'
> or 'm'), IS_BUILTIN() tests if the option is 'y' and IS_MODULE() test if
> the option is 'm'. Only boolean and tristate options are supported.
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
> 
> Everybody happy with the above naming?

Yes here.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

These strings are being written to the .config file, right?

> +		/*
> +		 * Generate the __enabled_CONFIG_* and
> +		 * __enabled_CONFIG_*_MODULE macros for use by the
> +		 * IS_{ENABLED,BUILTIN,MODULE} macros. The _MODULE variant is
> +		 * generated even for booleans so that the IS_ENABLED() macro
> +		 * works.
> +		 */
> +		fprintf(fp, "#define __enabled_" CONFIG_ "%s %d\n",
> +				sym->name, (*value == 'y'));
> +		fprintf(fp, "#define __enabled_" CONFIG_ "%s_MODULE %d\n",
> +				sym->name, (*value == 'm'));
>  		break;


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
