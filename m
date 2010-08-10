Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab0HJO6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 10:58:10 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35846 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab0HJO6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 10:58:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=d4G4xA0/RmY4uwiZsZv/HbW6v/UXWvRjMIwYa4iKjpGciVxjWstgIN+Ip1ELlh1lY8
         q6UbZ3pV7q2Yv2Wc4Ah2FByxBKJm3qYbl5+WWYSnUNty8b/yd6LsxQN2TzOYcnVLJfvU
         ZdFQj+y6GYCL5yxS8y5qZ46BU6+PbH6fPiG4E=
From: Namhyung Kim <namhyung@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] percpu: use INT_MAX as sentinel value of unit_map
Date: Tue, 10 Aug 2010 23:58:03 +0900
Message-Id: <1281452283-2911-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unit_map is a pointer to int so it would be more reasonable to use INT_MAX
as sentinel value.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/percpu.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 6470e77..9581f84 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1390,7 +1390,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	unit_off = alloc_bootmem(nr_cpu_ids * sizeof(unit_off[0]));
 
 	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
-		unit_map[cpu] = UINT_MAX;
+		unit_map[cpu] = INT_MAX;
 	pcpu_first_unit_cpu = NR_CPUS;
 
 	for (group = 0, unit = 0; group < ai->nr_groups; group++, unit += i) {
@@ -1406,7 +1406,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 
 			PCPU_SETUP_BUG_ON(cpu > nr_cpu_ids);
 			PCPU_SETUP_BUG_ON(!cpu_possible(cpu));
-			PCPU_SETUP_BUG_ON(unit_map[cpu] != UINT_MAX);
+			PCPU_SETUP_BUG_ON(unit_map[cpu] != INT_MAX);
 
 			unit_map[cpu] = unit + i;
 			unit_off[cpu] = gi->base_offset + i * ai->unit_size;
@@ -1419,7 +1419,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	pcpu_nr_units = unit;
 
 	for_each_possible_cpu(cpu)
-		PCPU_SETUP_BUG_ON(unit_map[cpu] == UINT_MAX);
+		PCPU_SETUP_BUG_ON(unit_map[cpu] == INT_MAX);
 
 	/* we're done parsing the input, undefine BUG macro and dump config */
 #undef PCPU_SETUP_BUG_ON
-- 
1.7.0.4

