Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029Ab1JNR2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:28:52 -0400
Received: from re04.intra2net.com ([82.165.46.26]:47328 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab1JNR2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:28:50 -0400
Message-ID: <4E9869B4.6080702@intra2net.com>
Date: Fri, 14 Oct 2011 18:56:20 +0200
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: linux-kernel@vger.kernel.org
Subject: [slabinfo PATCH] Fix off-by-one after readlink() call
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 tools/slub/slabinfo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/slub/slabinfo.c b/tools/slub/slabinfo.c
index 868cc93..cc1a378 100644
--- a/tools/slub/slabinfo.c
+++ b/tools/slub/slabinfo.c
@@ -1145,7 +1145,7 @@ static void read_slab_dir(void)
 		switch (de->d_type) {
 		   case DT_LNK:
 			alias->name = strdup(de->d_name);
-			count = readlink(de->d_name, buffer, sizeof(buffer));
+			count = readlink(de->d_name, buffer, sizeof(buffer)-1);
 
 			if (count < 0)
 				fatal("Cannot read symlink %s\n", de->d_name);
-- 
1.7.6.4

