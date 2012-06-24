Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab2FXRlH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 13:41:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56298 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2FXRlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 13:41:04 -0400
Message-ID: <4FE7512D.2010608@lwfinger.net>
Date: Sun, 24 Jun 2012 12:41:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Question about the export of symbol lockdep_init_map
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

when you added the locking correctness validator code in commit fbb9ce95, you 
exported lockdep_init_map() with EXPORT_SYMBOL_GPL. This choice is causing a 
problem with the latest version of Broadcom's hybrid wl driver. Although I do 
not agree with their policies regarding drivers with binary blobs, there are 
some devices such as the BCM43228 (14e4:4359) for which no open-source driver is 
yet available. As a result, owners of such devices are forced to use solutions 
such as ndiswrapper, which is worse than using wl.

would you accept the following patch?

Index: wireless-testing/kernel/lockdep.c
===================================================================
--- wireless-testing.orig/kernel/lockdep.c
+++ wireless-testing/kernel/lockdep.c
@@ -2994,7 +2994,7 @@ void lockdep_init_map(struct lockdep_map
         if (subclass)
                 register_lock_class(lock, subclass, 1);
  }
-EXPORT_SYMBOL_GPL(lockdep_init_map);
+EXPORT_SYMBOL(lockdep_init_map);

  struct lock_class_key __lockdep_no_validate__;


Thanks,

Larry
