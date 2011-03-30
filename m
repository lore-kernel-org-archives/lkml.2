Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964874Ab1C3VHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:07:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:43212 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933258Ab1C3VHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903735101"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: error27@gmail.com, mchehab@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [117/275] [v3,media] av7110: check for negative array offset
Message-Id: <20110330210556.D74053E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dan Carpenter <error27@gmail.com>

commit cb26a24ee9706473f31d34cc259f4dcf45cd0644 upstream.

info->num comes from the user.  It's type int.  If the user passes
in a negative value that would cause memory corruption.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/media/dvb/ttpci/av7110_ca.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/media/dvb/ttpci/av7110_ca.c
===================================================================
--- linux-2.6.35.y.orig/drivers/media/dvb/ttpci/av7110_ca.c	2011-03-29 22:51:21.638169502 -0700
+++ linux-2.6.35.y/drivers/media/dvb/ttpci/av7110_ca.c	2011-03-29 23:03:00.655283403 -0700
@@ -277,7 +277,7 @@
 	{
 		ca_slot_info_t *info=(ca_slot_info_t *)parg;
 
-		if (info->num > 1)
+		if (info->num < 0 || info->num > 1)
 			return -EINVAL;
 		av7110->ci_slot[info->num].num = info->num;
 		av7110->ci_slot[info->num].type = FW_CI_LL_SUPPORT(av7110->arm_app) ?
