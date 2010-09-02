Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab0IBQeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 12:34:19 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:51236
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755997Ab0IBQeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 12:34:17 -0400
X-SpamScore: -32
X-BigFish: VS-32(zzbb2dK1432N98dN9371Pzz1202hzz15d4Rz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L84OH1-01-BW2-02
X-M-MSG: 
Date: Thu, 2 Sep 2010 18:29:34 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 2/3] KVM: SVM: Restore correct registers after sel_cr0
 intercept emulation
Message-ID: <20100902162934.GD1964@amd.com>
References: <1283441387-7378-1-git-send-email-joerg.roedel@amd.com>
 <1283441387-7378-3-git-send-email-joerg.roedel@amd.com>
 <4C7FCA7A.1020809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C7FCA7A.1020809@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 12:02:02PM -0400, Avi Kivity wrote:
>   On 09/02/2010 06:29 PM, Joerg Roedel wrote:
> > This patch implements restoring of the correct rip, rsp, and
> > rax after the svm emulation in KVM injected a selective_cr0
> > write intercept into the guest hypervisor. The problem was
> > that the vmexit is emulated in the instruction emulation
> > which later commits the registers right after the write-cr0
> > instruction. So the l1 guest will continue to run with the
> > l2 rip, rsp and rax resulting in unpredictable behavior.
> 
> Please post a unit test for this.

Will do. Should be an easy test.

> > This patch is not the final word, it is just an easy patch
> > to fix the issue. The real fix will be done when the
> > instruction emulator is made aware of nested virtualization.
> > Until this is done this patch fixes the issue and provides
> > an easy way to fix this in -stable too.
> 
> I agree.  We can probably use X86EMUL_PROPAGATE_FAULT to abort 
> emulation, but looking at the code, it will take some refactoring.

I thought of an X86EMUL_INTERCEPTED. An architecture specific function
is called after instruction decoding which checks if an intercept is
necessary. If it returns X86EMUL_INTERCEPTED then the instruction
emulation is discarded and kvm goes straight back into the guest.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

