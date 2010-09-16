Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab0IPEmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 00:42:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37650 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab0IPEmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 00:42:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=agy+PvRUALR/tH/PszzEOPcAg5qEBWVZDUzuWYtFzZc8JaK+h/xeHqUQx4gm4mGAcU
         5tEej7sBs8Y3zdyFDuxI32+NNMZnuscDLoaNMxZndPNhJSKy8PRciJiAhxEPStQdAXYU
         lfPoA/I1fRc9yKRvz9arjT/c5nZfJoCqrvpb8=
MIME-Version: 1.0
Date: Thu, 16 Sep 2010 12:42:17 +0800
Message-ID: <AANLkTi=K1xnqt5MAX2uAr+h7t9Hv4e8kaHOn-K_mRjCa@mail.gmail.com>
Subject: [PATCH] perf: fix exit usage
From: jovi zhang <bookjovi@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o8G4gXul027445

unify some exit code(using -1), and fix one bug(not exit when fork
error in builtin-stat.c).

Signed-off-by: jovi zhang <bookjovi@gmail.com>
tools/perf/builtin-stat.c |    7 +++++--
tools/perf/builtin-top.c  |    6 +++---
tools/perf/perf.c         |    4 ++--
3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a6b4d44..fe3e044 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -285,12 +285,15 @@ static int run_perf_stat(int argc __used, const
char **argv)

       if (forks && (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
               perror("failed to create pipes");
-               exit(1);
+               exit(-1);
       }

       if (forks) {
-               if ((child_pid = fork()) < 0)
+               child_pid = fork();
+               if (child_pid < 0) {
                       perror("failed to fork");
+                       exit(-1);
+               }

               if (!child_pid) {
                       close(child_ready_pipe[0]);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b513e40..d0e646c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1047,7 +1047,7 @@ static void event__process_sample(const event_t *self,
                   RB_EMPTY_ROOT(&al.map->dso->symbols[MAP__FUNCTION])) {
                       pr_err("The %s file can't be used\n",
                              symbol_conf.vmlinux_name);
-                       exit(1);
+                       exit(-1);
               }

               return;
@@ -1066,7 +1066,7 @@ static void event__process_sample(const event_t *self,
                               machine__fprintf_vmlinux_path(machine, stderr);
                       } else
                               pr_err(".\n");
-                       exit(1);
+                       exit(-1);
               }
       }

@@ -1439,7 +1439,7 @@ int cmd_top(int argc, const char **argv, const
char *prefix __used)
               default_interval = freq;
       } else {
               fprintf(stderr, "frequency and count are zero, aborting\n");
-               exit(EXIT_FAILURE);
+               exit(-1);
       }

       /*
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index cdd6c03..2d4601f 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -468,7 +468,7 @@ int main(int argc, const char **argv)
               printf("\n usage: %s\n\n", perf_usage_string);
               list_common_cmds_help();
               printf("\n %s\n\n", perf_more_info_string);
-               exit(1);
+               exit(-1);
       }
       cmd = argv[0];

@@ -492,7 +492,7 @@ int main(int argc, const char **argv)
                       fprintf(stderr, "Expansion of alias '%s' failed; "
                               "'%s' is not a perf-command\n",
                               cmd, argv[0]);
-                       exit(1);
+                       exit(-1);
               }
               if (!done_help) {
                       cmd = argv[0] = help_unknown_cmd(cmd);
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
