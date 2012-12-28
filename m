Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab2L1TVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:21:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55732 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932492Ab2L1TT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:59 -0500
Message-Id: <20121228190334.613933196@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:52 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 022/173] scsi: aha152x: Fix sparse warning and make printing pointer address
 more portable.
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>

commit b631cf1f899f9d2e449884dbccc34940637c639f upstream.

This is to change use of "0x%08x" in favour of "%p" as per ../Documentation/printk-formats.txt,
which also takes care about the following warning during compilation time:

  drivers/scsi/aha152x.c: In function ‘get_command’:
  drivers/scsi/aha152x.c:2987: warning: cast from pointer to integer of different size

Signed-off-by: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/aha152x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 19a3694..dd4547b 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -2984,8 +2984,8 @@ static int get_command(char *pos, Scsi_Cmnd * ptr)
 	char *start = pos;
 	int i;
 
-	SPRINTF("0x%08x: target=%d; lun=%d; cmnd=( ",
-		(unsigned int) ptr, ptr->device->id, ptr->device->lun);
+	SPRINTF("%p: target=%d; lun=%d; cmnd=( ",
+		ptr, ptr->device->id, ptr->device->lun);
 
 	for (i = 0; i < COMMAND_SIZE(ptr->cmnd[0]); i++)
 		SPRINTF("0x%02x ", ptr->cmnd[i]);


