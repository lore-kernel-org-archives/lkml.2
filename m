Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab1AIODt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 09:03:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56098 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1AIODr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 09:03:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/2] kbuild: asm-generic support
Date: Sun, 9 Jan 2011 15:03:33 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-kbuild" <linux-kbuild@vger.kernel.org>,
        linux arch <linux-arch@vger.kernel.org>,
        Guan Xuetao <guanxuetao@mprc.pku.edu.cn>,
        Michal Marek <mmarek@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>
References: <20110108130302.GA21698@merkur.ravnborg.org> <20110109082851.GA10463@merkur.ravnborg.org> <20110109083125.GA17045@merkur.ravnborg.org>
In-Reply-To: <20110109083125.GA17045@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101091503.34783.arnd@arndb.de>
X-Provags-ID: V02:K0:WGRjMJQCoGCMezd9u/kN/dsSVvLjU0i0RtOQygiMKDO
 59BDVywJOSnMOJS9LE1p/H7uho5vStZ9gOB9REP3L2h3bBzGRL
 bryXT58LzZUztkSKyZeo0USEm9iG8TAw9pis68kA5aHO369qiy
 lovC9+95dTCBXLRix+AVY8lXULcSjSkg5mTS2Z3sPOuLnGRjP/
 B1AVu1gXQaqDEe+490DFg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

Looks much cleaner to me now, but I still don't see why we even need
the new generic-export-y variable in addition to export-y. Can't we
just simply install all $(filter-out, $(generated-y), $(header-y))
from arch/$(SRCARCH)/include/asm and all $(filter, $(generated-y),
$(header-y)) from rch/$(SRCARCH)/include/generated/asm?

I think that would lead to a less confusing set of rules.

On Sunday 09 January 2011, Sam Ravnborg wrote:
>  ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
>                   $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
> -header-y  += kvm.h
> +generic-export-y  += kvm.h
>  endif
>  
>  ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
>                   $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
> -header-y  += kvm_para.h
> +generic-export-y  += kvm_para.h
>  endif
>  
>  ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
>                   $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
> -header-y += a.out.h
> +generic-export-y += a.out.h
>  endif

We can probably use the opportunity to clean this up as well, I never
like the idea of conditionalizing the installation of a header on the
presence of the file. Instead, we could either generate these headers
from new generic versions of them, or just put the header-y+= into
arch/$(SRCARCH)/include/asm/Kbuild where it belonged in the first
place.

The Kbuild.asm file was initially meant to list the files that are
exported from every architecture, so we could see the exact differences
in each architecture from its asm/Kbuild file.

	Arnd
