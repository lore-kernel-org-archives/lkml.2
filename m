Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab1ANNgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 08:36:18 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:24423
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703Ab1ANNgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 08:36:10 -0500
X-SpamScore: -32
X-BigFish: VPS-32(zzbb2dK1432N98dN9371Pzz1202hzz15d4Rz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LF0LS2-01-AVS-02
X-M-MSG: 
Date: Fri, 14 Jan 2011 14:36:02 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix NMI path when NMI happens in guest
 mode
Message-ID: <20110114133602.GC23914@amd.com>
References: <1294932178-26866-1-git-send-email-joerg.roedel@amd.com>
 <1294932178-26866-2-git-send-email-joerg.roedel@amd.com>
 <4D2F1D49.8070807@redhat.com>
 <20110113155129.GA23914@amd.com>
 <4D2F5204.7020100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D2F5204.7020100@redhat.com>
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

On Thu, Jan 13, 2011 at 02:27:00PM -0500, Avi Kivity wrote:
> On 01/13/2011 05:51 PM, Roedel, Joerg wrote:
> > I also had a look at entry_64.S. The save_paranoid could not be the
> > cause because MSR_GS_BASE is already negative at this point. But the
> > re-schedule condition check at the end of the NMI handler code could
> > also not be the cause because the NMI happens while preemption (and
> > interrupts) are disabled (a re-schedule should also trigger
> > preempt-notifiers and restore KERNEL_GS_BASE).
> >
> 
> I have it:

Cool, good catch. Thanks :)

The only use of load_gs_index in svm is the vcpu_put function. It is
sufficient to just swap the KERNEL_GS_BASE wrmsr and the load_gs_index
function calls in there to be safe.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

