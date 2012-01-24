Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab2AXCom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:44:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807Ab2AXCoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:44:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:28 2012
Message-Id: <20120124023928.432983236@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ludwig Nussel <ludwig.nussel@suse.de>,
        harvey.harrison@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [051/129] x86: Fix mmap random address range
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1325
Lines: 41

From: Ludwig Nussel <ludwig.nussel@suse.de>

commit 9af0c7a6fa860698d080481f24a342ba74b68982 upstream.

On x86_32 casting the unsigned int result of get_random_int() to
long may result in a negative value.  On x86_32 the range of
mmap_rnd() therefore was -255 to 255.  The 32bit mode on x86_64
used 0 to 255 as intended.

The bug was introduced by 675a081 ("x86: unify mmap_{32|64}.c")
in January 2008.

Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: harvey.harrison@gmail.com
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/201111152246.pAFMklOB028527@wpaz5.hot.corp.google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -75,9 +75,9 @@ static unsigned long mmap_rnd(void)
 	*/
 	if (current->flags & PF_RANDOMIZE) {
 		if (mmap_is_ia32())
-			rnd = (long)get_random_int() % (1<<8);
+			rnd = get_random_int() % (1<<8);
 		else
-			rnd = (long)(get_random_int() % (1<<28));
+			rnd = get_random_int() % (1<<28);
 	}
 	return rnd << PAGE_SHIFT;
 }


