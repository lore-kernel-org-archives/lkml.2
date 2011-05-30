Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab1E3PQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 11:16:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35885 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab1E3PQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 11:16:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NEgiKVvkkdjgs/pkmXReJBTk32UqeB5TdN2tct8wleg486wu0cH8Cywhs+inDWah4K
         ze0xQr9UdLtG4jcnxmtgCoX/CGyuTOaa7shqAT8j859Honug6OBb8xYuYOKsZhZxDQuu
         eaMoM0z+5eSJp2phJC86rcSENQO4Pg0VxMNJ0=
From: David Ahern <dsahern@gmail.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf script: fix display of IP address for non-callchain path
Date: Mon, 30 May 2011 09:16:27 -0600
Message-Id: <1306768587-15376-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non-callchain path is using al.addr which prints as:
  openssl 14564 17672.003587:       7862d _x86_64_AES_encrypt_compact

This should be sample->ip to print as:
  openssl 14564 17672.003587:  3f7867862d _x86_64_AES_encrypt_compact

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/session.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index e6cf0e2..360d8c4 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1247,7 +1247,7 @@ void perf_session__print_ip(union perf_event *event,
 		}
 
 	} else {
-		printf("%16" PRIx64, al.addr);
+		printf("%16" PRIx64, sample->ip);
 		if (print_sym) {
 			if (al.sym && al.sym->name)
 				symname = al.sym->name;
-- 
1.7.5.2

