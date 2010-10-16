Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab0JPPr3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 11:47:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50732 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab0JPPr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 11:47:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jzC/5jZLb1Guk36qjofoM47Y2TQP1yn1fX8pc547UoRJcVjsWcWb016edqeaehBIGV
         NWpEgjPfIWX0skGXAnjtqxWoOCD/SRIyPdnRI8hJJR4LLQVWuOITafSND9FlGucYnau7
         A03ECtw88lRZhZqzTQZcucYCuxWsFoGr//pww=
Date: Sat, 16 Oct 2010 16:45:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Robin Holt <holt@sgi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: ftrace does not work on cpus > 999.
Message-ID: <20101016144529.GA5384@nowhere>
References: <20101016131505.GW14064@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016131505.GW14064@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 08:15:05AM -0500, Robin Holt wrote:
> Just started looking into using ftrace to identify a difficult to diagnose
> userland set of processes when I noticed that the .../trace/per_cpu
> directory only contains entries for cpus 0-999.  I have not looked at
> what else may not work.  For the cpus that are listed, I am able to grep
> trace buffer information so it is mostly working.
> 
> I will be away from email for most of today, but may get back to this
> tonight.  If there are any suggestions, I will happily give them a try.
> 
> Thanks,
> Robin


Oh!

Can you please try that?

Thanks.


diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9ec59f5..3565f9e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3999,7 +3999,7 @@ static void tracing_init_debugfs_percpu(long cpu)
 	/* strlen(cpu) + MAX(log10(cpu)) + '\0' */
 	char cpu_dir[7];
 
-	if (cpu > 999 || cpu < 0)
+	if (cpu < 0)
 		return;
 
 	sprintf(cpu_dir, "cpu%ld", cpu);


