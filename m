Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030255Ab2GYPXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:23:47 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:32401 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933233Ab2GYPXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:23:45 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 1jJMkxwVM1l7ZTz6r5W_iRprEJKG3fwP1dYa7Ir_INhVnMG
 cgLM1lvCyEEvjhaY9vAHeSd96bTLd44WK8yNuAWIHKJMP7v11Ze3.LhDdK5J
 DCm7wCiYXpRGNb2R8ClmFe3Q7DPPkiU6P86k2BUZGKP_zbIYtmZMZ3j3Axq9
 YOEWj99oW.kyYvO__nQ29d5yrdl60sOE2pGnEj5rgk2QE5.ben3nqHhZmgEH
 XU_Fwu_F_SRNjaHfy3EpAJ6Yg.cobDKi5lgCn4KVvTrqG9N7fuMuYqCWQJ4W
 4l0sa1IK393AZbuo73Tu.YAmL81tW8RBhZ6ku9WoVWpBueaA1prYFERmv1I.
 MfA5a2WbrzzOXOgeK5kDK6irM8xTTfwwFcEPuddJtUrA3.oT8GrOtDG5L487
 Tw3mT2LQ97EwmQRpd
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 25 Jul 2012 10:23:40 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, cgroups@vger.kernel.org,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v4 24/25] memcg/slub: shrink dead caches
In-Reply-To: <5009D8D8.6040509@parallels.com>
Message-ID: <alpine.DEB.2.00.1207251022570.32678@router.home>
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <1340015298-14133-25-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1207061015030.28648@router.home> <5009D8D8.6040509@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2012, Glauber Costa wrote:

> > This is the same btw in SLAB which keeps objects in per cpu caches and
> > keeps empty slab pages on special queues.
> >
> >> This patch marks all memcg caches as dead. kmem_cache_shrink is called
> >> for the ones who are not yet dead - this will force internal cache
> >> reorganization, and then all references to empty pages will be removed.
> >
> > You need to call this also for slab to drain the caches and free the pages
> > on the empty list.
> >
> Doesn't the SLAB have a time-based reaper for that?

Yes but it will take a couple of minutes to drain the caches.

