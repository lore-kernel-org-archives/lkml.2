Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934433Ab0HMOAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 10:00:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33212 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934386Ab0HMOAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 10:00:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SBaRYNuruQgiwMipyW6P3ct3B7T7epPEbnASE9WjcyOHCcHICtmO6PKpsmqgdD5Ww8
         9rIqfdjJ+Snspzoah1gBONMEhIb9OU26XQDDGZcdxeXFxxBZC6/RSZfjIjdkeVrLoPqK
         y05K/WbkKfWAglp4iOlfsjegN8hr2VYUYFYx0=
From: Namhyung Kim <namhyung@gmail.com>
To: Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] [CPUFREQ] acpi-cpufreq: add missing __percpu markup
Date: Fri, 13 Aug 2010 23:00:11 +0900
Message-Id: <1281708011-26583-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_perf_data is a percpu pointer but was missing __percpu markup.
Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 246cd3a..cd8da24 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -72,7 +72,7 @@ struct acpi_cpufreq_data {
 static DEFINE_PER_CPU(struct acpi_cpufreq_data *, acfreq_data);
 
 /* acpi_perf_data is a pointer to percpu data. */
-static struct acpi_processor_performance *acpi_perf_data;
+static struct acpi_processor_performance __percpu *acpi_perf_data;
 
 static struct cpufreq_driver acpi_cpufreq_driver;
 
-- 
1.7.0.4

