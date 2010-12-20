Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab0LTQTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:19:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64865 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab0LTQTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:19:13 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=AzZoYt4QXE8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=qMxJjGRyKDQZrHv0guQA:9 a=uXECOd4omzA857qZ5FyjgXoTXLoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH 03/15] nohz_task: Make tick stop and restart
 callable outside idle
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <1292860133.5021.7.camel@laptop>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-4-git-send-email-fweisbec@gmail.com>
	 <1292860133.5021.7.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 20 Dec 2010 11:19:10 -0500
Message-ID: <1292861950.22905.26.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 16:48 +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > +                       if (!current->pid)
> 
> I'm not exactly sure that's the sanest way to test if you're the idle
> thread...

Would

 if (idle_cpu(cpu))

be better?

-- Steve



