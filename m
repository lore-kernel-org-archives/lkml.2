Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab1F0Nwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 09:52:47 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:20332
	"EHLO CH1EHSOBE018.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751183Ab1F0Nwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 09:52:41 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz936eK9371M4015L1432N98dKzz1202hzz8275ch8275bh8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNGBVM-01-KD6-02
X-M-MSG: 
Date: Mon, 27 Jun 2011 15:52:32 +0200
From: Robert Richter <robert.richter@amd.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: "stable@kernel.org" <stable@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [34-longterm 228/247] arch/x86/oprofile/op_model_amd.c: Perform
 initialisation on a single CPU
Message-ID: <20110627135232.GD4590@erda.amd.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-169-git-send-email-paul.gortmaker@windriver.com>
 <20110624092302.GI20052@erda.amd.com>
 <4E048AEF.6010708@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E048AEF.6010708@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.06.11 09:02:39, Paul Gortmaker wrote:
> On 11-06-24 05:23 AM, Robert Richter wrote:
> > On 23.06.11 13:34:56, Paul Gortmaker wrote:
> >> From: Robert Richter <robert.richter@amd.com>
> >>
> >>                    -------------------
> >>     This is a commit scheduled for the next v2.6.34 longterm release.
> >>     If you see a problem with using this for longterm, please comment.
> >>                    -------------------
> >>
> >> commit c7c25802b39c443b3745cfa973dc49a97a3491f8 upstream.
> >>
> >> Disable preemption in init_ibs(). The function only checks the
> >> ibs capabilities and sets up pci devices (if necessary). It runs
> >> only on one cpu but operates with the local APIC and some MSRs,
> >> thus it is better to disable preemption.
> >>
> >> [    7.034377] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/483
> >> [    7.034385] caller is setup_APIC_eilvt+0x155/0x180
> >> [    7.034389] Pid: 483, comm: modprobe Not tainted 2.6.37-rc1-20101110+ #1
> >> [    7.034392] Call Trace:
> >> [    7.034400]  [<ffffffff812a2b72>] debug_smp_processor_id+0xd2/0xf0
> >> [    7.034404]  [<ffffffff8101e985>] setup_APIC_eilvt+0x155/0x180
> >> [ ... ]
> >>
> >> Addresses https://bugzilla.kernel.org/show_bug.cgi?id=22812
> >>
> >> Reported-by: <atswartz@gmail.com>
> >> Signed-off-by: Robert Richter <robert.richter@amd.com>
> >> Cc: oprofile-list@lists.sourceforge.net <oprofile-list@lists.sourceforge.net>
> >> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> >> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> >> Cc: Dan Carpenter <error27@gmail.com>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> LKML-Reference: <20110103111514.GM4739@erda.amd.com>
> >> [ small cleanups ]
> >> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> >> ---
> >>  arch/x86/oprofile/op_model_amd.c |   24 ++++++++++++++++--------
> >>  1 files changed, 16 insertions(+), 8 deletions(-)
> > 
> > This patch introduces a sleeping-while-atomic bug. There is another
> > upstream fix on top, see:
> > 
> > commit 3d2606f42984613d324ad3047cf503bcddc3880a
> > Author: Robert Richter <robert.richter@amd.com>
> > Date:   Fri May 20 09:46:54 2011 +0200
> > 
> >     oprofile, x86: Enable preemption during pci device setup in IBS init
> > 
> > This fix should be applied too (or instead).
> 
> Thanks Robert.  I guess I'll end up dropping c7c25802b39c
> then.  I just did a quick test and it appears the 2.6.34
> code base is too old for me to be able to apply 3d2606f4298
> in anything close to resembling its original form.

This would be ok. Current upstream code is a reimplementation very
different from .34.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

