Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab0CTOjW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:39:22 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47803 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab0CTOjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:39:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Uvt6tnn88A3/ap/rBW7lGLa3RD1u9bnPkzPF7aDe+NnQHm1aT6wDe+d7z7kXHkKc9p
         1Z1SfHPI6NxRvwbaZZ7RNKyGaKW2L1ZfM+QcmcNrFXy/ClaDQD4vs79bo7MDdQY5Qzoh
         16WwAWE93FMUYDuYOKZIZOPvGfFjkuV3jrdHM=
Date: Sat, 20 Mar 2010 17:39:11 +0300
From: Dan Carpenter <error27@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] trace: find the correct ftrace event
Message-ID: <20100320143911.GF5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20100320131923.GA20922@bicker> <1269092233.28658.9.camel@localhost> <20100320135604.GA28881@bicker> <1269094036.28658.12.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269094036.28658.12.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original code doesn't work because "call" is never NULL there.                                                           
                                                                                                                             
Signed-off-by: Dan Carpenter <error27@gmail.com>                                                                             
---
The original patch was fine, but this version is more tasteful.  ;)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 4615f62..c1a263a 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1397,7 +1397,7 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 	}
 
 	err = -EINVAL;
-	if (!call)
+	if (&call->list == &ftrace_events)
 		goto out_unlock;
 
 	err = -EEXIST;
