Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab0IHJTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 05:19:04 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:22293 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab0IHJTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 05:19:01 -0400
X-SpamScore: -38
X-BigFish: VS-38(zzbb2dK1432N98dN179dN9371Pzz1202hzz15d4Rz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8F8G0-02-3IY-02
X-M-MSG: 
Date: Wed, 8 Sep 2010 11:16:55 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 22/27] KVM: MMU: Refactor mmu_alloc_roots function
Message-ID: <20100908091655.GI2177@amd.com>
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
 <1283788566-29186-23-git-send-email-joerg.roedel@amd.com>
 <20100907203952.GA14489@amt.cnet>
 <4C87386B.2030109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C87386B.2030109@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 03:16:59AM -0400, Avi Kivity wrote:
>   On 09/07/2010 11:39 PM, Marcelo Tosatti wrote:
> >
> >> @@ -2406,16 +2441,11 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
> >>   			root_gfn = pdptr>>  PAGE_SHIFT;
> >>   			if (mmu_check_root(vcpu, root_gfn))
> >>   				return 1;
> >> -		} else if (vcpu->arch.mmu.root_level == 0)
> >> -			root_gfn = 0;
> >> -		if (vcpu->arch.mmu.direct_map) {
> >> -			direct = 1;
> >> -			root_gfn = i<<  30;
> >>   		}
> >>   		spin_lock(&vcpu->kvm->mmu_lock);
> >>   		kvm_mmu_free_some_pages(vcpu);
> >>   		sp = kvm_mmu_get_page(vcpu, root_gfn, i<<  30,
> >> -				      PT32_ROOT_LEVEL, direct,
> >> +				      PT32_ROOT_LEVEL, 0,
> >>   				      ACC_ALL, NULL);
> > Should not write protect the gfn for nonpaging mode.
> >
> 
> nonpaging mode should have direct_map set, so wouldn't enter this path 
> at all.

Hmm, actually the nonpaging path does not set direct_map. I'll fix this
too in v4. Thanks.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

