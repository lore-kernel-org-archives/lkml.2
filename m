Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab1KQAXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 19:23:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44518 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab1KQAXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 19:23:47 -0500
X-Authority-Analysis: v=2.0 cv=Pdt9d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=xtFQHgqWy1oA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=YMsDNURUaslKey-XaG4A:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH -rt] memcg: use migrate_disable()/migrate_enable( ) in
 memcg_check_events()
From: Steven Rostedt <rostedt@goodmis.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Luis Henriques <henrix@camandro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20111117084814.0e6b8169.kamezawa.hiroyu@jp.fujitsu.com>
References: <alpine.LFD.2.02.1111150050590.4902@ionos>
	 <20111115084059.GA23250@zhy> <20111116091653.GA8692@zhy>
	 <1321452758.4181.18.camel@frodo> <alpine.LFD.2.02.1111161801270.4902@ionos>
	 <20111116171809.GA1999@hades>
	 <20111117084814.0e6b8169.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 19:23:43 -0500
Message-ID: <1321489423.4181.41.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 08:48 +0900, KAMEZAWA Hiroyuki wrote:

> > I run a quick test and it looks like the problem is gone.
> > 
> > Cheers,
> 
> Could you CC the final patch to cgroups@vger.kernel.org ?
> Does this fix will go thorugh rt tree rather than -mm ?

This particular fix only goes through the rt tree because it is only a
bug when full rt is enabled. When rt is enabled, spin_locks become
mutexes, and thus can not be used when preemption is disabled. The rt
tree introduced a local_lock() to remove open coded preempt disabling
and also to help annotate places that need per cpu protections.

-- Steve


