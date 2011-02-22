Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab1BVLL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 06:11:26 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:23450
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753551Ab1BVLLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 06:11:24 -0500
X-SpamScore: -32
X-BigFish: VPS-32(zzbb2dK1432N98dN9371Pzz1202hzz15d4Rz32i637h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LH0N2N-01-HMN-02
X-M-MSG: 
Date: Tue, 22 Feb 2011 12:11:11 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 0/6] KVM support for TSC scaling
Message-ID: <20110222111111.GG16508@amd.com>
References: <4D57F677.3090004@redhat.com>
 <20110221172807.GD16508@amd.com>
 <4D638BDE.70602@redhat.com>
 <20110222103513.GF16508@amd.com>
 <4D6392F1.1030601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D6392F1.1030601@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 05:41:53AM -0500, Avi Kivity wrote:
> On 02/22/2011 12:35 PM, Roedel, Joerg wrote:
> > >  This doesn't really work, since we don't know on what host the TSC
> > >  calibration loop ran:
> > >
> > >  - start guest on host H1
> > >  - migrate it around, now it's on host H2
> > >  - guest reboots, reruns calibration loop
> > >  - migrate it around some more, now it's on host H3
> > >  - migrate to host with tsc multiplier Hnew
> > >
> > >  So, what should we set the multiplier to? H1, H2, or H3's tsc rate?
> >
> > This scenario doesn't matter. If the guest already detected its TSC to
> > be unstable there is nothing we can do and it doesn't really matter what
> > we set the tsc frequency to. Therefore software will always set the
> > guest tsc frequency to the same value it had on the last host.
> 
> Ok, so your scenario is
> 
> - boot on host H1
> - no intervening migrations
> - migrate to host Hnew
> - all succeeding migrations are only to new hosts or back to H1
> 
> This is somewhat artificial, and not very different from an all-new cluster.

This is at least the scenario where the new hardware feature will make
sense. Its clear that if you migrate a guest between hosts without
tsc-scaling will make the tsc appear unstable for the guest. This is
basically the same situation as we have today.
In fact, for older hosts the feature can be emulated in software by
trapping tsc accesses from the guest. Isn't this what Zachary has been
working on? During my implementation I understood tsc-scaling as a
hardware supported way to do this. And thats the reason I implemented it
the way it is.

> [the whole thing is kind of sad; we went through a huge effort to make 
> clocks work on virtual machines in spite of the tsc issues; then we have 
> a hardware solution, but can't use it because of old hardware.  Same 
> thing happens with the effort put into shadow in the pre-npt days]

The shadow code has a revivial as it is required for emulating
nested-npt and nested-ept, so the effort still has value :)

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

