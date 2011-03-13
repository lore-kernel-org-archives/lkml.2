Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab1CMWAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 18:00:31 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21498 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab1CMWAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 18:00:31 -0400
Date: Sun, 13 Mar 2011 23:00:09 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: x86@kernel.org
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH][rfc] Use int as return type of main in
 arch/x86/boot/main.c
Message-ID: <alpine.LNX.2.00.1103132257430.9985@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe the return type of main should always be 'int'.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
index 40358c8..4b80da8 100644
--- a/arch/x86/boot/main.c
+++ b/arch/x86/boot/main.c
@@ -125,7 +125,7 @@ static void init_heap(void)
 	}
 }
 
-void main(void)
+int main(void)
 {
 	/* First, copy the boot header into the "zeropage" */
 	copy_boot_params();
@@ -175,4 +175,6 @@ void main(void)
 
 	/* Do the last things and invoke protected mode */
 	go_to_protected_mode();
+
+	return 0;
 }


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

