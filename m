Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab0ESKTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 06:19:23 -0400
Received: from www.tglx.de ([62.245.132.106]:53644 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721Ab0ESKTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 06:19:21 -0400
Date: Wed, 19 May 2010 12:19:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: jacob pan <jacob.jun.pan@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alek Du <alek.du@intel.com>,
       Alan Cox <alan@linux.intel.com>, Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH 1/2] v4 x86/mrst: add cpu type detection
In-Reply-To: <20100519022335.00007d65@unknown>
Message-ID: <alpine.LFD.2.00.1005191210440.3368@localhost.localdomain>
References: <1274184166-17242-1-git-send-email-jacob.jun.pan@linux.intel.com> <1274184166-17242-2-git-send-email-jacob.jun.pan@linux.intel.com> <alpine.LFD.2.00.1005182250460.3368@localhost.localdomain> <20100519022335.00007d65@unknown>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010, jacob pan wrote:
> 
> >  Aside of that wouldn't it make more sense to do the chip
> >  identification only once from mrst_init() and cache the result and
> >  change mrst_identify_cpu()
> >
> the problem is again the ordering of cpuid, boot_cpu_data is not available
> by the time we call  x86_mrst_early_setup(). I can move it to mrst_time_init()

Hmm, right.

> but not very ideal. Unless we go back to do cpuid directly in the v1 patch :).

x86_init.oem.arch_setup() is the point where you can do that, that's
called after early_cpu_init() which fills boot_cpu_data. It's way
before the first user of mrst_chip.

Thanks,

	tglx


