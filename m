Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab1BOC3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 21:29:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58501 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab1BOC3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 21:29:00 -0500
Date: Tue, 15 Feb 2011 03:28:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, x86@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, hpa@linux.intel.com, ankita@in.ibm.com
Subject: Re: [PATCHSET x86/numa] x86-64, NUMA: bring sanity to NUMA emulation
Message-ID: <20110215022842.GD31134@elte.hu>
References: <1297711715-3086-1-git-send-email-tj@kernel.org>
 <AANLkTikNy-vQ2V95dhyQ8k1jkQCiUOukY8ShP_GWM1w6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikNy-vQ2V95dhyQ8k1jkQCiUOukY8ShP_GWM1w6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Mon, Feb 14, 2011 at 11:28 AM, Tejun Heo <tj@kernel.org> wrote:
> > Hello,
> >
> > NUMA emulation is quite convoluted involving unnecessary mapping and
> > reverse mapping between apicids, PXMs, nodes and memory addresses.
> > This patchset tries to restore some sanity to the whole thing.
> >
> > Tested on an opteron NUMA machine which can do both ACPI and AMD
> > configs.  All NUMA configs, emulations, !NUMA and UP work as expected.
> >
> > This patchset is on top of tip/x86/numa[1] +
> > bring-sanity-to-NUMA-configuration patchset[2] and contains the
> > following 7 patches.
> >
> >  0001-x86-64-NUMA-Trivial-changes-to-prepare-for-emulation.patch
> >  0002-x86-64-NUMA-Build-and-use-direct-emulated-nid-phys-n.patch
> >  0003-x86-64-NUMA-Make-emulation-code-build-numa_meminfo-a.patch
> >  0004-x86-64-NUMA-Wrap-node-ID-during-emulation.patch
> >  0005-x86-64-NUMA-Emulate-directly-from-numa_meminfo.patch
> >  0006-x86-64-NUMA-Unify-emulated-apicid-node-mapping-trans.patch
> >  0007-x86-64-NUMA-Unify-emulated-distance-mapping.patch
> >
> > The patchset is available in the following git branch.
> >
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_64-numa-emu-unify
> >
> > Diffstat follows.
> >
> >  arch/x86/include/asm/acpi.h    |    6
> >  arch/x86/include/asm/amd_nb.h  |    4
> >  arch/x86/include/asm/numa_64.h |    1
> >  arch/x86/mm/amdtopology_64.c   |   47 ----
> >  arch/x86/mm/numa_64.c          |  429 ++++++++++++++++++-----------------------
> >  arch/x86/mm/srat_64.c          |   87 --------
> >  6 files changed, 197 insertions(+), 377 deletions(-)
> 
> wonder if numa_emu code could be put into one single file like numa_emu.c

That would be nice if it can be done sanely.

We could do it as a delta, on top of these existing patches, to not delay the 
testing of these fixes/improvements, they are looking pretty good (on paper) 
already, do you agree?

Thanks,

	Ingo
