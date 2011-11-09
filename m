Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1KIHCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 02:02:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab1KIHCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 02:02:51 -0500
Date: Wed, 9 Nov 2011 15:04:52 +0800
From: Dave Young <dyoung@redhat.com>
To: ebiederm@xmission.com, vgoyal@redhat.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kdump: kill redundant code
Message-ID: <20111109070452.GA25768@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in while loop below, hole_end > crashk_res.end is impossible:
while (hole_end <= crashk_res.end) {
	[snip]
}
Killing the check code here

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 kernel/kexec.c |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.orig/kernel/kexec.c	2011-11-01 13:06:20.000000000 +0800
+++ linux-2.6/kernel/kexec.c	2011-11-09 14:57:17.487022644 +0800
@@ -500,8 +500,6 @@ static struct page *kimage_alloc_crash_c
 
 		if (hole_end > KEXEC_CRASH_CONTROL_MEMORY_LIMIT)
 			break;
-		if (hole_end > crashk_res.end)
-			break;
 		/* See if I overlap any of the segments */
 		for (i = 0; i < image->nr_segments; i++) {
 			unsigned long mstart, mend;
