Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab2FRNUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 09:20:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52694 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2FRNUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 09:20:16 -0400
Date: Mon, 18 Jun 2012 22:20:10 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, mtosatti@redhat.com,
        agraf@suse.de, paulus@samba.org, aarcange@redhat.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: MMU: Make kvm_handle_hva() handle range of
 addresses
Message-Id: <20120618222010.4b605f800956e3c7bf6bcd25@gmail.com>
In-Reply-To: <4FDF1AFE.4000607@redhat.com>
References: <20120615203007.4f61bb17.yoshikawa.takuya@oss.ntt.co.jp>
	<20120615203230.2c577652.yoshikawa.takuya@oss.ntt.co.jp>
	<4FDF1AFE.4000607@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012 15:11:42 +0300
Avi Kivity <avi@redhat.com> wrote:


> >  	kvm_for_each_memslot(memslot, slots) {
> > -		gfn_t gfn = hva_to_gfn(hva, memslot);
> > +		gfn_t gfn = hva_to_gfn(start_hva, memslot);
> > +		gfn_t end_gfn = hva_to_gfn(end_hva, memslot);
> 
> These will return random results which you then use in min/max later, no?

Yes, I will follow your advice: check-then-convert (or check-and-convert).

> > @@ -1212,7 +1218,9 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
> >  				rmapp = __gfn_to_rmap(gfn, j, memslot);
> >  				ret |= handler(kvm, rmapp, data);
> 
> Potential for improvement: don't do 512 iterations on same large page.
> 
> Something like
> 
>     if ((gfn ^ prev_gfn) & mask(level))
>         ret |= handler(...)
> 
> with clever selection of the first prev_gfn so it always matches (~gfn
> maybe).

Really nice.
I'm sure that will make this much faster!

Thanks,
	Takuya
