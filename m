Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965623Ab2CAVuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:50:55 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63550 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965609Ab2CAVuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:50:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.231.228 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213927.752750494@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, rjw@sisk.pl, valdis.kletnieks@vt.edu,
        cloos@hjcloos.com, riesebie@lxtec.de,
        penguin-kernel@i-love.sakura.ne.jp, srivatsa.bhat@linux.vnet.ibm.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: [ 34/34] PM / Sleep: Fix read_unlock_usermodehelper() call.
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------


From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit e4c89a508f4385a0cd8681c2749a2cd2fa476e40 ]

Commit b298d289
 "PM / Sleep: Fix freezer failures due to racy usermodehelper_is_disabled()"
added read_unlock_usermodehelper() but read_unlock_usermodehelper() is called
without read_lock_usermodehelper() when kmalloc() failed.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

 drivers/base/firmware_class.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -493,8 +493,7 @@ _request_firmware(const struct firmware
 	if (!firmware) {
 		dev_err(device, "%s: kmalloc(struct firmware) failed\n",
 			__func__);
-		retval = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;


