Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935922Ab1JFXqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 19:46:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:28819 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935903Ab1JFXqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 19:46:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="60729210"
From: Andi Kleen <andi@firstfloor.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, lennart@poettering.net, harald@redhat.com,
        david@fubar.dk, greg@kroah.com
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99s?= Wish List for Linux
References: <1317943022.1095.25.camel@mop>
Date: Thu, 06 Oct 2011 16:46:46 -0700
In-Reply-To: <1317943022.1095.25.camel@mop> (Kay Sievers's message of "Fri, 07
	Oct 2011 01:17:02 +0200")
Message-ID: <m2lisx3cpl.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:
>
> * allow changing argv[] of a process without mucking with environ[]:
> Something like setproctitle() or a prctl() would be ideal. Of course
> it

prctl(PR_SET_NAME, ...)

The only problem is that some programs still use argv[] and get the old
name, but at least it works in "top"

> * An auxiliary meta data message for AF_UNIX called SCM_CGROUPS (or
> something like that), i.e. a way to attach sender cgroup membership to
> messages sent via AF_UNIX.

The problem is: this requires a reference count and these reference
counts can be very expensive. We had the same problem with pid
namespaces ruining AF_UNIX performance in some cases.

It can be probably done, but one would need to be very careful
about scalability issues.


> * SCM_COMM, with a similar use case as SCM_CGROUPS. This auxiliary
> control message should carry the process name as available
> in /proc/$PID/comm.

That sounds super racy. No guarantee at all this is unique and useful
for anything and everyone can change it.

The other ideas mostly sound reasonable to me, but I haven't thought
a lot about their details and implications.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
