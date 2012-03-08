Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab2CHV2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:28:08 -0500
Received: from caiajhbdccac.dreamhost.com ([208.97.132.202]:58577 "EHLO
	homiemail-a60.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752924Ab2CHV2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:28:05 -0500
Subject: Re: [PATCH v2] KVM: x86: add paging gcc optimization
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM <kvm@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4F58D48F.8050807@de.ibm.com>
References: <1331207154.28711.2.camel@offworld>
	 <4F58D48F.8050807@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Thu, 08 Mar 2012 22:27:59 +0100
Message-ID: <1331242079.2592.4.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 16:47 +0100, Christian Borntraeger wrote:
> On 08/03/12 12:45, Davidlohr Bueso wrote:
> > From: Davidlohr Bueso <dave@gnu.org>
> > 
> > Since most guests will have paging enabled for memory management, add likely() optimization
> > around CR0.PG checks.
> 
> >  {
> > -	return kvm_read_cr0_bits(vcpu, X86_CR0_PG);
> > +	return likely(kvm_read_cr0_bits(vcpu, X86_CR0_PG));
> 
> 
> IMHO likely/unlikely should be considered more as fast-path/slow-path and not as often/less often.
> Is that the case here? This patch  might cause a mis-prediction for non-paging guests all 
> the time. 

Branch predictions are all about probability of occurrence, and I cannot
imagine guests having paging disabled and mapping gva->gpa directly, so
for most of the cases it would be beneficial. For those peculiar users
that actually don't use paging, then yes, mispredictions would occur.

- Davidlohr

> 
> Non-paging might be really irrelevant, so I am just making a point, since
> likely/unlikely is mis-used too often especially for "most users do it that way".
> 
> 
> Christian
> 
> 


