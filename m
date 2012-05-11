Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946044Ab2EKTJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:09:23 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:39227 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932215Ab2EKTJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:09:21 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: fjuUAkUVM1l7YcaRwQ.OhVdOFSkaZYS0SJWla9aoppVkpPb
 5ckTFMqWJ6V1thZSPB.P6HA2rRfyqm8iQvomfz.1WsqRL8SqPerYz2PahWj2
 vzO8UGeC0M0QzgRkTqcELpSrCc3FXBPHaQnNqumiHRn4Qm79_qYTecVxJeo4
 WLBV6E8odAY_s_6yGyriJjNwpdRSMkugoDan252YzYa43Ut5myWL9jU0LkEH
 BUtR9NkS3nkH11h0hsI2SoYvKoj4LFtWuCGb18KKKc1lknlDz3f_hE10g.EU
 whA58Sp7fdhJbZ3KZ3auauvECKSt5222kiOZIS0m8BDA.9ZBB5hUdsfW_CiT
 M_9eg3oq.DRBjR_zGxByAkoI2P2OEsEEKc9E5CFXN8MInQo8tajyVlA7VJof
 2
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 11 May 2012 14:09:15 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 04/29] slub: always get the cache from its page in
 kfree
In-Reply-To: <4FAD6169.8090409@parallels.com>
Message-ID: <alpine.DEB.2.00.1205111407280.386@router.home>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-5-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205111251420.31049@router.home> <4FAD531D.6030007@parallels.com> <alpine.DEB.2.00.1205111305570.386@router.home>
 <4FAD566C.3000804@parallels.com> <alpine.DEB.2.00.1205111316540.386@router.home> <4FAD585A.4070007@parallels.com> <alpine.DEB.2.00.1205111331010.386@router.home> <4FAD5DA2.70803@parallels.com> <alpine.DEB.2.00.1205111354540.386@router.home>
 <4FAD6169.8090409@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Glauber Costa wrote:

> On 05/11/2012 03:56 PM, Christoph Lameter wrote:
> > On Fri, 11 May 2012, Glauber Costa wrote:
> >
> > > So we don't mix pages from multiple memcgs in the same cache - we believe
> > > that
> > > would be too confusing.
> >
> > Well subsystem create caches and other things that are shared between
> > multiple processes. How can you track that?
>
> Each process that belongs to a memcg triggers the creation of a new child kmem
> cache.

I see that. But there are other subsystems from slab allocators that do
the same. There are also objects that may be used by multiple processes.
F.e what about shm?

> > > /proc/slabinfo reflects this information, by listing the memcg-specific
> > > slabs.
> >
> > What about /sys/kernel/slab/*?
>
> From the PoV of the global system, what you'll see is something like:
> dentry , dentry(2:memcg1), dentry(2:memcg2), etc.

Hmmm.. Would be better to have a hierachy there. /proc/slabinfo is more
legacy.
