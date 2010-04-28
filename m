Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab0D1JlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 05:41:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab0D1JlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 05:41:17 -0400
References: <20100427154917.405e21df.sfr@canb.auug.org.au>
Message-Id: <DB60B93C-DFAC-4D99-8E3C-364DAF433A07@suse.de>
From: Alexander Graf <agraf@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20100427154917.405e21df.sfr@canb.auug.org.au>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7E18)
Mime-Version: 1.0 (iPhone Mail 7E18)
Subject: Re: linux-next: build failure after merge of the final tree
Date: Wed, 28 Apr 2010 10:41:38 +0100
Cc: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 27.04.2010 um 06:49 schrieb Stephen Rothwell <sfr@canb.auug.org.au>:

> Hi all,
>
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>
> arch/powerpc/kvm/book3s.c: In function 'kvmppc_core_vcpu_create':
> arch/powerpc/kvm/book3s.c:1241: error: implicit declaration of  
> function 'kzalloc'
> arch/powerpc/kvm/book3s.c:1241: warning: cast to pointer from  
> integer of different size
> arch/powerpc/kvm/book3s.c:1281: error: implicit declaration of  
> function 'kfree'
>
> Caused by commit 046cdc052ffcbf1ee1c627ef811031d18654bafe ("KVM: PPC:
> Improve indirect svcpu accessors") from the kvm tree.
>
> You have to include slab.h directly to use kzalloc/kfree ...
>
> I have applied the following patch for today.

Thank you. Is that behavior new? I didn't get any breakage when  
compile testing myself.

Will this commit automatically move back to kvm.git or is there any  
intervention required from my side?


Alex

>
