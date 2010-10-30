Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab0J3Tde (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 15:33:34 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10097 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab0J3Tdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 15:33:32 -0400
Date: Sat, 30 Oct 2010 21:23:14 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Peter Oruba <peter.oruba@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        amd64-microcode@amd64.org
Subject: [PATCH] AMD Microcode: Prefer vzalloc() over calls to
 vmalloc()+memset()
Message-ID: <alpine.LNX.2.00.1010302118160.1572@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We don't have to do memset() ourselves after vmalloc() when we have 
vzalloc(), so change that in 
arch/x86/kernel/microcode_amd.c::get_next_ucode().

Please CC me on replies.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
compile tested only.

 microcode_amd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index e1af7c0..d46e805 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -183,9 +183,8 @@ get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 		return NULL;
 	}
 
-	mc = vmalloc(UCODE_MAX_SIZE);
+	mc = vzalloc(UCODE_MAX_SIZE);
 	if (mc) {
-		memset(mc, 0, UCODE_MAX_SIZE);
 		if (get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR,
 				   total_size)) {
 			vfree(mc);


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

