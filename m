Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab2BEWec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:34:32 -0500
Received: from 1wt.eu ([62.212.114.60]:62116 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333Ab2BEW1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:27:00 -0500
Message-Id: <20120205220953.045255935@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:11:13 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ludwig Nussel <ludwig.nussel@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        harvey.harrison@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 84/91] x86: Fix mmap random address range
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 2 insertions(+), 2 deletions(-)

Index: longterm-2.6.27/arch/x86/mm/mmap.c
===================================================================
--- longterm-2.6.27.orig/arch/x86/mm/mmap.c	2012-02-05 22:34:32.437915058 +0100
+++ longterm-2.6.27/arch/x86/mm/mmap.c	2012-02-05 22:34:46.864914382 +0100
@@ -87,9 +87,9 @@
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


