Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2FSTAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 15:00:14 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:53443 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab2FSTAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 15:00:10 -0400
Date: Tue, 19 Jun 2012 21:00:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux/m68k <linux-m68k@vger.kernel.org>, kvm@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: asm/kvm_para.h from asm-generic (was: Re: linux-next: triage
	for April 19, 2012)
Message-ID: <20120619190008.GA11092@merkur.ravnborg.org>
References: <CAMuHMdW9D4FZSUibcd+qrtM+is75FyJXj+RxK+sb33XEjczdyg@mail.gmail.com> <CAMuHMdVM3zn_OUAtGTV_O0d3yFWBM5b_6ORHxaMLVE27Cf_XrQ@mail.gmail.com> <20120619184803.GA31656@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120619184803.GA31656@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 08:48:03PM +0200, Sam Ravnborg wrote:
> > >>
> > >> I just noticed include/asm-generic/Kbuild.asm already had
> > >>
> > >> ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
> > >>                  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
> > >> header-y  += kvm_para.h
> > >> endif
> > >>
> > >> but this doesn't seem to work.
> > >>
> > >> Kbuild people: which one is correct?
> 
> Any use of wildcards in include/asm-generic/Kbuild.asm is bogus.
> We should:
> 1) add explicit header-y for kvm.h + a.out.h to the relevant architectures.
> 2) add explicit header-y for kvm_para.h for the archictectures that needs this file
> 3) and drop header-y / dummy file fro the others.
> 
> Anything else is just papering over the initial wrong doings.
> 
> I actually coded up "header-n" support to explicitly say:
> do not include this file for this arch - but looking at the
> actual problem being solved this is just bogus so I killed
> it off again.

Just to be clear - I know this will break headers_check_all.
I will try to take a look soon for a better generic solution.

	Sam
