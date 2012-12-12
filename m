Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab2LLGPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:15:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27919 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab2LLGN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:13:59 -0500
X-IronPort-AV: E=Sophos;i="4.84,264,1355068800"; 
   d="scan'208";a="6380976"
From: Hu Tao <hutao@cn.fujitsu.com>
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v12 5/8] add a new qevent: QEVENT_GUEST_PANICKED
Date: Wed, 12 Dec 2012 14:13:48 +0800
Message-Id: <242c44cd4bf0dc2efffe9cd65f0e46b2108a1d55.1355290850.git.hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0.1.240.ge8a1f5a
In-Reply-To: <cover.1355290850.git.hutao@cn.fujitsu.com>
References: <cover.1355290850.git.hutao@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/12 14:13:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/12 14:13:06,
	Serialize complete at 2012/12/12 14:13:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This event will be emited when the guest is panicked.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 monitor.c | 1 +
 monitor.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/monitor.c b/monitor.c
index 1226501..231785b 100644
--- a/monitor.c
+++ b/monitor.c
@@ -458,6 +458,7 @@ static const char *monitor_event_names[] = {
     [QEVENT_WAKEUP] = "WAKEUP",
     [QEVENT_BALLOON_CHANGE] = "BALLOON_CHANGE",
     [QEVENT_SPICE_MIGRATE_COMPLETED] = "SPICE_MIGRATE_COMPLETED",
+    [QEVENT_GUEST_PANICKED] = "GUEST_PANICKED",
 };
 QEMU_BUILD_BUG_ON(ARRAY_SIZE(monitor_event_names) != QEVENT_MAX)
 
diff --git a/monitor.h b/monitor.h
index b4ef955..16c1c83 100644
--- a/monitor.h
+++ b/monitor.h
@@ -46,6 +46,7 @@ typedef enum MonitorEvent {
     QEVENT_WAKEUP,
     QEVENT_BALLOON_CHANGE,
     QEVENT_SPICE_MIGRATE_COMPLETED,
+    QEVENT_GUEST_PANICKED,
 
     /* Add to 'monitor_event_names' array in monitor.c when
      * defining new events here */
-- 
1.8.0.1.240.ge8a1f5a

