Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab1KEAbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 20:31:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36892 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1KEAbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 20:31:37 -0400
X-Authority-Analysis: v=2.0 cv=KcRQQHkD c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=v0XOpcnf7GoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=cx0W37uJPDm0jXF0RoYA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320453094.26400.0.camel@gandalf.stny.rr.com>
Subject: Re: WARNING at __ftrace_hash_rec_update()
From: Steven Rostedt <rostedt@goodmis.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 04 Nov 2011 20:31:34 -0400
In-Reply-To: <20111101141420.GA4918@debian>
References: <20111101141420.GA4918@debian>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-01 at 19:45 +0530, Rabin Vincent wrote:
> On v3.1-7810-g094803e (current linus git), I'm able to trigger the below
> FTRACE_WARN_ON() by running the following sequence of commands.
> DYNAMIC_FTRACE is enabled.
> 
> ftrace.c:1384:
> 	if (FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
> 		return;
> 	rec->flags--;
> 

Thanks for reporting. Can you try this patch please.

-- Steve


diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0fcc6ca..9af2ea6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1210,7 +1210,8 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	if (!src->count) {
 		free_ftrace_hash_rcu(*dst);
 		rcu_assign_pointer(*dst, EMPTY_HASH);
-		return 0;
+		/* still need to update the function records */
+		goto out;
 	}
 
 	/*


