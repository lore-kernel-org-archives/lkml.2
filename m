Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935759Ab0GPHXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 03:23:11 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:46675
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935713Ab0GPHXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 03:23:06 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz1432Nzz1202hzz15d4Rz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L5N365-01-0HT-02
X-M-MSG: 
Date: Fri, 16 Jul 2010 09:22:44 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Michal Schmidt <mschmidt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
Message-ID: <20100716072244.GA27954@aftab>
References: <20100713185816.2866.17837.stgit@localhost.localdomain>
 <20100713185957.2866.50995.stgit@localhost.localdomain>
 <20100714160704.GA10473@kryptos.osrc.amd.com>
 <20100714232201.00433aa9@hammerfall>
 <20100714233102.0f64614b@hammerfall>
 <4C3FDF43.6030203@zytor.com>
 <20100716063952.GB27546@aftab>
 <4C3F8418.5020803@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C3F8418.5020803@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, Jul 15, 2010 at 05:56:40PM -0400

> >> This is a change of semantics from an AND to an OR across CPUs...
> >
> > You mean the c1e_detected variable and the CPUID flag, right? Well,
> > frankly and if I'm not missing anything, we actually only need to track
> > when either bits [27,28] get set in that MSR - MSR_K8_INT_PENDING_MSG -
> > in order to do timer broadcast.
> >
> > And strictly speaking, we don't need a variable for that at all (nor a
> > synthetic CPUID flag, for that matter) - we can simply read the MSR as
> > much as we'd like after we've detected that this CPU supports C1E.
> >
> > But having the value cached is faster and doesn't enlarge checking
> > code in acpi_processor_cstate_check().
> >
> > I think the reason for adding the syntetic cpuid flag is only to
> > communicate to the ACPI processor module that we don't support deeper
> > C-states on a C1E machine, see a8d6829044901a67732904be5f1eacdf8539604f.
> > So we don't strictly need it and we can only export c1e_detected to the
> > rest for simplicity.
> >
> 
> No, the difference between using a separate variable and the CPU feature 
> bit is that CPU feature bit is ANDed across all CPUs, whereas this 
> variable is set if it is set on *any* CPU.

... and that's ok because the MSR bits get set on all cores after BIOS
turns on C1E. Let me verify this though.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

