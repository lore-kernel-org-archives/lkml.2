Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab0HCQnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 12:43:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42042 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180Ab0HCQnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 12:43:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uhrc+Wqshi09OKMNm3lYxbZGdDJGNf+VGV16Gv8UALOoXY1JeTI++2QsjZCCmiAhZR
         Zi2Sj7rEJH+fATRb862mTanGSW4B+61z+G8UiRCu6ha/CBxGIWF+P2uNoJiskqJR1nTS
         D7/ATD1elnfLrXaE7/lFXmQJ6cpPvFzYKL1Pc=
Date: Tue, 3 Aug 2010 22:12:47 +0530
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 07/10] ftrace: pass KBUILD_CFLAGS to record_mcount.pl
Message-ID: <20100803164247.GA6133@debian>
References: <1268462987-8271-1-git-send-email-rabin@rab.in>
 <1268462987-8271-8-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268462987-8271-8-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven, Frederic,

I'd like to resurrect this old ARM dynamic ftrace patchset.  It still
applies on next except for a small merge conflict in one of the
ARM-specific patches.

On Sat, Mar 13, 2010 at 12:19:44PM +0530, Rabin Vincent wrote:
> On ARM, we have two ABIs, and the ABI used is controlled via a config
> option.  Object files built with one ABI can't be merged with object
> files built with the other ABI.  So, record_mcount.pl needs to use the
> same compiler flags as the kernel when generating the object file with
> the mcount locations.  Ensure this by passing CFLAGS to the script.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>

This is the only non-arch/arm/ patch in the series which doesn't have
either of your Acked-bys, so if you'd be willing to ack it, I'll send in
the lot via rmk's ARM patch system for .37.

Alternatively, this one and "[PATCH 03/10] ftrace: allow building
without frame pointers" could go in via the tracing tree for .36?  Then
I'll send in the ARM specific stuff for .37 via the ARM tree.

Thanks,
Rabin

> ---
>  scripts/Makefile.build |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 0b94d2f..2535c11 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -209,7 +209,8 @@ ifdef CONFIG_FTRACE_MCOUNT_RECORD
>  cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
>  	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
>  	"$(if $(CONFIG_64BIT),64,32)" \
> -	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
> +	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
> +	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
>  	"$(if $(part-of-module),1,0)" "$(@)";
>  endif
>  
> -- 
> 1.7.0
> 
