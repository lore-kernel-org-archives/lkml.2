Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab2H2FQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 01:16:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62490 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab2H2FQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 01:16:17 -0400
X-IronPort-AV: E=Sophos;i="4.80,332,1344182400"; 
   d="scan'208";a="5744210"
Message-ID: <503DA6E7.3000406@cn.fujitsu.com>
Date: Wed, 29 Aug 2012 13:21:43 +0800
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
Subject: [PATCH v10 4/6] add a new qevent: QEVENT_GUEST_PANICKED
References: <503DA63E.40608@cn.fujitsu.com>
In-Reply-To: <503DA63E.40608@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/29 13:16:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/29 13:16:04,
	Serialize complete at 2012/08/29 13:16:04
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
index b17b1bb..f74dd2d 100644
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

