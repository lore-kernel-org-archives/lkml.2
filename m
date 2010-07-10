Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab0GJKIV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 06:08:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41743 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab0GJKIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 06:08:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=Unyc52o4+6RfFGJHMyrKb3Q9CdCVae2KU1fiUOn4QHwgrWlW2yHsSo5bYcGh11o339
         rceNGt1CWxKeT9U4SoAhqudhhCTs3OtA0UW+bRFBTgQF6uwP5gPpIxZs4aJTrI6bSpeR
         GWN1csyBDhQJdRR6ZsdYqKP9hY7nw5b6Gf364=
Date: Sat, 10 Jul 2010 12:06:44 +0200
From: Dan Carpenter <error27@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] trace: strlen() return doesn't account for the NULL
Message-ID: <20100710100644.GV19184@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to add one to the strlen() return because of the NULL
character.  The type->name here generally comes from the kernel and I
don't think any of them come close to being MAX_TRACER_SIZE (100)
characters long so this is basically a cleanup.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 086d363..5f13c35 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -729,7 +729,7 @@ __acquires(kernel_lock)
 		return -1;
 	}
 
-	if (strlen(type->name) > MAX_TRACER_SIZE) {
+	if (strlen(type->name) >= MAX_TRACER_SIZE) {
 		pr_info("Tracer has a name longer than %d\n", MAX_TRACER_SIZE);
 		return -1;
 	}
