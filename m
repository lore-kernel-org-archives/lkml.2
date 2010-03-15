Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936670Ab0COTuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:50:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936626Ab0COTul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:50:41 -0400
Date: Mon, 15 Mar 2010 20:49:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org,
       David Howells <dhowells@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>
Subject: [PATCH 6/6] call_usermodehelper: UMH_WAIT_EXEC ignores
	kernel_thread() failure
Message-ID: <20100315194911.GG10896@redhat.com>
References: <20100315122908.GB16175@hmsreliant.think-freely.org> <20100315194609.GA10896@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315194609.GA10896@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UMH_WAIT_EXEC should report the error if kernel_thread() fails, like
UMH_WAIT_PROC does.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/kmod.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 34-rc1/kernel/kmod.c~6_UMH_WAIT_EXEC	2010-03-15 20:32:23.000000000 +0100
+++ 34-rc1/kernel/kmod.c	2010-03-15 20:37:07.000000000 +0100
@@ -235,10 +235,10 @@ static void __call_usermodehelper(struct
 	case UMH_WAIT_PROC:
 		if (pid > 0)
 			break;
-		sub_info->retval = pid;
 		/* FALLTHROUGH */
-
 	case UMH_WAIT_EXEC:
+		if (pid < 0)
+			sub_info->retval = pid;
 		complete(sub_info->complete);
 	}
 }

