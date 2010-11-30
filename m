Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab0K3Ir6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 03:47:58 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:40568
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753835Ab0K3Ir5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 03:47:57 -0500
X-SpamScore: -32
X-BigFish: VPS-32(zzbb2dK1432N98dN9371Pzz1202hzz15d4Rz32i691h637h668h67dh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCOWFP-01-7DQ-02
X-M-MSG: 
Date: Tue, 30 Nov 2010 09:47:53 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
CC: Joerg Roedel <joro@8bytes.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] KVM: Make the instruction emulator aware of Nested
 Virtualization
Message-ID: <20101130084753.GF2258@amd.com>
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
 <4CED63DC.20608@redhat.com>
 <20101125114640.GC6031@amd.com>
 <20101125131351.GA9382@amd.com>
 <4CEE7E21.3060007@redhat.com>
 <20101125162313.GA9411@amd.com>
 <11557.1291051418@localhost>
 <20101129183212.GD15575@8bytes.org>
 <18726.1291060870@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <18726.1291060870@localhost>
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

On Mon, Nov 29, 2010 at 03:01:10PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 29 Nov 2010 19:32:12 +0100, Joerg Roedel said:
> > On Mon, Nov 29, 2010 at 12:23:38PM -0500, Valdis.Kletnieks@vt.edu wrote:
> > > (Sorry for late reply...)
> > > 
> > > On Thu, 25 Nov 2010 17:23:13 +0100, "Roedel, Joerg" said:
> > > > On Thu, Nov 25, 2010 at 10:17:53AM -0500, Avi Kivity wrote:
> > > > > On 11/25/2010 03:13 PM, Roedel, Joerg wrote:
> > > > > What about things like adding instructions and forgetting to add the 
> > > > > corresponding svm.c code?
> > > > Cannot happen. Every instruction that can be intercepted with SVM is
> > > > already handled in this patch-set.
> > > 
> > > Call us back when Intel releases the i9 and i11 with new instructions
> > > that need intercept handling. ;)
> > 
> > How does that affect SVM?
> 
> It will quite possibly include instructions that can be intercepted with SVM
> that are not in this patch set.  At which point Joerg's comment can apply - it
> will be possible to add it in one place and forget to add it in the svm.c code.

SVM is AMD-only. So if an instruction does not exist on AMD there will
also be no specific intercept for it. For newly added instructions to
the AMD ISA which can then be intercepted I have to do bringup work
anyway. This will include adding these intercepts to the code in this
patch-set.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

