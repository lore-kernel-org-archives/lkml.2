Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab0GASXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:23:20 -0400
Received: from kroah.org ([198.145.64.141]:40448 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757790Ab0GASXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:18 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:11 2010
Message-Id: <20100701173211.447760155@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:31:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Denis Kirjanov <dkirjanov@kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [patch 055/149] powerpc/oprofile: fix potential buffer overrun in op_model_cell.c
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Denis Kirjanov <dkirjanov@hera.kernel.org>

commit 238c1a78c957f3dc7cb848b161dcf4805793ed56 upstream.

Fix potential initial_lfsr buffer overrun.
Writing past the end of the buffer could happen when index == ENTRIES

Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/oprofile/op_model_cell.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -1077,7 +1077,7 @@ static int calculate_lfsr(int n)
 		index = ENTRIES-1;
 
 	/* make sure index is valid */
-	if ((index > ENTRIES) || (index < 0))
+	if ((index >= ENTRIES) || (index < 0))
 		index = ENTRIES-1;
 
 	return initial_lfsr[index];


