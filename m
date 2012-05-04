Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159Ab2EDE2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 00:28:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:60284 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750747Ab2EDE2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 00:28:03 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Ed5gx7xzEQ9/GYuwN1p9lQOT95UEtWxc0lKcvcd
	V6qgTtLTALvJtx
Message-ID: <1336105676.7356.42.camel@marge.simpson.net>
Subject: Re: [PATCH]  Re: [RFC PATCH] namespaces: fix leak on fork() failure
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
Date: Fri, 04 May 2012 06:27:56 +0200
In-Reply-To: <1336057018.8119.46.camel@marge.simpson.net>
References: <1335604790.5995.22.camel@marge.simpson.net>
	 <20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	 <20120429165846.GA19054@redhat.com>
	 <1335754867.17899.4.camel@marge.simpson.net>
	 <m1zk9rmyh4.fsf@fess.ebiederm.org>
	 <20120501134214.f6b44f4a.akpm@linux-foundation.org>
	 <1336014721.7370.32.camel@marge.simpson.net>
	 <1336057018.8119.46.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namespaces have something in common with cgroups.  synchronize_rcu()
makes them somewhat less than wonderful for dynamic use.

default flags = SIGCHLD

-namespace:  flag |= CLONE_NEWPID 
-all:  flags |= CLONE_NEWIPC | CLONE_NEWNET | CLONE_NEWUSER

marge:/usr/local/tmp/starvation # ./hackbench
Running with 10*40 (== 400) tasks.
Time: 2.636
marge:/usr/local/tmp/starvation # ./hackbench -namespace
Running with 10*40 (== 400) tasks.
Time: 11.624
marge:/usr/local/tmp/starvation # ./hackbench -namespace -all
Running with 10*40 (== 400) tasks.
Time: 51.474

You can create trash quickly, but you have to haul it away.

-Mike

