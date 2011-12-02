Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab1LBSHC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:07:02 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:59995 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231Ab1LBSHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:07:00 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM,
 kernel/power/user.c: Replace unintuitive 'if' condition with 'else'
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Fri, 02 Dec 2011 23:36:53 +0530
Message-ID: <20111202180645.15985.26730.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11120207-5490-0000-0000-00000041CA99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the snapshot_ioctl() function, under SNAPSHOT_FREEZE, the code below
freeze_processes() is a bit unintuitive. Improve it by replacing the
second 'if' condition with an 'else' clause.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/power/user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/power/user.c b/kernel/power/user.c
index 7cc3f5b..8c64d1c 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -259,7 +259,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		error = freeze_processes();
 		if (error)
 			usermodehelper_enable();
-		if (!error)
+		else
 			data->frozen = 1;
 		break;
 

