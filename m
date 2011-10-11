Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab1JKO5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 10:57:49 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:42343 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab1JKO5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 10:57:48 -0400
X-Greylist: delayed 1584 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Oct 2011 10:57:48 EDT
Date: Tue, 11 Oct 2011 14:30:52 +0000 (UTC)
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove "#ifdef linux" from linux/a.out.h
Message-ID: <Pine.LNX.4.64.1110111429060.30672@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 11 Oct 2011 14:30:54.0232 (UTC) FILETIME=[620F0980:01CC8822]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The <linux/a.out.h> header contains "#ifdef linux".  GCC's fixincludes
then creates its own copy of the installed header with this changed to
"#ifdef __linux__".  There should be no need for "#ifdef linux" in
Linux kernel headers, so this patch removes the conditional.

Signed-off-by: Joseph Myers <joseph@codesourcery.com>
---
Previous submission: http://lkml.org/lkml/2006/10/6/201
--- linux-3.0/include/linux/a.out.h.orig	2011-08-04 21:59:21.000000000 -0700
+++ linux-3.0/include/linux/a.out.h	2011-10-11 07:21:33.775483226 -0700
@@ -129,7 +129,6 @@ enum machine_type {
 #define SEGMENT_SIZE PAGE_SIZE
 #endif
 
-#ifdef linux
 #ifdef __KERNEL__
 #include <asm/page.h>
 #else
@@ -146,7 +145,6 @@ enum machine_type {
 #endif
 #endif
 #endif
-#endif
 
 #define _N_SEGMENT_ROUND(x) ALIGN(x, SEGMENT_SIZE)
 

-- 
Joseph S. Myers
joseph@codesourcery.com
