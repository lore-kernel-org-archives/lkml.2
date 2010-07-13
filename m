Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab0GMSvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 14:51:43 -0400
Received: from relay3.sgi.com ([192.48.152.1]:37782 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752364Ab0GMSvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 14:51:42 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kdb: ll command won't terminate
Cc: jason.wessel@windriver.com, cpw@sgi.com
Message-Id: <E1OYkaV-0006KK-2k@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Tue, 13 Jul 2010 13:52:15 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Hi Jason,

A question, please, about a patch similar to the below that Martin Hicks
sent, around 5/26/2010.

Martin is on vacation, and suse is wondering whether the below change
is queued for 2.6.35.  I can't find anything about it.  Could you tell me
its status?

Thanks.

-Cliff


Signed-off-by: Martin Hicks <mort@sgi.com>
---
 kernel/debug/kdb/kdb_main.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/kernel/debug/kdb/kdb_main.c
===================================================================
--- linux-2.6.orig/kernel/debug/kdb/kdb_main.c
+++ linux-2.6/kernel/debug/kdb/kdb_main.c
@@ -2291,6 +2291,9 @@ static int kdb_ll(int argc, const char *
 	while (va) {
 		char buf[80];
 
+		if (KDB_FLAG(CMD_INTERRUPT))
+			return 0;
+
 		sprintf(buf, "%s " kdb_machreg_fmt "\n", command, va);
 		diag = kdb_parse(buf);
 		if (diag)
