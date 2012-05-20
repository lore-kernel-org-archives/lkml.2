Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab2ETPTQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 11:19:16 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:34885 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2ETPTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 11:19:14 -0400
Message-ID: <1337527148.6093.14.camel@vlad>
Subject: [PATCH v3 0/2] Move x86_cpu_to_apicid to the __read_mostly section
From: Vlad Zolotarov <vlad@scalemp.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>
Cc: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>,
        Ido Yariv <ido@wizery.com>
Date: Sun, 20 May 2012 18:19:08 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pls., consider applying this patch series.
It contains the following changes:
 - Adds two new macros DEFINE_EARLY_PER_CPU_READ_MOSTLY() and
   DECLARE_EARLY_PER_CPU_READ_MOSTLY().
 - Adds "read-mostly" qualifier to the following variables in smp.h:
  - cpu_sibling_map
  - cpu_core_map
  - cpu_llc_shared_map
  - cpu_llc_id
  - cpu_number
  - x86_cpu_to_apicid
  - x86_bios_cpu_apicid
  - x86_cpu_to_logical_apicid

As long as all the variables above are only written during the initialization,
this change is meant to prevent the false sharing and improve the
performance on large multiprocessor systems.

v3 changes:
- Added the missing definitions of DEFINE_EARLY_PER_CPU_READ_MOSTLY()
and DECLARE_EARLY_PER_CPU_READ_MOSTLY() macros in the !CONFIG_SMP code
path in arch/x86/include/asm/percpu.h.


thanks,
vlad


