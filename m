Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab1EBPiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:38:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152Ab1EBPiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:38:15 -0400
Date: Mon, 2 May 2011 17:38:13 +0200
From: Michal Marek <mmarek@suse.cz>
To: Valdis.Kletnieks@vt.edu
Cc: bp@alien8.de, sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] kbuild: Allow to combine multiple W= levels
Message-ID: <20110502153813.GC15769@sepie.suse.cz>
References: <71633.1304013549@localhost>
 <1304083893-18849-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304083893-18849-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 03:31:33PM +0200, Michal Marek wrote:
> Add support for make W=12, make W=123 and so on, to enable warnings from
> multiple W= levels. Normally, make W=<level> does not include warnings
> from the previous level.
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  scripts/Makefile.build |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 9c0c481..28cef2a 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -60,6 +60,8 @@ endif
>  # $(call cc-option, -W...) handles gcc -W.. options which
>  # are not supported by all versions of the compiler
>  ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
> +warning-  := $(empty)
> +
>  warning-1 := -Wextra -Wunused -Wno-unused-parameter
>  warning-1 += -Wmissing-declarations
>  warning-1 += -Wmissing-format-attribute
> @@ -85,9 +87,11 @@ warning-3 += -Wswitch-default
>  warning-3 += $(call cc-option, -Wpacked-bitfield-compat)
>  warning-3 += $(call cc-option, -Wvla)
>  
> -warning := $(warning-$(KBUILD_ENABLE_EXTRA_GCC_CHECKS))
> +warning := $(warning-$(findstring 1, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
> +warning += $(warning-$(findstring 2, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
> +warning += $(warning-$(findstring 3, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
>  
> -ifeq ("$(warning)","")
> +ifeq ("$(strip $(warning))","")
>          $(error W=$(KBUILD_ENABLE_EXTRA_GCC_CHECKS) is unknown)
>  endif

Pushed to kbuild-2.6.git#kbuild with the following make help update:

diff --git a/Makefile b/Makefile
index 4527dc2..d342502 100644
--- a/Makefile
+++ b/Makefile
@@ -1290,7 +1290,7 @@ help:
 	@echo  '		1: warnings which may be relevant and do not occur too often'
 	@echo  '		2: warnings which occur quite often but may still be relevant'
 	@echo  '		3: more obscure warnings, can most likely be ignored'
-
+	@echo  '		Multiple levels can be combined with W=12 or W=123'
 	@echo  ''
 	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
 	@echo  'For further info see the ./README file'

Michal
