Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab2DPS35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:29:57 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14839 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab2DPS34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:29:56 -0400
Date: Mon, 16 Apr 2012 20:29:54 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Tejun Heo <tj@kernel.org>, Danny Kukawka <danny.kukawka@bisect.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] dac960: Remove unused variables from
 DAC960_CreateProcEntries()
Message-ID: <alpine.LNX.2.00.1204162025430.21898@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variables 'StatusProcEntry' and 'UserCommandProcEntry' are
assigned to once and then never used. This patch gets rid of the
variables.

While I was there I also fixed the indentation of the function to use
tabs rather than spaces for the lines that did not already do so.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/block/DAC960.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

  Disclaimer: I don't have the hardware, so the only testing this has seen 
  is that I verified that it compiles.

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 8db9089..9a13e88 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -6580,24 +6580,21 @@ static const struct file_operations dac960_user_command_proc_fops = {
 
 static void DAC960_CreateProcEntries(DAC960_Controller_T *Controller)
 {
-	struct proc_dir_entry *StatusProcEntry;
 	struct proc_dir_entry *ControllerProcEntry;
-	struct proc_dir_entry *UserCommandProcEntry;
 
 	if (DAC960_ProcDirectoryEntry == NULL) {
-  		DAC960_ProcDirectoryEntry = proc_mkdir("rd", NULL);
-  		StatusProcEntry = proc_create("status", 0,
-					   DAC960_ProcDirectoryEntry,
-					   &dac960_proc_fops);
+		DAC960_ProcDirectoryEntry = proc_mkdir("rd", NULL);
+		proc_create("status", 0, DAC960_ProcDirectoryEntry,
+			    &dac960_proc_fops);
 	}
 
-      sprintf(Controller->ControllerName, "c%d", Controller->ControllerNumber);
-      ControllerProcEntry = proc_mkdir(Controller->ControllerName,
-				       DAC960_ProcDirectoryEntry);
-      proc_create_data("initial_status", 0, ControllerProcEntry, &dac960_initial_status_proc_fops, Controller);
-      proc_create_data("current_status", 0, ControllerProcEntry, &dac960_current_status_proc_fops, Controller);
-      UserCommandProcEntry = proc_create_data("user_command", S_IWUSR | S_IRUSR, ControllerProcEntry, &dac960_user_command_proc_fops, Controller);
-      Controller->ControllerProcEntry = ControllerProcEntry;
+	sprintf(Controller->ControllerName, "c%d", Controller->ControllerNumber);
+	ControllerProcEntry = proc_mkdir(Controller->ControllerName,
+					 DAC960_ProcDirectoryEntry);
+	proc_create_data("initial_status", 0, ControllerProcEntry, &dac960_initial_status_proc_fops, Controller);
+	proc_create_data("current_status", 0, ControllerProcEntry, &dac960_current_status_proc_fops, Controller);
+	proc_create_data("user_command", S_IWUSR | S_IRUSR, ControllerProcEntry, &dac960_user_command_proc_fops, Controller);
+	Controller->ControllerProcEntry = ControllerProcEntry;
 }
 
 
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

