Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab2DWQ3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:29:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55831 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab2DWQ3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:29:35 -0400
Subject: Patch "Perf: fix build breakage" has been added to the 3.0-stable tree
To: zeev.tarantov@gmail.com, acme@redhat.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 23 Apr 2012 09:29:32 -0700
In-Reply-To: <20120423063704.GA3465@myhost>
Message-ID: <1335198572696@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Perf: fix build breakage

to the 3.0-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     perf-fix-build-breakage.patch
and it can be found in the queue-3.0 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From zeev.tarantov@gmail.com Sun Apr 22 23:38:36 2012
From: Zeev Tarantov <zeev.tarantov@gmail.com>
Date: Mon, 23 Apr 2012 09:37:04 +0300
Subject: Perf: fix build breakage
To: "David S. Miller" <davem@davemloft.net>, Arnaldo Carvalho de Melo <acme@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20120423063704.GA3465@myhost>
Content-Disposition: inline


From: Zeev Tarantov <zeev.tarantov@gmail.com>

[Patch not needed upstream as this is a backport build bugfix - gregkh

gcc correctly complains:

util/hist.c: In function ‘__hists__add_entry’:
util/hist.c:240:27: error: invalid type argument of ‘->’ (have ‘struct hist_entry’)
util/hist.c:241:23: error: invalid type argument of ‘->’ (have ‘struct hist_entry’)

for this new code:

+                       if (he->ms.map != entry->ms.map) {
+                               he->ms.map = entry->ms.map;
+                               if (he->ms.map)
+                                       he->ms.map->referenced = true;
+                       }

because "entry" is a "struct hist_entry", not a pointer to a struct.

In mainline, "entry" is a pointer to struct passed as argument to the function.
So this is broken during backporting. But obviously not compile tested.

Signed-off-by: Zeev Tarantov <zeev.tarantov@gmail.com>
Cc: Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/hist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -165,8 +165,8 @@ struct hist_entry *__hists__add_entry(st
 			 * mis-adjust symbol addresses when computing
 			 * the history counter to increment.
 			 */
-			if (he->ms.map != entry->ms.map) {
-				he->ms.map = entry->ms.map;
+			if (he->ms.map != entry.ms.map) {
+				he->ms.map = entry.ms.map;
 				if (he->ms.map)
 					he->ms.map->referenced = true;
 			}


Patches currently in stable-queue which might be from zeev.tarantov@gmail.com are

queue-3.0/perf-fix-build-breakage.patch
