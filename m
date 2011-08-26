Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab1HZOx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:53:56 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:50964 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1HZOxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:53:53 -0400
MIME-Version: 1.0
Message-ID: <08cd2e30-87f7-4cd1-8a79-c9799dde80a5@default>
Date: Fri, 26 Aug 2011 07:53:19 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        sjenning@linux.vnet.ibm.com, jackdachef@gmail.com, cyclonusj@gmail.com
Subject: RE: Subject: [PATCH V7 2/4] mm: frontswap: core code
References: <20110823145815.GA23190@ca-server1.us.oracle.com>
 <20110825150532.a4d282b1.kamezawa.hiroyu@jp.fujitsu.com>
 <d0b4c414-e90f-4ae0-9b70-fd5b54d2b011@default
 20110826091619.1ad27e9c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110826091619.1ad27e9c.kamezawa.hiroyu@jp.fujitsu.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090207.4E57B36B.00D8,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> Subject: Re: Subject: [PATCH V7 2/4] mm: frontswap: core code
> 
> On Thu, 25 Aug 2011 10:37:05 -0700 (PDT)
> Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> 
> > > From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> > > Subject: Re: Subject: [PATCH V7 2/4] mm: frontswap: core code
> 
> > > BTW, Do I have a chance to implement frontswap accounting per cgroup
> > > (under memcg) ? Or Do I need to enable/disale switch for frontswap per memcg ?
> > > Do you think it is worth to do ?
> >
> > I'm not very familiar with cgroups or memcg but I think it may be possible
> > to implement transcendent memory with cgroup as the "guest" and the default
> > cgroup as the "host" to allow for more memory elasticity for cgroups.
> > (See http://lwn.net/Articles/454795/ for a good overview of all of
> > transcendent memory.)
> >
> Ok, I'll see it.
> 
> I just wonder following case.
> 
> Assume 2 memcgs.
> 	memcg X: memory limit = 300M.
> 	memcg Y: memory limit = 300M.
> 
> This limitation is done for performance isolation.
> When using frontswap, X and Y can cause resource confliction in frontswap and
> performance of X and Y cannot be predictable.

Oops, sorry for the extra reply, but I realize I cut/paste to
reply to this part and neglected to reply.

IMHO, it is impossible to do both dynamic resource optimization and
performance isolation.  So if the purpose of containers is for performance
isolation you need to partition ALL resources, including CPUs (and
not even split threads) and I/O devices.  And even then there will
be unpredictable use of some shared system resource (such as maybe
a QPI link or PCI bus).  If you are not partitioning all resources,
then RAM is just another resource that should be dynamically optimized
which may result in performance variations.  With strict policies,
maybe some quality-of-service guarantees can be made.

But that's just my opinion...

Dan
