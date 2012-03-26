Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab2CZLYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 07:24:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757441Ab2CZLX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 07:23:59 -0400
Date: Mon, 26 Mar 2012 13:24:02 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC dontapply] kvm_para: add mmio word store hypercall
Message-ID: <20120326112402.GB15207@redhat.com>
References: <20120325220518.GA27879@redhat.com>
 <4F703536.3040904@redhat.com>
 <20120326100829.GA14506@redhat.com>
 <20120326102921.GN22368@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120326102921.GN22368@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 12:29:21PM +0200, Gleb Natapov wrote:
> > > > +		gpa = hc_gpa(vcpu, a1, a2);
> > > > +		if (!write_mmio(vcpu, gpa, 2, &a0) && run) {
> > > 
> > > What's this && run thing?
> > 
> > I'm not sure - copied this from another other place in emulation:
> > arch/x86/kvm/x86.c:4953:                if (!write_mmio(vcpu, gpa, 2, &a0) && run)
> > 
> What git tree is this from? I think that's the one you added.

Ugh. My mistake. So the answer is this, as I said, this is
on an ancient tree that did not have
112592da0dc2460c95e8a89d0c5657c6a30286aa
I'll remove this check, thanks for pointing this out.

