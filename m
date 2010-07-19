Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936522Ab0GSShh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:37:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:1264 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936510Ab0GSShK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:37:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,228,1278313200"; 
   d="scan'208";a="639823102"
Message-Id: <20100719181941.971215286@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 11:35:41 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 0/3] x86: xsaveopt kernel enabling patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AVX Programming Reference (June, 2010 version) located at
http://software.intel.com/en-us/avx/ refers to the optimized
extended state save instruction "xsaveopt".

xsaveopt is similar to xsave and incorporates optimizations specifically
targeted for speeding up context switch save, like:
a. if a state is in an INIT state, the instruction may clear the corresponding
   bit in the xheader.bv with out writing the actual state in to the memory.
b. if the state hasn't been modified since the last xrstor, the instruction
   may not write out the state to the save area.

Following patches enable the use of xsaveopt for context switch save/restore
of the extended state.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

