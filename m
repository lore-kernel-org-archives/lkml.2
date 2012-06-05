Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2FEWzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 18:55:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56570 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2FEWzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 18:55:05 -0400
Message-ID: <1338936900.1157.3.camel@mop>
Subject: Re: [PATCH 0/8] Rework KERN_<LEVEL>
From: Kay Sievers <kay@vrfy.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        alsa-devel@alsa-project.org, Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 06 Jun 2012 00:55:00 +0200
In-Reply-To: <20120605142826.d92316a0.akpm@linux-foundation.org>
References: <cover.1338889066.git.joe@perches.com>
	 <20120605142826.d92316a0.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.5.2 (3.5.2-1.fc18)
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 14:28 -0700, Andrew Morton wrote:

> devkmsg_writev() does weird and wonderful things with
> facilities/levels.  That function incorrectly returns "success" when
> copy_from_user() faults, btw.

Oh. Better?

Thanks,
Kay


From: Kay Sievers <kay@vrfy.org>
Subject: kmsg: /dev/kmsg - properly return possible copy_from_user() failure

Reported-By: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kay Sievers <kay@vrfy.org
---
 printk.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 32462d2..6bdacab 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -365,8 +365,10 @@ static ssize_t devkmsg_writev(struct kiocb *iocb, const struct iovec *iv,
 
 	line = buf;
 	for (i = 0; i < count; i++) {
-		if (copy_from_user(line, iv[i].iov_base, iv[i].iov_len))
+		if (copy_from_user(line, iv[i].iov_base, iv[i].iov_len)) {
+			ret = -EFAULT;
 			goto out;
+		}
 		line += iv[i].iov_len;
 	}
 


