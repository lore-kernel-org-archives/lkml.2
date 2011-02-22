Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1BVKuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 05:50:23 -0500
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.185]:57666
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927Ab1BVKuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 05:50:22 -0500
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Feb 2011 05:50:22 EST
X-SpamScore: -32
X-BigFish: VPS-32(zzbb2dK1432N98dN9371Pzz1202hzz15d4Rz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LH0LEP-01-GCN-02
X-M-MSG: 
Date: Tue, 22 Feb 2011 11:35:13 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 0/6] KVM support for TSC scaling
Message-ID: <20110222103513.GF16508@amd.com>
References: <4D57F677.3090004@redhat.com>
 <20110221172807.GD16508@amd.com>
 <4D638BDE.70602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D638BDE.70602@redhat.com>
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

On Tue, Feb 22, 2011 at 05:11:42AM -0500, Avi Kivity wrote:
> On 02/21/2011 07:28 PM, Roedel, Joerg wrote:
> > >  - what's the cost of wrmsr(TSC_MULT)?
> >
> > Hard to tell by now because I only have numbers for pre-production
> > hardware.
> 
> Can you ask your hardware people what the cost will likely be?  msrs are 
> often expensive, and here we have two in the lightweight exit path.

Will do.

> This doesn't really work, since we don't know on what host the TSC 
> calibration loop ran:
> 
> - start guest on host H1
> - migrate it around, now it's on host H2
> - guest reboots, reruns calibration loop
> - migrate it around some more, now it's on host H3
> - migrate to host with tsc multiplier Hnew
> 
> So, what should we set the multiplier to? H1, H2, or H3's tsc rate?

This scenario doesn't matter. If the guest already detected its TSC to
be unstable there is nothing we can do and it doesn't really matter what
we set the tsc frequency to. Therefore software will always set the
guest tsc frequency to the same value it had on the last host.

In the above scenario this would be be the host tsc frequency of H3. If
the guest is migrated further around from the host with TSC multiplier
this frequency is passed on further. Software can read the guest tsc
frequency using the ioctl.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

