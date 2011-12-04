Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab1LDUZD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 15:25:03 -0500
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:29177 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab1LDUZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 15:25:01 -0500
From: Daniel Lezcano <daniel.lezcano@free.fr>
To: akpm@linux-foundation.org
Cc: serge.hallyn@canonical.com, oleg@redhat.com,
        containers@lists.linux-foundation.org, gkurz@fr.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1][V3] Handle reboot in a child pid namespace
Date: Sun,  4 Dec 2011 21:24:49 +0100
Message-Id: <1323030290-22216-1-git-send-email-daniel.lezcano@free.fr>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ChangeLog:

 * V3
   - removed lock and serialization of pid_ns_reboot
 * V2
   - added a lock for the pid namespace to prevent racy call
     to the 'reboot' syscall
   - Moved 'reboot' command assigned in zap_pid_ns_processes
     instead of wait_task_zombie
   - added tasklist lock around force_sig
   - added do_exit in pid_ns_reboot
   - used task_active_pid_ns instead of declaring a new variable in sys_reboot
   - moved code up before POWER_OFF changed to HALT in sys_reboot

Daniel Lezcano (1):
  Add reboot_pid_ns to handle the reboot syscall

 include/linux/pid_namespace.h |    8 +++++++-
 kernel/pid_namespace.c        |   33 +++++++++++++++++++++++++++++++++
 kernel/sys.c                  |    3 +++
 3 files changed, 43 insertions(+), 1 deletions(-)

-- 
1.7.5.4

