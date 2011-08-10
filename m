Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab1HJTSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 15:18:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:49068 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab1HJTSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 15:18:13 -0400
Subject: Re: [PATCH] powerpc/kvm: fix build errors with older toolchains
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexander Graf <agraf@suse.de>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4E429CAD.5050000@suse.de>
References: <1312397755-15737-1-git-send-email-nacc@us.ibm.com>
	 <4E429CAD.5050000@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 13:56:25 -0500
Message-ID: <1313002585.1674.13.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 16:58 +0200, Alexander Graf wrote:
> On 08/03/2011 08:55 PM, Nishanth Aravamudan wrote:
> > On a box with gcc 4.3.2, I see errors like:
> >
> > arch/powerpc/kvm/book3s_hv_rmhandlers.S:1254: Error: Unrecognized opcode: stxvd2x
> > arch/powerpc/kvm/book3s_hv_rmhandlers.S:1316: Error: Unrecognized opcode: lxvd2x
> 
> Paul, mind to ack?

I merged it already :-) It was trivial & annoying enough.

Cheers,
Ben.

> 
> Alex
> 
> > Signed-off-by: Nishanth Aravamudan<nacc@us.ibm.com>
> > ---
> >   arch/powerpc/kvm/book3s_hv_rmhandlers.S |    4 ++--
> >   1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> > index 6dd3358..de29501 100644
> > --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> > +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> > @@ -1251,7 +1251,7 @@ BEGIN_FTR_SECTION
> >   	reg = 0
> >   	.rept	32
> >   	li	r6,reg*16+VCPU_VSRS
> > -	stxvd2x	reg,r6,r3
> > +	STXVD2X(reg,r6,r3)
> >   	reg = reg + 1
> >   	.endr
> >   FTR_SECTION_ELSE
> > @@ -1313,7 +1313,7 @@ BEGIN_FTR_SECTION
> >   	reg = 0
> >   	.rept	32
> >   	li	r7,reg*16+VCPU_VSRS
> > -	lxvd2x	reg,r7,r4
> > +	LXVD2X(reg,r7,r4)
> >   	reg = reg + 1
> >   	.endr
> >   FTR_SECTION_ELSE
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


