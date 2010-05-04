Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab0EDMAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:00:53 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:42094
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751467Ab0EDMAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:00:51 -0400
X-SpamScore: -32
X-BigFish: VPS-32(zz1432P98dN936eM179dN9371Pzz1202hzzz32i2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1W9D3-01-B6D-02
X-M-MSG: 
Date: Tue, 4 May 2010 14:00:39 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/22] KVM: MMU: Track page fault data in struct vcpu
Message-ID: <20100504120039.GH28950@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
 <1272364712-17425-17-git-send-email-joerg.roedel@amd.com>
 <4BD6DF7C.1090203@redhat.com>
 <20100503163221.GB28950@amd.com>
 <4BDFD295.7000702@redhat.com>
 <20100504091157.GC28950@amd.com>
 <4BDFE6C2.2040601@redhat.com>
 <20100504093709.GE28950@amd.com>
 <4BDFECD1.8040109@redhat.com>
 <4BDFEDFA.3090209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BDFEDFA.3090209@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 05:50:50AM -0400, Avi Kivity wrote:
> On 05/04/2010 12:45 PM, Avi Kivity wrote:
> >
> >
> > Just a silly bug.  kvm_pdptr_read() can cause a guest memory read on 
> > svm, in this case with the mmu lock taken.  I'll post something to fix 
> > it.
> 
> I guess this was not reported because most svm machines have npt, and 
> this requires npt=0 to trigger.  Nonpae paging disables npt, so you were 
> hit.  Interestingly, nsvm makes it more likely to appear, since npt on 
> i386+pae will need the pdptrs.

Hmm, actually it happened on 32 bit with npt enabled. I think this
can trigger when mmu_alloc_roots is called for an pae guest because it
accidentially tries read the root_gfn from the guest before it figures
out that it runs with tdp and omits the gfn read from the guest.
I need to touch this for nested-npt and will look into a way improving
this.

	Joerg


