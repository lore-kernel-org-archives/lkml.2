Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162507Ab2GLX2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:28:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161962Ab2GLWlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:41:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matt Fleming <matt@console-pimps.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [ 110/187] oprofile: perf: use NR_CPUS instead or nr_cpumask_bits for static array
Date: Thu, 12 Jul 2012 15:34:26 -0700
Message-Id: <20120712191532.567470140@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/oprofile/oprofile_perf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/oprofile/oprofile_perf.c
+++ b/drivers/oprofile/oprofile_perf.c
@@ -25,7 +25,7 @@ static int oprofile_perf_enabled;
 static DEFINE_MUTEX(oprofile_perf_mutex);
 
 static struct op_counter_config *counter_config;
-static struct perf_event **perf_events[nr_cpumask_bits];
+static struct perf_event **perf_events[NR_CPUS];
 static int num_counters;
 
 /*


