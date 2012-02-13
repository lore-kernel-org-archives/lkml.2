Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab2BMSCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:02:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63677 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472Ab2BMSCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:02:49 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=eSfxnIkts4oA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=b8VgSBC0AAAA:8 a=nE_x1U7TGn8nXCXWI2QA:9 a=vlM-zp3Osn6qgXzsRZIA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329156168.25686.9.camel@gandalf.stny.rr.com>
Subject: Re: [PATCHv8 0/8] ftrace, perf: Adding support to use function trace
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Mon, 13 Feb 2012 13:02:48 -0500
In-Reply-To: <1328643899-8361-1-git-send-email-jolsa@redhat.com>
References: <1327776209-4883-1-git-send-email-jolsa@redhat.com>
	 <1328643899-8361-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 20:44 +0100, Jiri Olsa wrote:
> hi,
> here's another version of perf support for function trace
> with filter. 
> 
> attached patches:
>  - 1/8 ftrace: Change filter/notrace set functions to return exit code
>  - 2/8 ftrace: Add enable/disable ftrace_ops control interface
>  - 3/8 ftrace, perf: Add open/close tracepoint perf registration actions
>  - 4/8 ftrace, perf: Add add/del tracepoint perf registration actions
>  - 5/8 ftrace: Add FTRACE_ENTRY_REG macro to allow event registration
>  - 6/8 ftrace, perf: Add support to use function tracepoint in perf
>  - 7/8 ftrace: Allow to specify filter field type for ftrace events
>  - 8/8 ftrace, perf: Add filter support for function trace event

OK, these break on a lot of configs.

Make sure they build with the following before sending another series.
I'll give you some of the fixes I added already.

Please test: allnoconfig, allmodconfig

http://rostedt.homelinux.com/private/configs/config-ftrace-patchcheck
http://rostedt.homelinux.com/private/configs/config-ftrace-static-patchcheck
http://rostedt.homelinux.com/private/configs/config-nofunc-patchcheck
http://rostedt.homelinux.com/private/configs/config-notrace-patchcheck

Thanks!

-- Steve

Note, These need to be defines and not static inlines, because
ftrace_ops is not defined in some cases.


diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 76f6c49..d984c08 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -381,9 +381,6 @@ extern void ftrace_enable_daemon(void);
 #else
 static inline int skip_trace(unsigned long ip) { return 0; }
 static inline int ftrace_force_update(void) { return 0; }
-static inline void ftrace_set_filter(unsigned char *buf, int len, int reset)
-{
-}
 static inline void ftrace_disable_daemon(void) { }
 static inline void ftrace_enable_daemon(void) { }
 static inline void ftrace_release_mod(struct module *mod) {}
@@ -407,6 +404,9 @@ static inline int ftrace_text_reserved(void *start, void *end)
  */
 #define ftrace_regex_open(ops, flag, inod, file) ({ -ENODEV; })
 #define ftrace_set_early_filter(ops, buf, enable) do { } while (0)
+#define ftrace_free_filter(ops) do { } while (0)
+#define ftrace_set_filter(ops, buf, len, reset) ({ -ENODEV; })
+#define ftrace_set_notrace(ops, buf, len, reset) ({ -ENODEV; })
 
 static inline ssize_t ftrace_filter_write(struct file *file, const char __user *ubuf,
 			    size_t cnt, loff_t *ppos) { return -ENODEV; }



