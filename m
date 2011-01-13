Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab1AMPwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:52:32 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:52607 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979Ab1AMPwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:52:31 -0500
X-SpamScore: -24
X-BigFish: VPS-24(zzbb2cK1432N98dNzz1202hzz15d4Rz32i637h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LEYXFA-02-BTA-02
X-M-MSG: 
Date: Thu, 13 Jan 2011 16:52:24 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix NMI path when NMI happens in guest
 mode
Message-ID: <20110113155224.GB23914@amd.com>
References: <1294932178-26866-1-git-send-email-joerg.roedel@amd.com>
 <1294932178-26866-2-git-send-email-joerg.roedel@amd.com>
 <4D2F1ED1.1020001@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D2F1ED1.1020001@siemens.com>
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

On Thu, Jan 13, 2011 at 10:48:33AM -0500, Jan Kiszka wrote:
> Am 13.01.2011 16:22, Joerg Roedel wrote:
> >  #ifdef CONFIG_X86_64
> >  	wrmsrl(MSR_GS_BASE, svm->host.gs_base);
> > +	wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gs);
> >  #else
> >  	loadsegment(fs, svm->host.fs);
> >  #endif
> 
> Doesn't this also obsolete the wrmsrl(MSR_KERNEL_GS_BASE) in svm_vcpu_put?

Yes it does. Thanks.

Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

