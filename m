Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965302Ab2EOPcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:32:01 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:59118 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965257Ab2EOPb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:31:57 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
Organization: ScaleMP Ltd.
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, ido@wizery.com,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Subject: [PATCH v2 0/2] Move x86_cpu_to_apicid to the __read_mostly section
Date: Tue, 15 May 2012 18:31:49 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.32-41-generic; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205151831.49754.vlad@scalemp.com>
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

thanks,
vlad
