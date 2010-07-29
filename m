Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab0G2WkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 18:40:15 -0400
Received: from adelie.canonical.com ([91.189.90.139]:33650 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758115Ab0G2WkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 18:40:13 -0400
Date: Thu, 29 Jul 2010 17:39:57 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Paul Menage <menage@google.com>, Daniel Lezcano <dlezcano@free.fr>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 3/3] cgroup : remove the ns_cgroup
Message-ID: <20100729223957.GA12387@hallyn.com>
References: <20100729195629.GA13378@hallyn.com>
 <20100729195812.GB19015@hallyn.com>
 <20100729214008.GA2785@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729214008.GA2785@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Matt Helsley (matthltc@us.ibm.com):
> On Thu, Jul 29, 2010 at 02:58:12PM -0500, Serge E. Hallyn wrote:
> > The ns_cgroup is an annoying cgroup at the namespace / cgroup frontier.
> > 
> > For example, a single process can not handle a big amount of namespaces
> > without interacting with this cgroup and falling in an exponential creation
> > time due to the nested cgroup directory depth (eg. /cgroup/<pid>/.../<pid>/...).
> > 
> > That was spotted when creating a single process using multiple network namespaces,
> > the objective was 4096 network namespaces, but at 820 netns, the creation time
> > was dramatically slow and the creation time for a namespace increased from 10msec
> > to 10sec. After five hours, the expected numbers of netns was not reached.
> > Without the ns_cgroup interaction, 4K netns are created after 2 minutes.
> 
> Is this problem related to Andrew's post here re:
> 
> [Bugme-new] [Bug 16417] New: Slow context switches with SMP and CONFIG_FAIR_GROUP_SCHED

Hm, I don't think so (though it should be trivial to test :).  The
situation Daniel (the real patch and intro author) cites is I believe
mainly due to the time spent traversing very deep paths.  Whereas
Pierre doesn't seem to be even unsharing at all.  Rather he's just
creating cgroups with mkdir.

Still I could be wrong.

BTW in the past the only reason I saw for keeping ns cgroup was
to lock tasks into a devices cgroup.  Until that lazy guy who was
going to do it gets off his butt and implements user namespaces,
you'll just have to use LSMs, which is the right way.

-serge
