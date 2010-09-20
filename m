Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab0ITONb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:13:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756592Ab0ITON3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:13:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/5] frv: handling of restart into restart_syscall is fscked
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>
Date: Mon, 20 Sep 2010 15:13:19 +0100
Message-ID: <20100920141319.11066.31722.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100920141304.11066.51314.stgit@warthog.procyon.org.uk>
References: <20100920141304.11066.51314.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>

do_signal() should place the syscall number in gr7, not gr8 when handling
ERESTART_WOULDBLOCK.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index 48203c6..bd13b57 100644
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

