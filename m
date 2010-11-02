Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab0KBEWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 00:22:01 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27306 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab0KBEVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 00:21:55 -0400
Date: Tue, 2 Nov 2010 05:11:19 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH] KVM x86: remove memset, use vzalloc and don't assign
 the same value to a variable twice
In-Reply-To: <20101102104934.ecd779dd.yoshikawa.takuya@oss.ntt.co.jp>
Message-ID: <alpine.LNX.2.00.1011020509590.11973@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010302020150.1572@swampdragon.chaosbits.net> <4CCE0EB2.9070302@oss.ntt.co.jp> <alpine.LNX.2.00.1011011924440.9616@swampdragon.chaosbits.net> <20101102104934.ecd779dd.yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Nov 2010, Takuya Yoshikawa wrote:

> Hi Jesper, (dropped some addresses from Cc)
> 
> > > Jesper Juhl wrote:
> > There's definately a positive size impact for the generated object code 
> > and we save having to do the call to memset() and the cost of a vzalloc() 
> > call looks more or less the same as a call to vmalloc() to me.
> 
> > > This patch is not based on kvm.git, I guess.
> > > 
> > Nope. It was generated against mainline git as of a couple of days ago. I 
> > can generate a version against kvm.git if you prefer.
> 
> Sorry, I should have said more clearly.
> 
> kvm_vm_ioctl_get_dirty_log() has been changed since latest mainline kernel was released.
> Furthermore, vmalloc() in it is to be removed soon, currently in kvm's next.
> 
> I have checked all vmalloc() + memset() in kvm, and there are three remaining.
> See the patch below.
>   - I have tested on x86.
>   - I can test ppc later if needed, but this is so trivial that Alex will see
>     no problem about this, probably.
> 
> So please write your Signed-off-by and ask Avi and Marcelo to apply.
> 
> Thanks,
>   Takuya
> 
> ===
> Subject: [PATCH] KVM: replace vmalloc and memset with vzalloc
> 
> Let's use newly introduced vzalloc().
> 
> Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>

Signed-off-by: Jesper-juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

