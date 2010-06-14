Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab0FNOGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:06:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33564 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab0FNOGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:06:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WokiNOlWSV3LnqEDtJ/VslCH/UFiCdQGSJXmZ3kYsxyolekV6OhwsYDaAeiOSrkcTS
         NZWp48zw+EikCnD8oI4KAYgWqoll43tRLaWj74mzMH4zpEEx6QNE1ZuHhTbY/GAJsl1a
         +G/el4bcnCB7JDvIDbW7/NZcYzdsR5cPdSFXg=
Date: Mon, 14 Jun 2010 17:09:41 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Jiri Slaby <jslaby@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: using smp_processor_id() in preemptible code: s2disk
Message-ID: <20100614140941.GA3581@swordfish.minsk.epam.com>
References: <20100613203352.GA3577@swordfish>
 <1276461183.2659.4.camel@maxim-laptop>
 <201006140136.18652.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006140136.18652.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
Not sure if this simple solution is the correct one.

---

diff --git a/kernel/sched.c b/kernel/sched.c
index f8b8996..cfb262b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2866,7 +2866,10 @@ unsigned long nr_iowait(void)
 
 unsigned long nr_iowait_cpu(void)
 {
-	struct rq *this = this_rq();
+	int cpu = get_cpu();
+	struct rq *this = cpu_rq(cpu);
+	put_cpu();
+	
 	return atomic_read(&this->nr_iowait);
 }
 
