Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab1HBRdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 13:33:51 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:48848 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab1HBRdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 13:33:45 -0400
Date: Tue, 2 Aug 2011 19:33:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, xiyou.wangcong@gmail.com,
        rdunlap@xenotime.net, lacombar@gmail.com, linux-kernel@vger.kernel.org,
        plagnioj@jcrosoft.com
Subject: Re: [PATCH] kconfig: Introduce IS_ENABLED(), IS_BUILTIN() and
	IS_MODULE()
Message-ID: <20110802173343.GA5251@merkur.ravnborg.org>
References: <1311634718-32588-1-git-send-email-mmarek@suse.cz> <1311947497-4958-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311947497-4958-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 03:51:37PM +0200, Michal Marek wrote:
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
Naming is good - has my ack.


> 
> ---
>  Makefile                   |    2 +-
>  include/linux/kconfig.h    |   32 ++++++++++++++++++++
>  scripts/kconfig/confdata.c |   71 ++++++++-----------------------------------
>  3 files changed, 47 insertions(+), 58 deletions(-)
>  create mode 100644 include/linux/kconfig.h
> 
> diff --git a/Makefile b/Makefile
> index afb8e0d..bd7629b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -360,7 +360,7 @@ CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
>  LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include \
>                     -Iarch/$(hdr-arch)/include/generated -Iinclude \
>                     $(if $(KBUILD_SRC), -I$(srctree)/include) \
> -                   -include include/generated/autoconf.h
> +                   -include $(srctree)/include/linux/kconfig.h

If we do it like this then how about adding this to autoconf.h and avoid the extra file,
and the extra flag to gcc?

	Sam
