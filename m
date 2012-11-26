Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab2KZQk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:40:29 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54311 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab2KZQk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:40:27 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Rickard Andersson <rickard.andersson@stericsson.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH v5 0/5] cpufreq: handle SW coordinated CPUs
Date: Mon, 26 Nov 2012 17:39:51 +0100
Message-Id: <1353947996-26723-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

this patchset is a new version of the cpufreq SW coordinated CPU bug fix.
That's basically the v4 rebased on linux-pm's linux-next tree, split in 5
patches for readability and with the bug fixed also in the "conservative"
governor.

Regards,
Fabio


Changes:
v5
- rebased/reimplemented on linux-next
- split hotplug code on a separate patch
- split ondemand/conservative specific fixes on separate patches
v4
- moved update_sampling rate code on separate patch
- simplified dbs_sw_coordinated_cpus
- reworked timer handling for code readability, now:
  * do_dbs_timer() [-> dbs_timer_coordinated()] -> dbs_timer_update()
- simplified cpu_callback cases
v3
- original submission


Fabio Baltieri (4):
  cpufreq: star/stop cpufreq timers on cpu hotplug
  cpufreq: ondemand: call dbs_check_cpu only when necessary
  cpufreq: conservative: call dbs_check_cpu only when necessary
  cpufreq: ondemand: use all CPUs in update_sampling_rate

Rickard Andersson (1):
  cpufreq: handle SW coordinated CPUs

 drivers/cpufreq/cpufreq_conservative.c |  46 ++++++++++++--
 drivers/cpufreq/cpufreq_governor.c     | 106 +++++++++++++++++++++++++++++++--
 drivers/cpufreq/cpufreq_governor.h     |   2 +
 drivers/cpufreq/cpufreq_ondemand.c     |  62 +++++++++++++++----
 4 files changed, 193 insertions(+), 23 deletions(-)

-- 
1.7.12.1

