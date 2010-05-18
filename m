Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab0ERMJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 08:09:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:11272 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284Ab0ERMJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 08:09:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,255,1272870000"; 
   d="scan'208";a="518927045"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Alek Du <alek.du@intel.com>, Alan Cox <alan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 0/2] v3 Moorestown clock related patches
Date: Tue, 18 May 2010 05:02:44 -0700
Message-Id: <1274184166-17242-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Please review the two patches related Moorestown/Medfield clock selection
logic. tglx has suggested a much cleaner logic in
http://lkml.org/lkml/2010/5/17/406
So patch #2 is the implementation of new logic plus small tweaks based on
testing results.
I also dropped x86_mask check for Penwell CPU check. It is not needed, CPU
family and model should be sufficient/accurate to identify Lincroft vs
Penwell.

*** BLURB HERE ***

Jacob Pan (2):
  x86/mrst: add cpu type detection
  x86/mrst: add more timer config options

 arch/x86/include/asm/apb_timer.h |    1 -
 arch/x86/include/asm/mrst.h      |   20 +++++++
 arch/x86/kernel/apb_timer.c      |   37 +++----------
 arch/x86/kernel/mrst.c           |  109 ++++++++++++++++++++++++++++++--------
 4 files changed, 114 insertions(+), 53 deletions(-)

