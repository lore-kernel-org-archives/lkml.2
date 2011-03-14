Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1CNChz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 22:37:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59280 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab1CNChy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 22:37:54 -0400
Message-ID: <4D7D7FE6.1090202@cn.fujitsu.com>
Date: Mon, 14 Mar 2011 10:39:34 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3 V2]trace-cmd: remove dead code
References: <4D78A0A4.1040001@cn.fujitsu.com> <1299768818.15854.343.camel@gandalf.stny.rr.com>
In-Reply-To: <1299768818.15854.343.camel@gandalf.stny.rr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-14 10:36:34,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-14 10:36:34,
	Serialize complete at 2011-03-14 10:36:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


filter_cpu related code is totally dead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 trace-read.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/trace-read.c b/trace-read.c
index 0e9ced8..88b576f 100644
--- a/trace-read.c
+++ b/trace-read.c
@@ -73,7 +73,6 @@ static const char *input_file;
 static int multi_inputs;
 static int max_file_size;
 
-static int filter_cpu = -1;
 static int *filter_cpus;
 static int nr_filter_cpus;
 
@@ -601,7 +600,7 @@ get_next_record(struct handle_list *handles, int *next_cpu)
 	do {
 		next = -1;
 		ts = 0;
-		if (filter_cpus) {
+		if (nr_filter_cpus > 1) {
 			unsigned long long last_stamp = 0;
 			struct record *precord;
 			int next_cpu = -1;
@@ -619,9 +618,8 @@ get_next_record(struct handle_list *handles, int *next_cpu)
 				record = tracecmd_read_data(handles->handle, next_cpu);
 			else
 				record = NULL;
-
-		} else if (filter_cpu >= 0) {
-			cpu = filter_cpu;
+               } else if (nr_filter_cpus == 1) {
+			cpu = filter_cpus[0];
 			record = tracecmd_read_data(handles->handle, cpu);
 		} else
 			record = tracecmd_read_next_data(handles->handle, &cpu);
@@ -963,10 +961,7 @@ void trace_report (int argc, char **argv)
 		case 0:
 			switch(option_index) {
 			case 0: /* cpu */
-				if (filter_cpu)
-					add_cpu(optarg);
-				else
-					filter_cpu = atoi(optarg);
+				add_cpu(optarg);
 				break;
 			case 1: /* events */
 				print_events = 1;
-- 
1.7.4
