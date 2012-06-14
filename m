Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab2FNDaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 23:30:00 -0400
Received: from linux-sh.org ([111.68.239.195]:42987 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099Ab2FND36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 23:29:58 -0400
Date: Thu, 14 Jun 2012 12:29:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Linux/m68k" <linux-m68k@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: asm/kvm_para.h from asm-generic (was: Re: linux-next: triage for
 April 19, 2012)
Message-ID: <20120614032948.GD27673@linux-sh.org>
References: <CAMuHMdW9D4FZSUibcd+qrtM+is75FyJXj+RxK+sb33XEjczdyg@mail.gmail.com>
 <CAMuHMdVM3zn_OUAtGTV_O0d3yFWBM5b_6ORHxaMLVE27Cf_XrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVM3zn_OUAtGTV_O0d3yFWBM5b_6ORHxaMLVE27Cf_XrQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 02:46:32PM +0200, Geert Uytterhoeven wrote:
> There's a similar rule for kvm_para.h:
> 
> ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
>                   $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
> header-y  += kvm_para.h
> endif
> 
> It's this rule that's now biting m68k, as it no longer works when using
> arch/*/include/asm/Kbuild to import <asm-generic/kvm_para.h>.
> (I guess it'll bite SH soon, too).
> 
So it did, thanks for catching it, today looks to be chock full of header
excitement.

> I found two ways to fix it:
>   1. Remove the "ifneq" above from include/asm-generic/Kbuild.asm,
>      so kvm_para.h is exported unconditionally.
>      Note that this breaks m32r and cris, as they don't have
> asm/kvm_para.h yet),
>    2. Add a similar "ifneq" to include/asm-generic/Kbuild, to make
>      the export of <linux/kvm_para.h> conditional.
>      I guess we want to remove all "dummy" kvm_para.h again, too?
> 
m32r and cris are broken at the moment anyways because they were
overlooked to begin with, so stubbing in generic-y += kvm_para.h rules
there should be sufficient. Presumably with those in place it should be
possible to kill off the wildcarding and just have it exported
unconditionally, as per your initial fix.

As to the merit of exporting a header with nothing in it to userspace,
Avi will have to figure that one out.
