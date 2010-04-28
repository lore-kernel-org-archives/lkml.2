Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab0D1QWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 12:22:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821Ab0D1QWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 12:22:46 -0400
Date: Wed, 28 Apr 2010 12:21:01 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Avi Kivity <avi@redhat.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20100428152101.GB12091@amt.cnet>
References: <20100427154917.405e21df.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100427154917.405e21df.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 03:49:17PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> arch/powerpc/kvm/book3s.c: In function 'kvmppc_core_vcpu_create':
> arch/powerpc/kvm/book3s.c:1241: error: implicit declaration of function 'kzalloc'
> arch/powerpc/kvm/book3s.c:1241: warning: cast to pointer from integer of different size
> arch/powerpc/kvm/book3s.c:1281: error: implicit declaration of function 'kfree'
> 
> Caused by commit 046cdc052ffcbf1ee1c627ef811031d18654bafe ("KVM: PPC:
> Improve indirect svcpu accessors") from the kvm tree.
> 
> You have to include slab.h directly to use kzalloc/kfree ...
> 
> I have applied the following patch for today.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 27 Apr 2010 15:32:53 +1000
> Subject: [PATCH] kvm: powerpc: use of kzalloc/kfree requires including slab.h
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Applied, thanks.

