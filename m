Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab0LAKEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:04:07 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:48384
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755Ab0LAKEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:04:04 -0500
X-SpamScore: -30
X-BigFish: VPS-30(zz1dbaL1418M1432N98dNzz1202hzz15d4Rz32i691h637h668h67dh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCQUMG-02-6RB-02
X-M-MSG: 
Date: Wed, 1 Dec 2010 11:03:59 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: "Nadav Har'El" <nyh@math.technion.ac.il>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: Introduce VCPU-wide notion of guest-mode V2
Message-ID: <20101201100359.GG2258@amd.com>
References: <4CF3D093.40604@redhat.com>
 <1291049509-3430-1-git-send-email-joerg.roedel@amd.com>
 <20101201080149.GA29486@fermat.math.technion.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101201080149.GA29486@fermat.math.technion.ac.il>
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

On Wed, Dec 01, 2010 at 03:01:49AM -0500, Nadav Har'El wrote:
> On Mon, Nov 29, 2010, Joerg Roedel wrote about "[PATCH 0/3] KVM: Introduce VCPU-wide notion of guest-mode V2":
> > Hi Avi, Hi Marcelo,
> > 
> > here is the re-spin I promised. The change to V1 are essentially the
> > renames:
> > 
> > 	kvm_vcpu_enter_gm -> enter_guest_mode
> > 	kvm_vcpu_leave_gm -> leave_guest_mode
> > 	kvm_vcpu_is_gm    -> is_guest_mode
> 
> I like this concept, and will be happy to change the nested VMX code to use
> it as well.
> 
> One small thing: After the name change, it might not be obvious on first
> sight that these functions refer to the state of the vcpu, not the state
> of the actual CPU (which, if you think about it, is never in guest mode while
> KVM code is running ;-)). I think that a short comment before the definition
> of these functions might be useful - perhaps saying that they pertain to a
> hypervisor running in the vcpu (i.e., nested virtualization).

Yes, right. Thats a good thing. I sent a follow-on patch adding the
comments.

Btw, another idea which came up recently was to concentrate the actuall
vmexit emulation at a single point. Every code place which does the exit
directly today will be changed to only set a request-bit and the real
exit is then done later. Your code might already do this, I havn't
checked. In fact the idea is from the neste-VMX patchset for Xen :)
This would fit very well in the generic code because it already has
request-bit infrastructure. What do you think, can nested VMX also make
use of that too?

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

