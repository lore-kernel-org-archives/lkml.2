Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab0LFJcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 04:32:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab0LFJcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 04:32:13 -0500
Date: Mon, 6 Dec 2010 11:32:08 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] KVM: MMU: rename 'no_apf' to 'prefault'
Message-ID: <20101206093208.GA15610@redhat.com>
References: <4CF76A8B.2040102@cn.fujitsu.com>
 <20101203203055.GB26281@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101203203055.GB26281@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 06:30:55PM -0200, Marcelo Tosatti wrote:
> On Thu, Dec 02, 2010 at 05:44:43PM +0800, Xiao Guangrong wrote:
> > It's the speculative path if 'no_apf = 1' and we will specially handle this
> > speculative path in the later patch, so 'prefault' is better to fit the sense
> > 
> > Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |    3 ++-
> >  arch/x86/kvm/mmu.c              |   18 +++++++++---------
> >  arch/x86/kvm/paging_tmpl.h      |    4 ++--
> >  3 files changed, 13 insertions(+), 12 deletions(-)
> 
> Looks good to me. Avi, Gleb?
Looks mostly OK to me too. Third patch check only cr3 but cr4 & efer can
affect paging too, but since page fault is not injected anyway in case
of an error and for most guests cr4 & efer shouldn't change frequently I
guess this is OK.

--
			Gleb.
