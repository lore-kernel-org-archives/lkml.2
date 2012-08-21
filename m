Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2HUXN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 19:13:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32527 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2HUXNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 19:13:23 -0400
X-Authority-Analysis: v=2.0 cv=cpwZYiEi c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=9Ov11F4PKAkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=6q7HoQCPHIYA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=v9sqg8J54hmLim10IC8A:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345590800.5069.17.camel@gandalf.local.home>
Subject: [PATCH] tools lib traceevent: Modify header to work in C++ programs
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 21 Aug 2012 19:13:20 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arnaldo,

As the libtraceevent library is also used by powertop, and that is
written in *cough* C++ *cough*, we need to make sure that the headers do
not have any C++ reserved words. Please apply this patch. Thanks.

-- Steve


Steven Rostedt (1):
      tools lib traceevent: Modify header to work in C++ programs

----
 tools/lib/traceevent/event-parse.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
---------------------------
commit 79f481dbd7cb14e33113180b74e09e742cd839f9
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Sat May 7 19:04:01 2011 -0400

tools lib traceevent: Modify header to work in C++ programs

Replace keyword "private" from event-parse.h to allow it to be
used in C++ programs.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 5772ad8..c28713b 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -49,7 +49,7 @@ struct pevent_record {
 	int			cpu;
 	int			ref_count;
 	int			locked;		/* Do not free, even if ref_count is zero */
-	void			*private;
+	void			*r_private;
 #if DEBUG_RECORD
 	struct pevent_record	*prev;
 	struct pevent_record	*next;
@@ -106,7 +106,7 @@ struct plugin_option {
 	char				*plugin_alias;
 	char				*description;
 	char				*value;
-	void				*private;
+	void				*p_private;
 	int				set;
 };
 


