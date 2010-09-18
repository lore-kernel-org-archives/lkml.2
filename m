Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab0IRTmJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:42:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39386 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab0IRTmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:42:06 -0400
Date: Sat, 18 Sep 2010 20:42:05 +0100
To: linux-arch@vger.kernel.org
Subject: [PATCH 4/5] frv: handling of restart into restart_syscall is
 fscked
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Ox3IT-0006RY-BV@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


syscall number is in gr7, not gr8...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/frv/kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index fa40d54..ad74e2e 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -547,7 +547,7 @@ no_signal:
 			break;
 
 		case -ERESTART_RESTARTBLOCK:
-			__frame->gr8 = __NR_restart_syscall;
+			__frame->gr7 = __NR_restart_syscall;
 			__frame->pc -= 4;
 			break;
 		}
-- 
1.5.6.5


