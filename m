Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272Ab2JSPwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:52:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59799 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab2JSPwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:52:36 -0400
Date: Fri, 19 Oct 2012 08:52:11 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-5bc66170dc486556a1e36fd384463536573f4b82@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        naveen.n.rao@linux.vnet.ibm.com, tony.luck@intel.com,
        tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        naveen.n.rao@linux.vnet.ibm.com, tglx@linutronix.de,
        tony.luck@intel.com, borislav.petkov@amd.com
In-Reply-To: <20121017105940.GA14590@x1.osrc.amd.com>
References: <20121017105940.GA14590@x1.osrc.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, MCE:
  Remove bios_cmci_threshold sysfs attribute
Git-Commit-ID: 5bc66170dc486556a1e36fd384463536573f4b82
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 19 Oct 2012 08:52:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5bc66170dc486556a1e36fd384463536573f4b82
Gitweb:     http://git.kernel.org/tip/5bc66170dc486556a1e36fd384463536573f4b82
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Thu, 18 Oct 2012 15:10:56 +0200
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Fri, 19 Oct 2012 15:22:29 +0200

x86, MCE: Remove bios_cmci_threshold sysfs attribute

450cc201038f3 ("x86/mce: Provide boot argument to honour bios-set CMCI
threshold") added the bios_cmci_threshold sysfs attribute which was
supposed to communicate to userspace tools that BIOS CMCI threshold has
been honoured.

However, this info is not of any importance to userspace - it should
rather get the actual error count it has been thresholded already from
MCi_STATUS[38:52].

So drop this before it becomes a used interface (good thing we caught
this early in 3.7-rc1, right after the merge window closed).

Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20121017105940.GA14590@x1.osrc.amd.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 29e87d3..46cbf86 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2209,11 +2209,6 @@ static struct dev_ext_attribute dev_attr_cmci_disabled = {
 	&mce_cmci_disabled
 };
 
-static struct dev_ext_attribute dev_attr_bios_cmci_threshold = {
-	__ATTR(bios_cmci_threshold, 0444, device_show_int, NULL),
-	&mce_bios_cmci_threshold
-};
-
 static struct device_attribute *mce_device_attrs[] = {
 	&dev_attr_tolerant.attr,
 	&dev_attr_check_interval.attr,
@@ -2222,7 +2217,6 @@ static struct device_attribute *mce_device_attrs[] = {
 	&dev_attr_dont_log_ce.attr,
 	&dev_attr_ignore_ce.attr,
 	&dev_attr_cmci_disabled.attr,
-	&dev_attr_bios_cmci_threshold.attr,
 	NULL
 };
 
