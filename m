Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab0DNBNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 21:13:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab0DNBNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 21:13:47 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [REGRESSION PATCH] vsprintf: increase sizeof precision in printf_spec
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, fweisbec@gmail.com
Date: Tue, 13 Apr 2010 21:13:36 -0400
Message-ID: <20100414011336.16139.68030.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch ef0658f3de484bf9b173639cd47544584e01efa5 changed the precision field
from and int to an s8.  Problem is that we have code which uses a much larger
precision in the kernel.  An example would in the audit code where we have:

vsnprintf(...,..., " msg='%.1024s'", (char *)data);

which causes precision to be too large and end up truncating to nothing.
Raising the size of the precision fixes the audit system issue.  It also does
not affect the alignment of the struct according to pahole and is still
approprietely packed.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 lib/vsprintf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 24112e5..a957d3f 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -412,7 +412,7 @@ struct printf_spec {
 	s16	field_width;	/* width of output field */
 	u8	flags;		/* flags to number() */
 	u8	base;
-	s8	precision;	/* # of digits/chars */
+	s16	precision;	/* # of digits/chars */
 	u8	qualifier;
 };
 

