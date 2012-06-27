Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab2F0G5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 02:57:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13236 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab2F0G5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 02:57:04 -0400
X-IronPort-AV: E=Sophos;i="4.77,483,1336320000"; 
   d="scan'208";a="5272481"
Message-ID: <4FEAAFC1.4060801@cn.fujitsu.com>
Date: Wed, 27 Jun 2012 15:01:21 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 4/6 v5] add a new qevent: QEVENT_GUEST_PANICKED
References: <4FEAAE6E.7070302@cn.fujitsu.com>
In-Reply-To: <4FEAAE6E.7070302@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/27 14:57:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/27 14:57:15,
	Serialize complete at 2012/06/27 14:57:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new qevent QEVENT_GUEST_PANICKED. QEMU will emit this
event if the guest is panicked.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 monitor.c |    1 +
 monitor.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/monitor.c b/monitor.c
index f6107ba..28f7482 100644
--- a/monitor.c
+++ b/monitor.c
@@ -458,6 +458,7 @@ static const char *monitor_event_names[] = {
     [QEVENT_SUSPEND] = "SUSPEND",
     [QEVENT_WAKEUP] = "WAKEUP",
     [QEVENT_BALLOON_CHANGE] = "BALLOON_CHANGE",
+    [QEVENT_GUEST_PANICKED] = "GUEST_PANICKED",
 };
 QEMU_BUILD_BUG_ON(ARRAY_SIZE(monitor_event_names) != QEVENT_MAX)
 
diff --git a/monitor.h b/monitor.h
index 5f4de1b..cb7de8c 100644
--- a/monitor.h
+++ b/monitor.h
@@ -42,6 +42,7 @@ typedef enum MonitorEvent {
     QEVENT_SUSPEND,
     QEVENT_WAKEUP,
     QEVENT_BALLOON_CHANGE,
+    QEVENT_GUEST_PANICKED,
 
     /* Add to 'monitor_event_names' array in monitor.c when
      * defining new events here */
-- 
1.7.1

