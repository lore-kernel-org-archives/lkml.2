Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab2EUPCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:02:09 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:57912 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2EUPCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:02:07 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, Shai@scalemp.com,
        ido@wizery.com
Subject: [PATCH v4 0/2] Move x86_cpu_to_apicid to the __read_mostly section
Date: Mon, 21 May 2012 18:02:04 +0300
Message-ID: <1744141.b5asW8k6jC@vlad>
Organization: ScaleMP Ltd.
User-Agent: KMail/4.8.2 (Linux/3.2.0-24-generic; KDE/4.8.2; i686; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
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

v4 changes:
- Fixed the authors signatures in the patches.

v3 changes:
- Added the missing definitions of DEFINE_EARLY_PER_CPU_READ_MOSTLY()
  and DECLARE_EARLY_PER_CPU_READ_MOSTLY() macros in the !CONFIG_SMP code
  path in arch/x86/include/asm/percpu.h.

thanks,
vlad
