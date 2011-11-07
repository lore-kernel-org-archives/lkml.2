Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab1KGRjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:39:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755909Ab1KGRjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:39:52 -0500
Date: Mon, 7 Nov 2011 12:39:48 -0500
From: Dave Jones <davej@redhat.com>
To: x86@kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: BAD APICID ?
Message-ID: <20111107173948.GA1344@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, x86@kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We got a report from a Fedora user hitting a WARN_ON in the apic setup code.

Here..

1230 #ifdef CONFIG_X86_32
1231         /*
1232          * APIC LDR is initialized.  If logical_apicid mapping was
1233          * initialized during get_smp_config(), make sure it matches the
1234          * actual value.
1235          */
1236         i = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
1237         WARN_ON(i != BAD_APICID && i != logical_smp_processor_id());
1238         /* always use the value from LDR */
1239         early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
1240                 logical_smp_processor_id();

The full report is at https://bugzilla.redhat.com/show_bug.cgi?id=743930

Report is against our 3.0 builds, but that code look unchanged in 3.1 too,
and even in current Linus head.

Any thoughts on what could cause this ?

	Dave

