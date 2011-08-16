Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab1HPQoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 12:44:15 -0400
Received: from jester.euphonynet.be ([212.87.96.13]:44564 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab1HPQoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 12:44:14 -0400
From: Bart Van Assche <bvanassche@acm.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] docs/kobject: Explain device.groups
Date: Tue, 16 Aug 2011 18:44:06 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.1-1.2-default; KDE/4.6.0; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        rpearson@systemfabricworks.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108161844.07095.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many drivers use device_create_file() where device.groups should be
used instead. Since this has not yet been documented, add a note in
Documentation/kobject.txt that explains why device.groups should be
used.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/kobject.txt |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
index 3ab2472..0283c86 100644
--- a/Documentation/kobject.txt
+++ b/Documentation/kobject.txt
@@ -171,7 +171,10 @@ call to kobject_uevent():
 Use the KOBJ_ADD action for when the kobject is first added to the kernel.
 This should be done only after any attributes or children of the kobject
 have been initialized properly, as userspace will instantly start to look
-for them when this call happens.
+for them when this call happens. As an example, device attributes must be
+created by initializing device.groups properly before calling
+device_register() instead of calling device_create_file() after the device
+has been registered.
 
 When the kobject is removed from the kernel (details on how to do that is
 below), the uevent for KOBJ_REMOVE will be automatically created by the
-- 
1.7.3.4

