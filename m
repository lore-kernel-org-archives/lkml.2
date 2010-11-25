Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab0KYQXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:23:19 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:44128
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752546Ab0KYQXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:23:17 -0500
X-SpamScore: -33
X-BigFish: VPS-33(zzbb2dK1432N98dN9371P10d1Izz1202hzz15d4Rz32i691h637h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCG86L-02-4NG-02
X-M-MSG: 
Date: Thu, 25 Nov 2010 17:23:13 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] KVM: Make the instruction emulator aware of Nested
 Virtualization
Message-ID: <20101125162313.GA9411@amd.com>
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
 <4CED63DC.20608@redhat.com>
 <20101125114640.GC6031@amd.com>
 <20101125131351.GA9382@amd.com>
 <4CEE7E21.3060007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4CEE7E21.3060007@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 10:17:53AM -0500, Avi Kivity wrote:
> On 11/25/2010 03:13 PM, Roedel, Joerg wrote:
> > On Thu, Nov 25, 2010 at 12:46:40PM +0100, Roedel, Joerg wrote:
> > >  We basically have two choices here:
> > >
> > >  	a) We expose svm internals into the emulator
> > >  	b) We expose emulator internals into svm
> > >
> > >  Both choices are not really good from a software-design point-of-view.
> > >  But I think option b) is the better one because it is easier to cope with
> > >  and thus less likely to break when changing the emulator code.
> >
> > What we could do probably is to define the interface between the
> > emulator and the architecture code in a better way. This would take the
> > burden of going into architecture code for emulator changes away.
> 
> What about things like adding instructions and forgetting to add the 
> corresponding svm.c code?

Cannot happen. Every instruction that can be intercepted with SVM is
already handled in this patch-set.

> Good idea.  Needed for the decode bits thing as well.

Especially needed to not kill the L1 guest when an L2 instruction
emulation fails :)

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

