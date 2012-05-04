Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab2EDJpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 05:45:23 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53804 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753523Ab2EDJpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 05:45:22 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1935y4CzzJ3y8u5eMpPnIEDPykb2N9RuErYS3ROTV
	o1lMYv8yaBOzxb
Message-ID: <1336124716.25479.36.camel@marge.simpson.net>
Subject: Re: [PATCH]  Re: [RFC PATCH] namespaces: fix leak on fork() failure
From: Mike Galbraith <efault@gmx.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
Date: Fri, 04 May 2012 11:45:16 +0200
In-Reply-To: <m1aa1oidmn.fsf@fess.ebiederm.org>
References: <1335604790.5995.22.camel@marge.simpson.net>
	 <20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	 <20120429165846.GA19054@redhat.com>
	 <1335754867.17899.4.camel@marge.simpson.net>
	 <m1zk9rmyh4.fsf@fess.ebiederm.org>
	 <20120501134214.f6b44f4a.akpm@linux-foundation.org>
	 <1336014721.7370.32.camel@marge.simpson.net>
	 <1336057018.8119.46.camel@marge.simpson.net>
	 <1336105676.7356.42.camel@marge.simpson.net>
	 <m1aa1oidmn.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 00:55 -0700, Eric W. Biederman wrote:

> CLONE_NEWUSER?  I presume you have applied my latest user namespace
> patches?  Otherwise you are running completely half baked code.

I Removed CLONE_NEWUSER flag.

> hackbench?  Which kernel are you running.  Hackbench in some kernels is
> really good at triggering cache ping-pong effects with pids, and creds.

Not when pinned.  3.0 kernel without the debug stuff enabled in 3.4.git.
 
marge:/usr/local/tmp/starvation # taskset -c 3 ./hackbench
Running with 10*40 (== 400) tasks.
Time: 0.868
marge:/usr/local/tmp/starvation # taskset -c 3 ./hackbench -namespace
Running with 10*40 (== 400) tasks.
Time: 7.582
marge:/usr/local/tmp/starvation # taskset -c 3 ./hackbench -namespace -all
Running with 10*40 (== 400) tasks.
Time: 29.677

-Mike

