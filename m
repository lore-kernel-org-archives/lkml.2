Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab0LFRtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:49:55 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:29989 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab0LFRtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:49:53 -0500
X-SpamScore: -46
X-BigFish: VPS-46(zzbb2dK1432N98dN14ffO179dN9371P10d1Izz1202hzz15d4Rz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LD0PHY-01-RST-02
X-M-MSG: 
Date: Mon, 6 Dec 2010 18:48:52 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: SVM: Add xsetbv intercept
Message-ID: <20101206174852.GG4936@amd.com>
References: <1291394523-7689-1-git-send-email-joerg.roedel@amd.com>
 <4CFD0B06.9010308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4CFD0B06.9010308@redhat.com>
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

On Mon, Dec 06, 2010 at 11:10:46AM -0500, Avi Kivity wrote:
> On 12/03/2010 06:42 PM, Joerg Roedel wrote:
> > This patch implements the xsetbv intercept to the AMD part
> > of KVM. This makes AVX usable in a save way for the guest on
> > AVX capable AMD hardware.
> > The patch is tested by using AVX in the guest and host in
> > parallel and checking for data corruption. I also used the
> > KVM xsave unit-tests and they all pass.
> >
> 
> That is really strange.  You didn't need to do anything to get cpuid.avx 
> recognized.  So running an older kvm on newer hardware will happily 
> expose avx even though it's not supported.
> 
> We screwed up - we should have made cpuid.avx dependent on vendor support.

Hmm, right. The set_supported_cpuid arch-callback should basically
disable xsave on AMD for all KVM versions which do not handle the xsetbv
intercept.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

