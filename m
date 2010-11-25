Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab0KYNOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 08:14:14 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:26909
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751606Ab0KYNON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:14:13 -0500
X-SpamScore: -25
X-BigFish: VPS-25(zz146fK1432N98dN10d1Izz1202hzz15d4Rz32i691h637h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCFZF0-01-DWS-02
X-M-MSG: 
Date: Thu, 25 Nov 2010 14:13:51 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] KVM: Make the instruction emulator aware of Nested
 Virtualization
Message-ID: <20101125131351.GA9382@amd.com>
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
 <4CED63DC.20608@redhat.com>
 <20101125114640.GC6031@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101125114640.GC6031@amd.com>
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

On Thu, Nov 25, 2010 at 12:46:40PM +0100, Roedel, Joerg wrote:
> We basically have two choices here:
> 
> 	a) We expose svm internals into the emulator
> 	b) We expose emulator internals into svm
> 
> Both choices are not really good from a software-design point-of-view.
> But I think option b) is the better one because it is easier to cope with
> and thus less likely to break when changing the emulator code.

What we could do probably is to define the interface between the
emulator and the architecture code in a better way. This would take the
burden of going into architecture code for emulator changes away.

The current patch-set only needs a subset of the decode-cache (in the
future probably also a subset of the fetch-cache). We could put this
information into a seperate struct and give it to the architecture code.

I planned to make the guest_mode flag a generic x86 vcpu property
anyway, so building this structure could be limited to instructions
emulated while the vcpu is in guest mode thus avoiding the overhead for
the default case.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

