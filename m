Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab0G1MP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 08:15:56 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:29633
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754699Ab0G1MPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 08:15:55 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz98dNzz1202hzz15d4Rz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L69OQ7-02-7UW-02
X-M-MSG: 
Date: Wed, 28 Jul 2010 14:18:22 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: SVM: Emulate next_rip svm feature
Message-ID: <20100728121822.GH26098@amd.com>
References: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com>
 <1280247261-19115-3-git-send-email-joerg.roedel@amd.com>
 <4C4F2643.8080507@redhat.com>
 <20100728093708.GD26098@amd.com>
 <4C500636.1070708@redhat.com>
 <20100728112540.GE26098@amd.com>
 <4C5015B3.8010003@redhat.com>
 <20100728115133.GG26098@amd.com>
 <4C501B30.6020900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C501B30.6020900@redhat.com>
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

On Wed, Jul 28, 2010 at 07:57:36AM -0400, Avi Kivity wrote:

> If the instruction opcode is on mmio, the processor never sees the 
> opcode and thus can not intercept.  Or the processor may see one 
> instruction, which is not intercepted, but by the time the emulator 
> kicks in a different instruction takes its place, since another vcpu is 
> evilly cross-modifying the code.

Right. X-modifying code is a problem too.

> The guest (L2 in this case) is doomed since it execution cannot 
> continue.  But L1 and L0 are fine.  The problem with L2 avoiding 
> intercepts is that L2 can change control registers and take over L1.

Right too. We can not ignore it. The right fix is probably a check for
the instruction intercepts right after the decoder has run and before
the emulator ran.

	Joer

-- 
Joerg Roedel - AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

