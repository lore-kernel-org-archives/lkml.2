Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030496Ab2EQWc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:32:29 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33111 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030224Ab2EQWcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:32:23 -0400
X-Originating-IP: 217.70.178.136
X-Originating-IP: 50.43.46.74
Date: Thu, 17 May 2012 15:32:11 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 2/2] rcu: Fix broken strings in RCU's
 source code.
Message-ID: <20120517223211.GC15766@leaf>
References: <20120517221217.GA12196@linux.vnet.ibm.com>
 <1337292765-12221-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1337292765-12221-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <1337293209.4281.111.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337293209.4281.111.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 12:20:09AM +0200, Peter Zijlstra wrote:
> On Thu, 2012-05-17 at 15:12 -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Although the C language allows you to break strings across lines, doing
> > this makes it hard for people to find the Linux kernel code corresponding
> > to a given console message.  This commit therefore fixes broken strings
> > throughout RCU's source code. 
> 
> While I'm not a strict 80 chars zealot, I do find exceedingly long lines
> utterly annoying, editors either wrap them in the most hideous way or
> you don't see them.

For the most part, printable strings should have a final formatted
length of less than 80 characters so that they don't wrap in dmesg, and
preferably a bit less so that they don't wrap when prefixed with a
high-resolution timestamp.  Two main problems cause those strings to
take up more than 80 characters in source code: format specifiers that
take up more room than the parameters they format, and indentation plus
the name of the printing function.  Even keeping those in mind, lines
with strings on them shouldn't end up insanely long; if they do, perhaps
that indicates that the lines should have some newlines in the middle.

- Josh Triplett
