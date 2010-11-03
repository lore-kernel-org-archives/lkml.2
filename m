Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab0KCNpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 09:45:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab0KCNoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 09:44:55 -0400
Date: Wed, 3 Nov 2010 10:47:11 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH] KVM x86: remove memset, use vzalloc and don't assign the
 same value to a variable twice
Message-ID: <20101103124711.GB16809@amt.cnet>
References: <alpine.LNX.2.00.1010302020150.1572@swampdragon.chaosbits.net>
 <4CCE0EB2.9070302@oss.ntt.co.jp>
 <alpine.LNX.2.00.1011011924440.9616@swampdragon.chaosbits.net>
 <20101102104934.ecd779dd.yoshikawa.takuya@oss.ntt.co.jp>
 <alpine.LNX.2.00.1011020509590.11973@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011020509590.11973@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 05:11:19AM +0100, Jesper Juhl wrote:
> On Tue, 2 Nov 2010, Takuya Yoshikawa wrote:
> 
> > Hi Jesper, (dropped some addresses from Cc)
> > 
> > > > Jesper Juhl wrote:
> > > There's definately a positive size impact for the generated object code 
> > > and we save having to do the call to memset() and the cost of a vzalloc() 
> > > call looks more or less the same as a call to vmalloc() to me.
> > 
> > > > This patch is not based on kvm.git, I guess.
> > > > 
> > > Nope. It was generated against mainline git as of a couple of days ago. I 
> > > can generate a version against kvm.git if you prefer.
> > 
> > Sorry, I should have said more clearly.
> > 
> > kvm_vm_ioctl_get_dirty_log() has been changed since latest mainline kernel was released.
> > Furthermore, vmalloc() in it is to be removed soon, currently in kvm's next.
> > 
> > I have checked all vmalloc() + memset() in kvm, and there are three remaining.
> > See the patch below.
> >   - I have tested on x86.
> >   - I can test ppc later if needed, but this is so trivial that Alex will see
> >     no problem about this, probably.
> > 
> > So please write your Signed-off-by and ask Avi and Marcelo to apply.
> > 
> > Thanks,
> >   Takuya
> > 
> > ===
> > Subject: [PATCH] KVM: replace vmalloc and memset with vzalloc
> > 
> > Let's use newly introduced vzalloc().
> > 
> > Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
> 
> Signed-off-by: Jesper-juhl <jj@chaosbits.net>

Applied, thanks.


