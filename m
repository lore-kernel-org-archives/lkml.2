Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937651Ab0CPJ5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:57:24 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:64697 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937619Ab0CPJ5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:57:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=StVozxHgvjeeEfM3lsoonhNnAUo8MyDASQ0d1jSLhsTwWegxblF039l+mssXrNqrl8
         04E5Ga7CwyITAffdyCwBdRvCVSAv5coPa5892iJfiuQB8TZwTi7uiZUCkrBB5berjUAe
         YNHg4hHaNXGvYfAv7dn5pDbeJv7DWD56RWLxI=
From: =?UTF-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org,
       =?UTF-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
Subject: [PATCH] perf: install into /usr/local by default.
Date: Tue, 16 Mar 2010 11:57:15 +0200
Message-Id: <1268733435-30225-1-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <4B9F3EEC.7050104@gmail.com>
References: <4B9F3EEC.7050104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was confusing to install into $(HOME)/bin, especially since there was
no documentation mentioning where perf gets installed by default.
So install to /usr/local by default, as other programs do, and allow users to
override the install location by specifying the prefix explicitly.

Signed-off-by: Török Edwin <edwintorok@gmail.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2e7fa3a..8e8c199 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -216,7 +216,7 @@ STRIP ?= strip
 # runtime figures out where they are based on the path to the executable.
 # This can help installing the suite in a relocatable way.
 
-prefix = $(HOME)
+prefix = /usr/local
 bindir_relative = bin
 bindir = $(prefix)/$(bindir_relative)
 mandir = share/man
-- 
1.7.0

