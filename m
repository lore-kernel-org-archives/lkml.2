Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab1KKPZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 10:25:10 -0500
Received: from www17.your-server.de ([213.133.104.17]:38693 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab1KKPZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 10:25:09 -0500
Message-ID: <1321025097.20155.118.camel@localhost.localdomain>
Subject: Re: [PATCH] KVM: PPC: e500: Casting (void *) value returned by
 kmalloc is useless
From: Thomas Meyer <thomas@m3y3r.de>
To: Alexander Graf <agraf@suse.de>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 11 Nov 2011 16:24:57 +0100
In-Reply-To: <4EBD2BB4.3030804@suse.de>
References: <1320779766.8062.143.camel@localhost.localdomain>
	 <4EBD2BB4.3030804@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 11.11.2011, 15:05 +0100 schrieb Alexander Graf:
> On 11/08/2011 08:15 PM, Thomas Meyer wrote:
> > From: Thomas Meyer<thomas@m3y3r.de>
> >
> >   Casting (void *) value returned by kmalloc is useless
> >   as mentioned in Documentation/CodingStyle, Chap 14.
> >
> >   The semantic patch that makes this change is available
> >   in scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci.
> >
> >   More information about semantic patching is available at
> >   http://coccinelle.lip6.fr/
> >
> > Signed-off-by: Thomas Meyer<thomas@m3y3r.de>
> > ---
> >
> > diff -u -p a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
> > --- a/arch/powerpc/kvm/e500_tlb.c 2011-11-07 19:37:27.329638682 +0100
> > +++ b/arch/powerpc/kvm/e500_tlb.c 2011-11-08 09:18:39.955928218 +0100
> > @@ -1026,11 +1026,11 @@ int kvmppc_e500_tlb_init(struct kvmppc_v
> >   	if (vcpu_e500->gtlb_arch[1] == NULL)
> >   		goto err_out_guest0;
> >
> > -	vcpu_e500->gtlb_priv[0] = (struct tlbe_priv *)
> > +	vcpu_e500->gtlb_priv[0] =
> >   		kzalloc(sizeof(struct tlbe_priv) * KVM_E500_TLB0_SIZE, GFP_KERNEL);
> >   	if (vcpu_e500->gtlb_priv[0] == NULL)
> >   		goto err_out_guest1;
> > -	vcpu_e500->gtlb_priv[1] = (struct tlbe_priv *)
> > +	vcpu_e500->gtlb_priv[1] =
> >   		kzalloc(sizeof(struct tlbe_priv) * KVM_E500_TLB1_SIZE, GFP_KERNEL);
> 
> Sorry, I can't seem to find that code anywhere. I suppose you're using 
> an old git checkout?

No, I'm at 3.2-rc1:

https://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=arch/powerpc/kvm/e500_tlb.c#l1029

> 
> 
> Alex
> 



