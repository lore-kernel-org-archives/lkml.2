Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab1ASWA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:00:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36739 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab1ASWA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:00:26 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=44vUGAvzfu8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VhnPjRMhnS5vXacRXtcA:9 a=GTANmT8zZHJWgP56BHA7_QT_ju4A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: mathieu.desnoyers@efficios.com, richm@oldelvet.org.uk,
        609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
In-Reply-To: <20110119.134047.232915743.davem@davemloft.net>
References: <20110118.223247.241909079.davem@davemloft.net>
	 <20110118.232045.58440904.davem@davemloft.net>
	 <20110119153326.GC11022@Krystal>
	 <20110119.134047.232915743.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 19 Jan 2011 17:00:23 -0500
Message-ID: <1295474423.12215.1612.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 13:40 -0800, David Miller wrote:

> My concern is that if there is ever a u64 or similarly "long long"
> typed member in these tracing structures, it will not be aligned
> sufficiently to avoid unaligned access traps on 32-bit systems.

The structure that gets placed in this section is the ftrace_event_call.
It consists only of pointers, a struct list_head, a couple of "int", and
a struct trace_event, which consists of: a struct hlist_node, a struct
list_head, an int, and a pointer.

None of these are more than "long" and I don't foresee them needing a
long long type. I think assuming that a long is the largest item should
due.

We can add a comment next to these structures specifying this
dependency, and hopefully it would be updated if we ever do include a
long long in them.

-- Steve


