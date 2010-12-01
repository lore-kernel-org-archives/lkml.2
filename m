Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab0LAKeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:34:22 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:39786 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0LAKeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:34:20 -0500
X-SpamScore: -32
X-BigFish: VPS-32(zzbb2dK1432N98dN9371Pzz1202hzz15d4Rz32i691h637h668h67dh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCQW11-01-1J2-02
X-M-MSG: 
Date: Wed, 1 Dec 2010 11:34:19 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] KVM: SVM: Wrap access to intercept masks into
 functions
Message-ID: <20101201103419.GH2258@amd.com>
References: <1291136641-4874-1-git-send-email-joerg.roedel@amd.com>
 <4CF53784.2000701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4CF53784.2000701@redhat.com>
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

On Tue, Nov 30, 2010 at 12:42:28PM -0500, Avi Kivity wrote:
> On 11/30/2010 07:03 PM, Joerg Roedel wrote:
> > Hi Avi, Hi Marcelo,
> >
> > this patchset wraps the access to the intercept vectors in the VMCB into
> > specific functions. There are two reasons for this:
> >
> > 	1) In the nested-svm code the effective intercept masks are
> > 	   calculated from the host and the guest intercept masks.
> > 	   Whenever KVM changes the host intercept mask while the VCPU
> > 	   is in guest-mode the effective intercept masks need to be
> > 	   re-calculated. This is nicely wrapped into these functions
> > 	   now and makes the code more robust.
> >
> > 	2) These changes make the implementation of the upcoming
> > 	   vmcb-clean-bits feature easier and also more robust (which
> > 	   was the main reason for writing this patchset).
> >
> > These patches were developed on-top of the patch-set I sent yesterday. I
> > tested these patches with various guests (Windows-64, Linux 32,32e and
> > 64 as well as with nested-svm).
> >
> 
> Looks good.
> 
> One potential issue is that a series of set_intercept()s causes 
> recalc_intercepts() to be called multiple times.  If it turns out to be 
> a problem, we can fix it by having an intercepts dirty bit and 
> recalculating during guest entry if the bit is set.
> 
> Since it's nested svm only, I doubt we'll see a problem in the short term.

Yes, we can optimize it if it turns out to be a problem. I thought that
these changes happen infrequently enough and that there should be no
more than 2-3 bits changed per exit-entry cycle at all.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

