Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab1KGQ1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:27:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab1KGQ1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:27:15 -0500
Date: Mon, 7 Nov 2011 18:26:54 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net,
        hpa <hpa@zytor.com>
Subject: Re: [PATCHv2 2/9] KVM: Expose a version 2 architectural PMU to a
 guests
Message-ID: <20111107162654.GL8670@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
 <1320323618-10375-3-git-send-email-gleb@redhat.com>
 <1320676467.18053.43.camel@twins>
 <4EB7EF4F.3090907@redhat.com>
 <1320677949.18053.54.camel@twins>
 <4EB7F58D.6080102@redhat.com>
 <20111107151944.GE8670@redhat.com>
 <4EB7F852.9010606@redhat.com>
 <1320682941.17809.18.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320682941.17809.18.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 05:22:21PM +0100, Peter Zijlstra wrote:
> On Mon, 2011-11-07 at 17:25 +0200, Avi Kivity wrote:
> > On 11/07/2011 05:19 PM, Gleb Natapov wrote:
> > > > 
> > > > note, this needs a fairly huge PMI skew to happen.
> > > > 
> > > No, it need not. It is enough to get exit reason as hlt instead of nmi
> > > for a vcpu to go to blocking state instead of reentering guest mode.
> > > Note that we do not check request flags in kvm_arch_vcpu_runnable().
> > 
> > Right.
> > 
> > If we had a guarantee about the maximum skew, we could add a check for
> > KVM_REQ_PMI in kvm_vcpu_block().
> 
> Right, it shouldn't be more than a few instructions since its NMIs we're
> talking about, but I'm not sure there's any really hard guarantees on,
> hardware folks would be able to say more.
> 
> Typically you can assert NMIs at instruction boundaries, but things like
> instruction fusing and a few 'special' insn can delay NMI delivery. then
> again, I'm clueless as to the actual implementation details of any of
> this stuff.
> 
> Also I'm not sure if there's any non-deterministic delays in the PMU
> event -> PMU overflow -> PMI raise path that could push you out into
> silly land.
> 
> So yeah, I think the proposed code is fine, although I think the comment
> can be improved by mentioning the vcpu hlt case.
> 
Will do.

--
			Gleb.
