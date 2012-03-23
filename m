Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2CXLI5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 07:08:57 -0400
Received: from caiajhbdcbef.dreamhost.com ([208.97.132.145]:50034 "EHLO
	homiemail-a60.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754943Ab2CXLI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 07:08:56 -0400
Subject: Re: [PATCH v2] KVM: x86: add paging gcc optimization
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Avi Kivity <avi@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4F5DE84B.8050606@redhat.com>
References: <1331207154.28711.2.camel@offworld>
	 <4F58D48F.8050807@de.ibm.com>  <4F5DE84B.8050606@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Fri, 23 Mar 2012 22:51:53 +0100
Message-ID: <1332539514.2580.0.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 14:12 +0200, Avi Kivity wrote:
> On 03/08/2012 05:47 PM, Christian Borntraeger wrote:
> > On 08/03/12 12:45, Davidlohr Bueso wrote:
> > > From: Davidlohr Bueso <dave@gnu.org>
> > > 
> > > Since most guests will have paging enabled for memory management, add likely() optimization
> > > around CR0.PG checks.
> >
> > >  {
> > > -	return kvm_read_cr0_bits(vcpu, X86_CR0_PG);
> > > +	return likely(kvm_read_cr0_bits(vcpu, X86_CR0_PG));
> >
> >
> > IMHO likely/unlikely should be considered more as fast-path/slow-path and not as often/less often.
> 
> Agree.
> 
> > Is that the case here? This patch  might cause a mis-prediction for non-paging guests all 
> > the time. 
> >
> > Non-paging might be really irrelevant, so I am just making a point, since
> > likely/unlikely is mis-used too often especially for "most users do it that way".
> 
> In fact this is a classic example.  Almost no guests use real mode (the
> last guests to use real mode extensively was DOS; I think Win9x switches
> to real mode pretty often).  As it's a user-controlled setting, we're
> penalizing users who do things differently.
> 
> However the majority if is_paging() == true guests is so huge, and since
> non-paging guests don't really expect 2012 performance levels anyway
> (being so old) that I think in practice this is a good optimization here.

Avi, will you be taking this patch? I don't see it applied or for pull
in 3.4.

Thanks.


