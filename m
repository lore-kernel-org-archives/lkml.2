Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab2HWC03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:26:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55326 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab2HWC0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:26:25 -0400
X-IronPort-AV: E=Sophos;i="4.77,812,1336320000"; 
   d="scan'208";a="5700337"
Message-ID: <5035960E.30803@cn.fujitsu.com>
Date: Thu, 23 Aug 2012 10:31:42 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v9 4/6] add a new qevent: QEVENT_GUEST_PANICKED
References: <50359561.9070001@cn.fujitsu.com>
In-Reply-To: <50359561.9070001@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/23 10:26:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/23 10:26:23,
	Serialize complete at 2012/08/23 10:26:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This event will be emited when the guest is panicked.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 monitor.c |    1 +
 monitor.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/monitor.c b/monitor.c
index 480f583..cd2adb7 100644
--- a/monitor.c
+++ b/monitor.c
@@ -455,6 +455,7 @@ static const char *monitor_event_names[] = {
     [QEVENT_SUSPEND_DISK] = "SUSPEND_DISK",
     [QEVENT_WAKEUP] = "WAKEUP",
     [QEVENT_BALLOON_CHANGE] = "BALLOON_CHANGE",
+    [QEVENT_GUEST_PANICKED] = "GUEST_PANICKED",
 };
 QEMU_BUILD_BUG_ON(ARRAY_SIZE(monitor_event_names) != QEVENT_MAX)
 
diff --git a/monitor.h b/monitor.h
index 47d556b..f48a502 100644
--- a/monitor.h
+++ b/monitor.h
@@ -43,6 +43,7 @@ typedef enum MonitorEvent {
     QEVENT_SUSPEND_DISK,
     QEVENT_WAKEUP,
     QEVENT_BALLOON_CHANGE,
+    QEVENT_GUEST_PANICKED,
 
     /* Add to 'monitor_event_names' array in monitor.c when
      * defining new events here */
-- 
1.7.1

