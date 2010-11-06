Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab0KFIrd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 04:47:33 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50769 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab0KFIr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 04:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=uPw8ZCcjXAkykjydemaa5D7P/4MmFMWNG+1zCRtz0AWLJZQ/lWywc/qh84YlYN7VwI
         xAfV+cyhsgWDlAQoKLDGiiX8Gck76pz237+GoJcSN05R81yzJra7zYpkM82UGyxMefNQ
         +RDb/27sw7X5k8xsYx2h5+vbZf8a+xgBFxApw=
Date: Sat, 6 Nov 2010 11:47:24 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] perf, ui: Eliminate stack-smashing protection compiler
	complain
Message-ID: <20101106084724.GA5956@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The gcc complains on Yes, No being allocated from stack space. Make
them conts to feel compiler happy.

 |    CC util/ui/util.o
 | cc1: warnings being treated as errors
 | util/ui/util.c: In function ‘ui__dialog_yesno’:
 | util/ui/util.c:108: error: not protecting function: no buffer at least 8 bytes long
 | make: *** [util/ui/util.o] Error 1

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Frédéric Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
---

Since it seems only me who has such error I presume ssp-buffer-size=8 set
for mine local version of gcc (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4))

 tools/perf/util/ui/util.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.git/tools/perf/util/ui/util.c
=====================================================================
--- linux-2.6.git.orig/tools/perf/util/ui/util.c
+++ linux-2.6.git/tools/perf/util/ui/util.c
@@ -104,9 +104,10 @@ out_destroy_form:
 	return rc;
 }
 
+static const char yes[] = "Yes", no[] = "No";
+
 bool ui__dialog_yesno(const char *msg)
 {
 	/* newtWinChoice should really be accepting const char pointers... */
-	char yes[] = "Yes", no[] = "No";
-	return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
+	return newtWinChoice(NULL, (char *)yes, (char *)no, (char *)msg) == 1;
 }
