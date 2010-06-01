Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab0FALPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 07:15:14 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59484 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab0FALPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 07:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=CiJtKOIq9Pdr5TmQIf47GbWuOaVPPMx04wPLuqksiYsKzi5erpO4aJDVWP84ls7+OB
         ZdWwz9m4WhE6TXrqYfeJZt2qkuaYJTxjjORMQrMbo7aLcJFd9TwESWEZfDxN3Umw5C4w
         QM/e0KWbmKvYohzG+Hnk5BLvD33eioIezbw34=
MIME-Version: 1.0
Date: Tue, 1 Jun 2010 12:15:11 +0100
Message-ID: <AANLkTilnTVvZOw-bIpcKS0VwhlpYWnnxvOevNv67hnga@mail.gmail.com>
Subject: [2.6.35-rc1, patch] fix cpu_chain section mismatch...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.35-rc1, __cpu_notify access cpu_chain, which shouldn't be
marked __cpuinitdata (via section mismatch warning).

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 8b92539..97d1b42 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -34,7 +34,7 @@ void cpu_maps_update_done(void)
 	mutex_unlock(&cpu_add_remove_lock);
 }

-static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
+static RAW_NOTIFIER_HEAD(cpu_chain);

 /* If set, cpu_up and cpu_down will return -EBUSY and do nothing.
  * Should always be manipulated under cpu_add_remove_lock
-- 
Daniel J Blueman
