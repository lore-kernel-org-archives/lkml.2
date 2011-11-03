Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab1KCSvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 14:51:11 -0400
Received: from swift.blarg.de ([78.47.110.205]:54828 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756427Ab1KCSvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 14:51:09 -0400
Date: Thu, 3 Nov 2011 19:51:08 +0100
From: Max Kellermann <max@duempel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] new cgroup controller "fork"
Message-ID: <20111103185108.GA5153@Debian-60-squeeze-64-minimal>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
	containers@lists.linux-foundation.org,
	Frederic Weisbecker <fweisbec@gmail.com>
References: <20111103162238.27609.11515.stgit@rabbit.intern.cm-ag>
 <4EB2C4A5.6000406@parallels.com>
 <20111103165903.GA4755@Debian-60-squeeze-64-minimal>
 <20111103182101.5037c1e5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103182101.5037c1e5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011/11/03 19:21, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > After little discussion, nobody seemed to be interested in it, and
> > nobody merged it.  I reposted it today, not knowing somebody else had
> > come up with a similar idea meanwhile.
> 
> I don't really see a meaningful use case for this. Why should millions of
> users have this stuff in their kernel. What's the general purpose use
> case we should all be excited about ?

Putting a reasonable limit on jobs that are expected to run only for a
limited amount of time, with a limited amount of total resources.  For
example: CGI, cron jobs, backup, munin plugins, virus scanners and
other email filters, procmail, ... - when the job is done, the group
can be deleted, and new instances will run in a new group.

With just RLIMIT_NPROC or task_counter, you can limit the total number
of processes, but it will not stop a fork bomb - it will only slow it
down.  The fork bomb will still bounce between 1 and the limit, and
consume lots of resources for forking and exiting.

(Glauber: the above should answer your last email, too)

Similar existing feature: RLIMIT_CPU.  Millions of users have it in
their kernels, but nobody uses it nowadays.  And it's not even
optional.

Btw. I have no problem with maintaining this patch (and a whole bunch
of others) in my proprietary git repository at work forever.  They're
very useful for my employer.  I'm just trying to be a good citizen by
sharing them.

Max
