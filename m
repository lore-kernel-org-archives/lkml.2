Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab2HVSHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 14:07:41 -0400
Received: from relay.ihostexchange.net ([66.46.182.56]:13013 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758368Ab2HVSHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 14:07:38 -0400
From: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@ScaleMP.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Ido Yariv <ido@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 22 Aug 2012 14:07:33 -0400
Subject: RE: [PATCH v2] x86/vsmp: Use hypervisor layer for initialization
Thread-Topic: [PATCH v2] x86/vsmp: Use hypervisor layer for initialization
Thread-Index: Ac2AjlzBsdMOwQaeSoOS+NUaq62S+AAAbFqw
Message-ID: <9B14D1490DDECA4E974F6B9FC9EBAB317F3897AED3@VMBX108.ihostexchange.net>
References: <20120822100845.GB26323@gmail.com>
 <1345634411-28108-1-git-send-email-ido@wizery.com>
 <20120822173752.GA32500@gmail.com>
 <9B14D1490DDECA4E974F6B9FC9EBAB317F3897AEC7@VMBX108.ihostexchange.net>
 <20120822174832.GA32743@gmail.com>
In-Reply-To: <20120822174832.GA32743@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Use of vSMP Foundation does not require compiling with CONFIG_X86_VSMP, which is off by default in any distribution to date.

vsmp_64.c and is_vsmp_box() are depended on CONFIG_X86_64, and we will make sure to fix any deviation from the current situation.  We want very much to move to the new hypervisor API, but do not want to loose existing functionality that can hurt all our install base.

Let us go back and see if there is a cleaner way to fix this, while keeping the existing functionality.

Thanks for your understanding,
Shai.


--Shai 


> -----Original Message-----
> From: Ingo Molnar [mailto:mingo.kernel.org@gmail.com] On Behalf Of Ingo
> Molnar
> Sent: Wednesday, August 22, 2012 20:49
> To: Shai Fultheim (Shai@ScaleMP.com)
> Cc: Ido Yariv; linux-kernel@vger.kernel.org; Thomas Gleixner; H. Peter Anvin
> Subject: Re: [PATCH v2] x86/vsmp: Use hypervisor layer for initialization
> 
> 
> * Shai Fultheim (Shai@ScaleMP.com) <Shai@ScaleMP.com> wrote:
> 
> > Ingo,
> >
> > CONFIG_X86_VSMP is only for setting cache-line size to 4KB.
> > Rest of the bits were never depended on this.
> 
> That's a problem - please move vSMP functionality under a
> simple, properly named Kconfig toggle. Many of the build
> problems are related to that.
> 
> Thanks,
> 
> 	Ingo
