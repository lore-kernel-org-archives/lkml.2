Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab1DYUXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:23:48 -0400
Received: from 1wt.eu ([62.212.114.60]:33803 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225Ab1DYUXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:44 -0400
Message-Id: <20110425200234.728853745@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Dan Carpenter <error27@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 040/173] [media] [v3,media] av7110: check for negative array offset
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit cb26a24ee9706473f31d34cc259f4dcf45cd0644 upstream.

info->num comes from the user.  It's type int.  If the user passes
in a negative value that would cause memory corruption.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/ttpci/av7110_ca.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb/ttpci/av7110_ca.c
+++ b/drivers/media/dvb/ttpci/av7110_ca.c
@@ -277,7 +277,7 @@ static int dvb_ca_ioctl(struct inode *in
 	{
 		ca_slot_info_t *info=(ca_slot_info_t *)parg;
 
-		if (info->num > 1)
+		if (info->num < 0 || info->num > 1)
 			return -EINVAL;
 		av7110->ci_slot[info->num].num = info->num;
 		av7110->ci_slot[info->num].type = FW_CI_LL_SUPPORT(av7110->arm_app) ?


