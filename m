Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab2EHSUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:20:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:54541 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab2EHSUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:20:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150636121"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>, Shane Wang <shane.wang@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH 00/23] x86, realmode: new infrastructure for realmode code
Date: Tue,  8 May 2012 21:20:03 +0300
Message-Id: <1336501226-28502-1-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been working together with H. Peter Anvin in order
replace the ad-hoc real-mode code inside .x86_trampoline
section with an encapsulated binary that is fully relocatable
to any memory location under 1MB. Everything that is needs to
be relocated is relocated during initialization.

Benefits:
- Simplifies things. Real-mode code does not have to find its
own location any more. This makes maintaining and extending 
this code much nicer experience.
- Cleans up code base a lot. Now real-mode code is encapsulated
from kernel both in source tree and in vmlinux.
- We can set proper permissions to pages of text, data/bss
and rodata. Before, .x86_trampoline had just rwx permissions.
