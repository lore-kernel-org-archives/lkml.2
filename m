Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078Ab2JYDn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 23:43:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14413 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933873Ab2JYDmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 23:42:43 -0400
X-IronPort-AV: E=Sophos;i="4.80,645,1344182400"; 
   d="scan'208";a="6064362"
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
Subject: [PATCH v11 4/6] add a new qevent: QEVENT_GUEST_PANICKED
Date: Thu, 25 Oct 2012 11:42:36 +0800
Message-Id: <1351136563-15073-4-git-send-email-hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <0a2274eccf1b1dd420f16359f7e1de74fa2f9fbe.1351131144.git.hutao@cn.fujitsu.com>
References: <0a2274eccf1b1dd420f16359f7e1de74fa2f9fbe.1351131144.git.hutao@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/25 11:41:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/25 11:42:02,
	Serialize complete at 2012/10/25 11:42:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This event will be emited when the guest is panicked.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 monitor.c |    1 +
 monitor.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/monitor.c b/monitor.c
index d17ae2d..d2e4bbf 100644
--- a/monitor.c
+++ b/monitor.c
@@ -457,6 +457,7 @@ static const char *monitor_event_names[] = {
     [QEVENT_WAKEUP] = "WAKEUP",
     [QEVENT_BALLOON_CHANGE] = "BALLOON_CHANGE",
     [QEVENT_SPICE_MIGRATE_COMPLETED] = "SPICE_MIGRATE_COMPLETED",
+    [QEVENT_GUEST_PANICKED] = "GUEST_PANICKED",
 };
 QEMU_BUILD_BUG_ON(ARRAY_SIZE(monitor_event_names) != QEVENT_MAX)
 
diff --git a/monitor.h b/monitor.h
index b6e7d95..3962340 100644
--- a/monitor.h
+++ b/monitor.h
@@ -45,6 +45,7 @@ typedef enum MonitorEvent {
     QEVENT_WAKEUP,
     QEVENT_BALLOON_CHANGE,
     QEVENT_SPICE_MIGRATE_COMPLETED,
+    QEVENT_GUEST_PANICKED,
 
     /* Add to 'monitor_event_names' array in monitor.c when
      * defining new events here */
-- 
1.7.10.2

