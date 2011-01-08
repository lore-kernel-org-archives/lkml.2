Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab1AHA77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 19:59:59 -0500
Received: from adelie.canonical.com ([91.189.90.139]:37277 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab1AHA76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 19:59:58 -0500
Message-ID: <4D27B70A.3090706@canonical.com>
Date: Fri, 07 Jan 2011 16:59:54 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] apparmor: cleanup generated files correctly
References: <20110107141453.GD1891@tiehlicka.suse.cz>
In-Reply-To: <20110107141453.GD1891@tiehlicka.suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2011 06:14 AM, Michal Hocko wrote:
> Hi John,
> could you consider the patch bellow. The issue is minor but I guess it
> is worth having fixed.
certainly thanks for the fix, I'll pull into the AA tree and push up with
a couple of other fixes I have pending

Acked-by: John Johansen <john.johansen@canonical.com>

> ---
> From a6b164aeff1234708595d06dd6f9abeb59564da6 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Fri, 7 Jan 2011 15:03:02 +0100
> Subject: [PATCH] apparmor: cleanup generated files correctly
> 
> clean-files should be defined as a variable not a target.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  security/apparmor/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/apparmor/Makefile b/security/apparmor/Makefile
> index f204869..bbb942a 100644
> --- a/security/apparmor/Makefile
> +++ b/security/apparmor/Makefile
> @@ -6,7 +6,7 @@ apparmor-y := apparmorfs.o audit.o capability.o context.o ipc.o lib.o match.o \
>                path.o domain.o policy.o policy_unpack.o procattr.o lsm.o \
>                resource.o sid.o file.o
>  
> -clean-files: capability_names.h af_names.h
> +clean-files := capability_names.h af_names.h
>  
>  quiet_cmd_make-caps = GEN     $@
>  cmd_make-caps = echo "static const char *capability_names[] = {" > $@ ; sed -n -e "/CAP_FS_MASK/d" -e "s/^\#define[ \\t]\\+CAP_\\([A-Z0-9_]\\+\\)[ \\t]\\+\\([0-9]\\+\\)\$$/[\\2]  = \"\\1\",/p" $< | tr A-Z a-z >> $@ ; echo "};" >> $@

