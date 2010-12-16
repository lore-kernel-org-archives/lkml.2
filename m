Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab0LPUc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:32:56 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:57428 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab0LPUcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:32:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Z4UHsuLVINPmWFObXLGugZ4cf0g8ItUdRlKJLzDuraWlPMzqFgn6v6+IddJaVHs0m2
         wnixBKs5C+eC5WmqH2ZKT/p6CzxoywY+mFM2OGtZ/ZnbzbPKxZZZUKdwebbYrkGE8GJO
         D1A5w4T5clOUzX2h33dLPtPQjygkPKbxJW4aA=
Date: Thu, 16 Dec 2010 22:32:17 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, davej@redhat.com
Subject: [PATCH] proc: warn if registering world writeable files
Message-ID: <20101216203217.GA3581@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/generic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -623,6 +623,7 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 	memcpy(((char *) ent) + sizeof(struct proc_dir_entry), fn, len + 1);
 	ent->name = ((char *) ent) + sizeof(*ent);
 	ent->namelen = len;
+	WARN_ON(S_ISREG(mode) && (mode & S_IWOTH));
 	ent->mode = mode;
 	ent->nlink = nlink;
 	atomic_set(&ent->count, 1);
