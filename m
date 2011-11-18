Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1KRXqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:46:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53553 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1KRXqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:46:08 -0500
Date: Fri, 18 Nov 2011 15:45:57 -0800
From: "tip-bot for Luck, Tony" <tony.luck@intel.com>
Message-ID: <tip-0d2f096b8785b67c38afcf6e1fbb9674af2e05ca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tony.luck@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, tony.luck@intel.com, hpa@linux.intel.com
In-Reply-To: <4ec4061010261a4cb0@agluck-desktop.sc.intel.com>
References: <4ec4061010261a4cb0@agluck-desktop.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] random: Fix handing of arch_get_random_long in get_random_bytes()
Git-Commit-ID: 0d2f096b8785b67c38afcf6e1fbb9674af2e05ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:46:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d2f096b8785b67c38afcf6e1fbb9674af2e05ca
Gitweb:     http://git.kernel.org/tip/0d2f096b8785b67c38afcf6e1fbb9674af2e05ca
Author:     Luck, Tony <tony.luck@intel.com>
AuthorDate: Wed, 16 Nov 2011 10:50:56 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 16 Nov 2011 16:41:02 -0800

random: Fix handing of arch_get_random_long in get_random_bytes()

If there is an architecture-specific random number generator we use
it to acquire randomness one "long" at a time. We should put these
random words into consecutive words in the result buffer - not just
overwrite the first word again and again.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/4ec4061010261a4cb0@agluck-desktop.sc.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/char/random.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 63e19ba..6035ab8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -941,7 +941,7 @@ void get_random_bytes(void *buf, int nbytes)
 		if (!arch_get_random_long(&v))
 			break;
 		
-		memcpy(buf, &v, chunk);
+		memcpy(p, &v, chunk);
 		p += chunk;
 		nbytes -= chunk;
 	}
