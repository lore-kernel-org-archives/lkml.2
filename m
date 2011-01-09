Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab1AIQNO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 11:13:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55918 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab1AIQNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 11:13:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/2] kbuild: asm-generic support
Date: Sun, 9 Jan 2011 17:13:01 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-kbuild" <linux-kbuild@vger.kernel.org>,
        linux arch <linux-arch@vger.kernel.org>,
        Guan Xuetao <guanxuetao@mprc.pku.edu.cn>,
        Michal Marek <mmarek@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>
References: <20110108130302.GA21698@merkur.ravnborg.org> <201101091503.34783.arnd@arndb.de> <20110109151041.GA17237@merkur.ravnborg.org>
In-Reply-To: <20110109151041.GA17237@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101091713.02243.arnd@arndb.de>
X-Provags-ID: V02:K0:7lQ1gt/9UeLef+DNc/PYWLnQJ8yskShPH30tnpFXP1b
 96RwnJQv1tcbYOCWoGVGpeKyHl0SawOax9REw8JrI82HqD3/+8
 +cH6Aum2lqm/F06ul+3Xn13NGWfQwdxKTeT+fcIZ903SRuMpCw
 n57U5dy02/lXfuT5Ydbod6DKYoUA2ksHn9i02yKg8At6Pf5HxD
 8mQL14wzUccjrhgZuAD1g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 January 2011, Sam Ravnborg wrote:
> @@ -31,10 +31,10 @@ check-file    := $(install)/.check
>  # generic-export-y list all generic headers to be exported
>  # generic-y list all files an architecture uses from asm-generic
>  # Use this to build a list of headers which require a wrapper
> -wrapper-files := $(filter $(generic-export-y), $(generic-y))
> +wrapper-files := $(filter $(header-y), $(generic-y))
>  
>  # all headers files for this dir
> -header-y      := $(filter-out $(wrapper-files), $(header-y))
> +header-y      := $(filter-out $(generic-y), $(header-y))
>  all-files     := $(header-y) $(objhdr-y) $(generic-y)
>  input-files   := $(addprefix $(_src)/,$(header-y)) \
>                   $(addprefix $(objtree)/$(obj)/,$(objhdr-y))
> 
> And then reverting the changes to Kbuild.asm.
> Yes this works - and is much simpler. Good!

Ok, excellent!

	Arnd
