Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab0LANUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 08:20:31 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:47824
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755084Ab0LANU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 08:20:29 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zz98dN1878kzz1202hzz15d4Rz32i691h637h668h67dh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCR3PP-01-9DQ-02
X-M-MSG: 
Date: Wed, 1 Dec 2010 14:20:20 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: "Nadav Har'El" <nyh@math.technion.ac.il>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: Introduce VCPU-wide notion of guest-mode V2
Message-ID: <20101201132020.GA11986@amd.com>
References: <4CF3D093.40604@redhat.com>
 <1291049509-3430-1-git-send-email-joerg.roedel@amd.com>
 <20101201080149.GA29486@fermat.math.technion.ac.il>
 <20101201100359.GG2258@amd.com>
 <20101201113830.GA5469@fermat.math.technion.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101201113830.GA5469@fermat.math.technion.ac.il>
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

On Wed, Dec 01, 2010 at 06:38:30AM -0500, Nadav Har'El wrote:

> Can you please say a few words why you'd want to move this nested-exit
> request bit to x86.c?

I don't want to move the actual exit-code itself into generic code. This
code is different between svm and vmx. I think we could implement a
call-back in kvm_x86_ops which is called when a vmexit is requested.
The benefit is that we have a single and well-defined place where we
emulate a vmexit.
SVM already as a similar mechanism internally because nested_svm_vmexit
may sleep and can't be called from certain places. Another reason is
that emulating a vmexit at a wrong plase may have side-effects (for
example when called from within the instruction emulator).
With a generic request-bit I can remove the SVM internal implementation
and nested vmx could use it too. I am certain you will need something
similar in nested-vmx too. 

> Do you want to move some of the exit logic to x86.c - e.g., for the
> injection logic?

Thats another and probably more complex topic. I need a better
understanding of (nested-)vmx before we discuss how this can be done.
But a vmexit-callback may be helpful there as well.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

