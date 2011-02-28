Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab1B1QhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:37:05 -0500
Received: from kroah.org ([198.145.64.141]:41219 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809Ab1B1QhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:06 2011
Message-Id: <20110228162406.850946284@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [12/68] [media] [v3,media] av7110: check for negative array offset
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


