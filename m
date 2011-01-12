Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab1ALK61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 05:58:27 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:39816 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab1ALK60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 05:58:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=i8Vk8E0SghiruScQH2+2YghEGyYat06g8HXG77RxLq4GKxtsOTzit5sfcr5sOpxYC0
         pMttgihSIqdvA23NWYWAgicPncRh7318A+zIc2zaJ8cDNcPaGaBlOOmq5qTEVfoFLDJX
         n9hE98U/CzZvuV0MZ6pyo5sQHAXo29QwPrnUc=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Davide Libenzi <davidel@xmailserver.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] epoll: remove unnecessary bit operation in epoll_create1 syscall
Date: Wed, 12 Jan 2011 19:58:16 +0900
Message-Id: <1294829896-3210-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.4.600.g982838b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@flags can have O_CLOEXEC only so bitwise AND is not necessary.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/eventpoll.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 8cf07242067d..2e21fb85b8b6 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1209,7 +1209,7 @@ SYSCALL_DEFINE1(epoll_create1, int, flags)
 	 * a file structure and a free file descriptor.
 	 */
 	error = anon_inode_getfd("[eventpoll]", &eventpoll_fops, ep,
-				 O_RDWR | (flags & O_CLOEXEC));
+				 O_RDWR | flags);
 	if (error < 0)
 		ep_free(ep);
 
-- 
1.7.3.4.600.g982838b0

