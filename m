Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab1EQXKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 19:10:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:28467 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932553Ab1EQXKw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 19:10:52 -0400
X-ExtLoop1: 1
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Matthew Garrett <mjg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 17 May 2011 16:08:48 -0700
Subject: RE: [PATCH v2 3/4] x86, head_32/64.S: Enable SMEP
Thread-Topic: [PATCH v2 3/4] x86, head_32/64.S: Enable SMEP
Thread-Index: AcwUN5YKOde7wHJSTqG3NkAmXi7XAgArqWUw
Message-ID: <493994B35A117E4F832F97C4719C4C04011505C272@orsmsx505.amr.corp.intel.com>
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com>
 <1305581685-5144-4-git-send-email-fenghua.yu@intel.com>
 <20110517021006.GA6732@srcf.ucam.org>
In-Reply-To: <20110517021006.GA6732@srcf.ucam.org>
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

> -----Original Message-----
> From: Matthew Garrett [mailto:mjg@redhat.com]
> Sent: Monday, May 16, 2011 7:10 PM
> To: Yu, Fenghua
> Cc: Ingo Molnar; Thomas Gleixner; H Peter Anvin; Mallick, Asit K; Linus
> Torvalds; Avi Kivity; Arjan van de Ven; Andrew Morton; Andi Kleen;
> linux-kernel
> Subject: Re: [PATCH v2 3/4] x86, head_32/64.S: Enable SMEP
> 
> On Mon, May 16, 2011 at 02:34:44PM -0700, Fenghua Yu wrote:
> > From: Fenghua Yu <fenghua.yu@intel.com>
> >
> > Enable newly documented SMEP (Supervisor Mode Execution Protection)
> CPU
> > feature in kernel.
> >
> > SMEP prevents the CPU in kernel-mode to jump to an executable page
> that does
> > not have the kernel/system flag set in the pte. This prevents the
> kernel
> > from executing user-space code accidentally or maliciously, so it for
> example
> > prevents kernel exploits from jumping to specially prepared user-mode
> shell
> > code. The violation will cause page fault #PF and will have error
> code
> > identical to XD violation.
> 
> Are EFI runtime service pages currently set up appropriately?

They are not set up yet. efi init is called after this.

But at this time there is no user space code yet. So there is no SMEP violation chance until later when any user space page table is setup.

Thanks.

-Fenghua
