Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab0EIUoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 16:44:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53132 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab0EIUn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 16:43:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=ZDtMtl5KyCYltaJ/tXF/hyL2aZgnSvlSJi7o4eqeqAGNlaFaHmyx/ZM8SwKDqfLSNT
         cOZTijsfaM/nkd9lhgeN1orXvk2F4wp6gYqUmzSoviIFMsNf0ddpzXbMJZ5zMoH2M06h
         5b54iWa2zbTDuuhcUKe8WqQ1njbBfpUTRN7oM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 10/10] perf lock: Drop "-a" option from cmd_record() default arguments set
Date: Sun,  9 May 2010 22:43:38 +0200
Message-Id: <1273437818-8130-11-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
References: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>

This patch drops "-a" from the default arguments passed to
perf record by perf lock.

If a user wants to do a system wide record of lock events,
        perf lock record -a <program> <argument> ...
is enough for this purpose.

This can reduce the size of the perf.data file.

% sudo ./perf lock record whoami
root
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.439 MB perf.data (~19170 samples) ]
% sudo ./perf lock record -a whoami   # with -a option
root
[ perf record: Woken up 0 times to write data ]
[ perf record: Captured and wrote 48.962 MB perf.data (~2139197 samples) ]

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
LKML-Reference: Message-Id: <1273306229-5216-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-lock.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index e549f45..e18dfdc 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -930,7 +930,6 @@ static const struct option lock_options[] = {
 
 static const char *record_args[] = {
 	"record",
-	"-a",
 	"-R",
 	"-f",
 	"-m", "1024",
-- 
1.6.2.3

