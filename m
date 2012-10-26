Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484Ab2JZLLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:11:04 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:27570 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153Ab2JZLK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:10:26 -0400
Subject: [PATCH 4/5] Documentation: update sysctl/kernel.txt
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Larry.Finger@lwfinger.net, mitsuo.hayasaka.hu@hitachi.com,
        nhorman@tuxdriver.com, linux-doc@vger.kernel.org,
        catalin.marinas@arm.com, xemul@parallels.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, cmetcalf@tilera.com, dhowells@redhat.com,
        ebiederm@xmission.com, rob@landley.net, dan@mindstab.net,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, devel@openvz.org,
        mtk.manpages@gmail.com
Date: Fri, 26 Oct 2012 15:06:12 +0400
Message-ID: <20121026110612.17494.95224.stgit@localhost.localdomain>
In-Reply-To: <20121026110103.17494.28182.stgit@localhost.localdomain>
References: <20121026110103.17494.28182.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds documentation about new "msg_next_id", "sem_next_id" and
"shm_next_id" sysctls.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
---
 Documentation/sysctl/kernel.txt |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 2907ba6..51b953a 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -38,6 +38,7 @@ show up in /proc/sys/kernel:
 - l2cr                        [ PPC only ]
 - modprobe                    ==> Documentation/debugging-modules.txt
 - modules_disabled
+- msg_next_id		      [ sysv ipc ]
 - msgmax
 - msgmnb
 - msgmni
@@ -62,7 +63,9 @@ show up in /proc/sys/kernel:
 - rtsig-max
 - rtsig-nr
 - sem
+- sem_next_id		      [ sysv ipc ]
 - sg-big-buff                 [ generic SCSI device (sg) ]
+- shm_next_id		      [ sysv ipc ]
 - shm_rmid_forced
 - shmall
 - shmmax                      [ sysv ipc ]
@@ -320,6 +323,22 @@ to false.
 
 ==============================================================
 
+msg_next_id, sem_next_id, and shm_next_id:
+
+These three toggles allows to specify desired id for next allocated IPC
+object: message, semaphore or shared memory respectively.
+
+By default they are equal to -1, which means generic allocation logic.
+Possible values to set are in range {0..INT_MAX}.
+
+Notes:
+1) kernel doesn't guarantee, that new object will have desired id. So,
+it's up to userspace, how to handle an object with "wrong" id.
+2) Toggle with non-default value will be set back to -1 by kernel after
+successful IPC object allocation.
+
+==============================================================
+
 nmi_watchdog:
 
 Enables/Disables the NMI watchdog on x86 systems. When the value is

