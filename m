Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab2FNTXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 15:23:11 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:4490 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755349Ab2FNTXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 15:23:09 -0400
Message-ID: <1339701783.5981.5.camel@x61.thuisdomein>
Subject: Re: [PATCH] init: add comments to keep initcall-names in sync with
 initcall levels
From: Paul Bolle <pebolle@tiscali.nl>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, bp@amd64.org,
        pawel.moll@arm.com, jbaron@redhat.com, gregkh@linuxfoundation.org
Date: Thu, 14 Jun 2012 21:23:03 +0200
In-Reply-To: <1339699862-3731-1-git-send-email-jim.cromie@gmail.com>
References: <20120612105913.GA8404@aftab.osrc.amd.com>
	 <1339699862-3731-1-git-send-email-jim.cromie@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 14 Jun 2012 19:23:04.0034 (UTC) FILETIME=[1EAACC20:01CD4A63]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 12:51 -0600, Jim Cromie wrote:
> main.c has initcall_level_names[] for parse_args to print in debug messages,
> add comments to keep them in sync with initcalls defined in init.h.
> Also tweak comment re not using *_initcall macros in loadable modules.
> 
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  include/linux/init.h |    3 ++-
>  init/main.c          |    1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/init.h b/include/linux/init.h
> index 6b95109..da6f6f9 100644
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -191,6 +191,7 @@ extern bool initcall_debug;
>   * initializes variables that couldn't be statically initialized.
>   *
>   * This only exists for built-in code, not for modules.
> + * Keep main.c:initcall_level_names[] in sync. */
>   */

This comment now ends with "*/" twice. Perhaps that's legal (I haven't
even bothered to check) but it is really too ugly. 

>  #define pure_initcall(fn)		__define_initcall("0",fn,0)
>  
> @@ -280,7 +281,7 @@ void __init parse_early_options(char *cmdline);
>  
>  #else /* MODULE */
>  
> -/* Don't use these in modules, but some people do... */
> +/* Don't use these in loadable modules, but some people do... */

What problem does this solve?

>  #define early_initcall(fn)		module_init(fn)
>  #define core_initcall(fn)		module_init(fn)
>  #define postcore_initcall(fn)		module_init(fn)
> diff --git a/init/main.c b/init/main.c
> index b5cc0a7..7a74087 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -724,6 +724,7 @@ static initcall_t *initcall_levels[] __initdata = {
>  	__initcall_end,
>  };
>  
> +/* Keep these in sync with initcalls in include/linux/init.h */
>  static char *initcall_level_names[] __initdata = {
>  	"early",
>  	"core",


Paul Bolle

