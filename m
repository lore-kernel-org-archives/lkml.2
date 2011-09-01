Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab1IAXjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 19:39:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56483 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab1IAXjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 19:39:05 -0400
Message-ID: <4E601794.6080202@gmail.com>
Date: Fri, 02 Sep 2011 09:39:00 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Check maxlen on strnlen_user usage
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strnlen_user returns the length of the string including the nul 
terminator. In the case where maxlen is reached strnlen_user returns 
maxlen + 1. Most callsites already check for this condition. Fix the 
call to strnlen_user in fs/exec.c to check for the maxlen case.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
---

diff --git a/fs/exec.c b/fs/exec.c
index 25dcbe5..e19588c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -481,7 +481,7 @@ static int copy_strings(int argc, struct user_arg_ptr argv,
  			goto out;

  		len = strnlen_user(str, MAX_ARG_STRLEN);
-		if (!len)
+		if (!len || len>  MAX_ARG_STRLEN)
  			goto out;

  		ret = -E2BIG;

