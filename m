Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab2HFQYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 12:24:44 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62331 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab2HFQYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 12:24:43 -0400
MIME-Version: 1.0
Date: Mon, 6 Aug 2012 16:24:42 +0000
Message-ID: <CAGh4K3Juk1SRYK363M8YMVD9HnFWO+41r+Uf94rWdM36FQ7LZw@mail.gmail.com>
Subject: [PATCH]: Updated autosleep.patch
From: Christopher Sacchi <chris.sacchi@gmail.com>
To: linux-pm@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the patch that fixes a function that could be changed. The
following (above the 2nd to last line, but uder the first line:
--
Signed-off-by: Christopher P. Sacchi <chris.sacchi@gmail.com>
--- linux-3.5/kernel/power/autosleep.c	2012-07-21 20:58:29.000000000 +0000
+++ linux-3.5/kernel/power/autosleep.c	2012-08-06 10:52:26.000000000 +0000
@@ -30,7 +30,7 @@ static void try_to_suspend(struct work_s
 	if (!pm_get_wakeup_count(&initial_count, true))
 		goto out;

-	mutex_lock(&autosleep_lock);
+	mutex_lock_interruptable();

 	if (!pm_save_wakeup_count(initial_count)) {
 		mutex_unlock(&autosleep_lock);
--

-- 
Christopher
