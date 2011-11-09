Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab1KJDke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:40:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935984Ab1KJDk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:40:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:53 2011
Message-Id: <20111109213152.995364382@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [108/264] perf probe: Fix to show correct error string
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

commit 44a56040a0037a845d5fa218dffde464579f0cab upstream.

Fix perf probe to show correct error string when it
fails to delete an event. The write(2) returns -1
if failed, and errno stores real error number.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Link: http://lkml.kernel.org/r/20111004104504.14591.41266.stgit@fedora15
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 tools/perf/util/probe-event.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1956,8 +1956,10 @@ static int __del_trace_probe_event(int f
 
 	pr_debug("Writing event: %s\n", buf);
 	ret = write(fd, buf, strlen(buf));
-	if (ret < 0)
+	if (ret < 0) {
+		ret = -errno;
 		goto error;
+	}
 
 	printf("Remove event: %s\n", ent->s);
 	return 0;


