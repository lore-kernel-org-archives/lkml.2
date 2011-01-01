Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab1AAPt1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 10:49:27 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50221 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1AAPt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 10:49:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=TcDC2DK5IiBGN6mxe4aQO98JsBmc/5Bs/prNIJox9iBFlUn0IRrydPs6MRyGQ8fE/m
         Zepanmuxpjaddr455mtLBiT4G+AwwZl/bdvJQXXC9upZvgyh4hKUupKQ7TSN7E6XsVIY
         a4fKuaCNbz7fJVLXhh/7mYFUjCrTj6mvxh++0=
Message-ID: <4D1F4D02.5080800@gmail.com>
Date: Sat, 01 Jan 2011 16:49:22 +0100
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, w.d.hubbs@gmail.com
Subject: [PATCH] speakup: &&/|| confusion in silent_store()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix test: the branch is always taken.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/staging/speakup/kobjects.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/speakup/kobjects.c b/drivers/staging/speakup/kobjects.c
index cc79f9e..a082f8d 100644
--- a/drivers/staging/speakup/kobjects.c
+++ b/drivers/staging/speakup/kobjects.c
@@ -332,7 +332,7 @@ static ssize_t silent_store(struct kobject *kobj, struct kobj_attribute *attr,
 	unsigned long flags;
 
 	len = strlen(buf);
-	if (len > 0 || len < 3) {
+	if (len > 0 && len < 3) {
 		ch = buf[0];
 		if (ch == '\n')
 			ch = '0';
