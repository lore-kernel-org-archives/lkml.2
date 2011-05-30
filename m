Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab1E3NLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:11:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35307 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab1E3NLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:11:54 -0400
Date: Mon, 30 May 2011 14:46:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: Re: KVM build warnings
Message-ID: <20110530124600.GB494@eferding.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	takuya.yoshikawa@gmail.com
References: <20110530094604.GC21833@liondog.tnic>
 <20110530191426.336d23f4.yoshikawa.takuya@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110530191426.336d23f4.yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 07:14:26PM +0900, Takuya Yoshikawa wrote:
> On Mon, 30 May 2011 11:46:04 +0200
> Borislav Petkov <bp@alien8.de> wrote:
> 
> > I get the following
> > 
> > In file included from arch/x86/kvm/mmu.c:2856:
> > arch/x86/kvm/paging_tmpl.h: In function ‘paging32_walk_addr_generic’:
> > arch/x86/kvm/paging_tmpl.h:124: warning: ‘ptep_user’ may be used uninitialized in this function
> > In file included from arch/x86/kvm/mmu.c:2852:
> > arch/x86/kvm/paging_tmpl.h: In function ‘paging64_walk_addr_generic’:
> > arch/x86/kvm/paging_tmpl.h:124: warning: ‘ptep_user’ may be used uninitialized in this function
> > 
> > when building -rc1. It looks like it is caused by
> > 6e2ca7d1802bf8ed9908435e34daa116662e7790 and sticking uninitialized_var() around
> > the ptep_user declaration looks like the easiest solution. But the code should
> > still be audited by someone who's familiar with it whether shutting up the
> > compiler doesn't cause an actual bug.
> 
> Sorry, it is my commit.
> 
> I think the logic guarantees that ptep_user won't be used until it is
> assigned some value.
> 
> It seems to be safe, IIUC.

Ok, thanks for confirming. I'll send a fix soon if no one beats me to
it.

-- 
Regards/Gruss,
Boris.
