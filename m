Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab0IHJVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 05:21:43 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:13130 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580Ab0IHJVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 05:21:40 -0400
X-SpamScore: -32
X-BigFish: VS-32(zzbb2dK1432N98dN9371Pzz1202hzz15d4Rz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8F8LJ-01-40X-02
X-M-MSG: 
Date: Wed, 8 Sep 2010 11:20:14 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/27] KVM: MMU: Add infrastructure for two-level page
 walker
Message-ID: <20100908092013.GK2177@amd.com>
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
 <1283788566-29186-11-git-send-email-joerg.roedel@amd.com>
 <4C852D6F.5000101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C852D6F.5000101@redhat.com>
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

On Mon, Sep 06, 2010 at 02:05:35PM -0400, Avi Kivity wrote:
>   On 09/06/2010 06:55 PM, Joerg Roedel wrote:
> > This patch introduces a mmu-callback to translate gpa
> > addresses in the walk_addr code. This is later used to
> > translate l2_gpa addresses into l1_gpa addresses.
> 
> > @@ -534,6 +534,11 @@ static inline gpa_t gfn_to_gpa(gfn_t gfn)
> >   	return (gpa_t)gfn<<  PAGE_SHIFT;
> >   }
> >
> > +static inline gfn_t gpa_to_gfn(gpa_t gpa)
> > +{
> > +	return (gfn_t)gpa>>  PAGE_SHIFT;
> > +}
> > +
> 
> That's a bug - gfn_t may be smaller than gpa_t, so you're truncating 
> just before the shift.  Note the casts in the surrounding functions are 
> widening, not narrowing.
> 
> However, gfn_t is u64 so the bug is only theoretical.

Will fix that in v4 too. Thanks.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

