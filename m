Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2CLJVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 05:21:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:58772 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab2CLJVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 05:21:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="117668178"
Message-ID: <4F5DC01D.7040006@intel.com>
Date: Mon, 12 Mar 2012 17:21:33 +0800
From: ShuoX Liu <shuox.liu@intel.com>
Reply-To: shuox.liu@intel.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Valentin, Eduardo" <eduardo.valentin@ti.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Brown, Len" <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/3] cpuidle: Add a debugfs entry to disable specific C state
 for debug purpose.
References: <C6CB66606345BC4B80CBE69D22ABFBB10220E1@SHSMSX101.ccr.corp.intel.com> <4F545A4E.8010801@linux.vnet.ibm.com> <4F5466C4.2090808@intel.com> <20120305101827.GA19408@khazad-dum.debian.net> <CAGF5oy_BUytjeDa8Oc62pRabaEqwqKCFuVJuzLd-XNZg34ne2w@mail.gmail.com> <1330998885.1916.89.camel@ymzhang> <20120306052236.GA19416@kroah.com> <1331013078.1916.103.camel@ymzhang> <20120306143935.GA23346@kroah.com> <1331082051.1916.124.camel@ymzhang> <20120308180106.GD26516@kroah.com> <4F5DBFA8.3080300@intel.com>
In-Reply-To: <4F5DBFA8.3080300@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ShuoX Liu <shuox.liu@intel.com>

Some C states of new CPU might be not good. One reason is BIOS might 
configure
them incorrectly. To help developers root cause it quickly, the patch adds a
new debugfs entry, so developers could disable specific C state manually.

In addition, C state might have much impact on performance tuning, as it 
takes
much time to enter/exit C states, which might delay interrupt 
processing. With
the new debug option, developers could check if a deep C state could impact
performance and how much impact it could cause.

Also add this option in Documentation/cpuidle/debugfs.txt.

Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
Reviewed-by: Yanmin Zhang <yanmin_zhang@intel.com>
---
  Documentation/cpuidle/debugfs.txt |    5 +++++
  drivers/cpuidle/cpuidle.c         |    1 +
  drivers/cpuidle/debugfs.c         |    4 ++++
  drivers/cpuidle/governors/menu.c  |    5 ++++-
  include/linux/cpuidle.h           |    1 +
  5 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/Documentation/cpuidle/debugfs.txt 
b/Documentation/cpuidle/debugfs.txt
index 7724a69..ca393ba 100644
--- a/Documentation/cpuidle/debugfs.txt
+++ b/Documentation/cpuidle/debugfs.txt
@@ -20,6 +20,7 @@ drwxr-xr-x 2 root root 0 Feb  8 10:42 state3
  /sys/kernel/debug/cpu/cpu0/cpuidle/state0:
  total 0
  -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
+-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
  -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
  -r--r--r-- 1 root root 4096 Feb  8 10:42 name
  -r--r--r-- 1 root root 4096 Feb  8 10:42 power
@@ -29,6 +30,7 @@ total 0
  /sys/kernel/debug/cpu/cpu0/cpuidle/state1:
  total 0
  -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
+-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
  -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
  -r--r--r-- 1 root root 4096 Feb  8 10:42 name
  -r--r--r-- 1 root root 4096 Feb  8 10:42 power
@@ -38,6 +40,7 @@ total 0
  /sys/kernel/debug/cpu/cpu0/cpuidle/state2:
  total 0
  -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
+-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
  -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
  -r--r--r-- 1 root root 4096 Feb  8 10:42 name
  -r--r--r-- 1 root root 4096 Feb  8 10:42 power
@@ -47,6 +50,7 @@ total 0
  /sys/kernel/debug/cpu/cpu0/cpuidle/state3:
  total 0
  -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
+-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
  -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
  -r--r--r-- 1 root root 4096 Feb  8 10:42 name
  -r--r--r-- 1 root root 4096 Feb  8 10:42 power
@@ -56,6 +60,7 @@ total 0


  * desc : Small description about the idle state (string)
+* disable : Option to disable this idle state (bool)
  * latency : Latency to exit out of this idle state (in microseconds)
  * name : Name of the idle state (string)
  * power : Power consumed while in this idle state (in milliwatts)
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index b4946bc..fdaadb3 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -197,6 +197,7 @@ static void poll_idle_init(struct cpuidle_driver *drv)
  	state->power_usage = -1;
  	state->flags = 0;
  	state->enter = poll_idle;
+	state->disable = 0;
  }
  #else
  static void poll_idle_init(struct cpuidle_driver *drv) {}
diff --git a/drivers/cpuidle/debugfs.c b/drivers/cpuidle/debugfs.c
index 67ddc44..197ce72 100644
--- a/drivers/cpuidle/debugfs.c
+++ b/drivers/cpuidle/debugfs.c
@@ -87,6 +87,10 @@ static void debugfs_add_state_attrs(struct 
cpuidle_dev_state *dev_state)
  				parent, &state_usage->time))
  		goto error;

+	if (!debugfs_create_bool("disable", S_IRUGO | S_IWUSR,
+				parent, &state->disable))
+		goto error;
+
  	return;
  error:
  	debugfs_remove_recursive(parent);
diff --git a/drivers/cpuidle/governors/menu.c 
b/drivers/cpuidle/governors/menu.c
index ad09526..5c17ca1 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -280,7 +280,8 @@ static int menu_select(struct cpuidle_driver *drv, 
struct cpuidle_device *dev)
  	 * We want to default to C1 (hlt), not to busy polling
  	 * unless the timer is happening really really soon.
  	 */
-	if (data->expected_us > 5)
+	if (data->expected_us > 5 &&
+		drv->states[CPUIDLE_DRIVER_STATE_START].disable == 0)
  		data->last_state_idx = CPUIDLE_DRIVER_STATE_START;

  	/*
@@ -290,6 +291,8 @@ static int menu_select(struct cpuidle_driver *drv, 
struct cpuidle_device *dev)
  	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
  		struct cpuidle_state *s = &drv->states[i];

+		if (s->disable)
+			continue;
  		if (s->target_residency > data->predicted_us)
  			continue;
  		if (s->exit_latency > latency_req)
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index f605d28..a85877d 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -45,6 +45,7 @@ struct cpuidle_state {
  	unsigned int	exit_latency; /* in US */
  	unsigned int	power_usage; /* in mW */
  	unsigned int	target_residency; /* in US */
+	unsigned int    disable;

  	int (*enter)	(struct cpuidle_device *dev,
  			struct cpuidle_driver *drv,
-- 
1.7.1
