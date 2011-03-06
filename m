Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab1CFOtl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 09:49:41 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:42685 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1CFOtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 09:49:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:reply-to:mime-version:content-type
         :content-disposition:user-agent;
        b=Oj9VaOBkXS380nk9ZuvJGNeMek1q+1KCVIzBrLnAXgqeXwSpkNpa7CD9mZJmpJdMxm
         eOSTNUyjRLNhP1srTeW8pQEFXIk95fkyl4bZxJY9BRcCt2PRuD4alzUvCWDa1pLqhuy6
         GwqAQIMljzKYtQVH8f7XTp3PB/7oRcJLoNLxY=
Date: Sun, 6 Mar 2011 22:53:21 +0800
From: Xiaochen Wang <wangxiaochen0@gmail.com>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] check _malloc return value in rtl8712
Message-ID: <20110306145321.GA20485@chii>
Reply-To: Xiaochen Wang <wangxiaochen0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Description: The original check is wrong.

Signed-off-by: Xiaochen Wang <wangxiaochen0@gmail.com>
---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index 685a7b1..51fef02 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -953,7 +953,7 @@ static int r871x_wx_set_priv(struct net_device *dev,
 
 	len = dwrq->length;
 	ext = _malloc(len);
-	if (!_malloc(len))
+	if (!ext)
 		return -ENOMEM;
 	if (copy_from_user(ext, dwrq->pointer, len)) {
 		kfree(ext);
-- 
1.7.2.3

