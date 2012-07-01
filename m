Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab2GASQv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:16:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47035 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756013Ab2GASQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:45 -0400
Message-Id: <20120701172011.511054573@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Matt Fleming <matt@console-pimps.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Robert Richter <robert.richter@amd.com>
Subject: [ 34/48] oprofile: perf: use NR_CPUS instead or nr_cpumask_bits for static
 array
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit e734568b675c985db2026848fefaac01c22977a5 upstream.

The OProfile perf backend uses a static array to keep track of the
perf events on the system. When compiling with CONFIG_CPUMASK_OFFSTACK=y
&& SMP, nr_cpumask_bits is not a compile-time constant and the build
will fail with:

oprofile_perf.c:28: error: variably modified 'perf_events' at file scope

This patch uses NR_CPUs instead of nr_cpumask_bits for the array
initialisation. If this causes space problems in the future, we can
always move to dynamic allocation for the events array.

Cc: Matt Fleming <matt@console-pimps.org>
Reported-by: Russell King - ARM Linux <linux@arm.linux.org.uk>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/oprofile/oprofile_perf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
index da14432..efc4b7f 100644
--- a/drivers/oprofile/oprofile_perf.c
+++ b/drivers/oprofile/oprofile_perf.c
@@ -25,7 +25,7 @@ static int oprofile_perf_enabled;
 static DEFINE_MUTEX(oprofile_perf_mutex);
 
 static struct op_counter_config *counter_config;
-static struct perf_event **perf_events[nr_cpumask_bits];
+static struct perf_event **perf_events[NR_CPUS];
 static int num_counters;
 
 /*


