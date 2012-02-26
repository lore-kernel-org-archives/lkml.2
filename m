Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab2BZRsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 12:48:09 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:49466 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2BZRsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 12:48:08 -0500
Date: Sun, 26 Feb 2012 18:48:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Bernhard Walle <bernhard@bwalle.de>
Cc: mmarek@suse.cz, lacombar@gmail.com, linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] scripts/Kbuild.include: Fix portability problem of
	"echo -e"
Message-ID: <20120226174805.GA562@merkur.ravnborg.org>
References: <1330277718-2667-1-git-send-email-bernhard@bwalle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330277718-2667-1-git-send-email-bernhard@bwalle.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 06:35:18PM +0100, Bernhard Walle wrote:
> "echo -e" is a GNU extension. When cross-compiling the kernel on a
> BSD-like operating system (Mac OS X in my case), this doesn't work.
> 
> One could install a GNU version of echo, put that in the $PATH before
> the system echo and use "/usr/bin/env echo", but the solution with
> printf is simpler.
> 
> Since it is no disadvantage on Linux, I hope that gets accepted even if
> cross-compiling the Linux kernel on another Unix operating system is
> quite a rare use case.
> 
> Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
> ---
>  scripts/Kbuild.include |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
> index d897278..6a3ee98 100644
> --- a/scripts/Kbuild.include
> +++ b/scripts/Kbuild.include
> @@ -104,7 +104,7 @@ as-option = $(call try-run,\
>  # Usage: cflags-y += $(call as-instr,instr,option1,option2)
>  
>  as-instr = $(call try-run,\
> -	/bin/echo -e "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
> +	printf "%b\n" "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
>  
>  # cc-option
>  # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)

Roman Zippel removed use of printf in this patch: beda9f3a13bbb22cde92a45f230a02ef2afef6a9

I cannot remember why - but it would be good if you could dig up
why - just so we do not hit an old issue again.

	Sam
