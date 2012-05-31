Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab2EaHfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 03:35:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38707 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab2EaHfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 03:35:52 -0400
Date: Thu, 31 May 2012 00:35:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
In-Reply-To: <CAHGf_=qVDVT6VW2j9gE3bQKwizW24iivrDryiCKoxVu4m_fWKw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205310028420.8864@chino.kir.corp.google.com>
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com> <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com> <4FC6B68C.2070703@jp.fujitsu.com> <CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com> <4FC6BC3E.5010807@jp.fujitsu.com>
 <alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com> <4FC6C111.2060108@jp.fujitsu.com> <alpine.DEB.2.00.1205301831270.25774@chino.kir.corp.google.com> <4FC6D881.4090706@jp.fujitsu.com> <alpine.DEB.2.00.1205302156090.25774@chino.kir.corp.google.com>
 <4FC70355.70805@jp.fujitsu.com> <alpine.DEB.2.00.1205302314190.25774@chino.kir.corp.google.com> <4FC70E5E.1010003@gmail.com> <alpine.DEB.2.00.1205302325500.25774@chino.kir.corp.google.com> <4FC711A5.4090003@gmail.com> <alpine.DEB.2.00.1205302351510.25774@chino.kir.corp.google.com>
 <CAHGf_=qVDVT6VW2j9gE3bQKwizW24iivrDryiCKoxVu4m_fWKw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012, KOSAKI Motohiro wrote:

> > As I said, LXC and namespace isolation is a tangent to the discussion of
> > faking the /proc/meminfo for the memcg context of a thread.
> 
> Because of, /proc/meminfo affect a lot of libraries behavior. So, it's not only
> application issue. If you can't rewrite _all_ of userland assets, fake meminfo
> can't be escaped. Again see alternative container implementation.
> 

It's a tangent because it isn't a complete psuedo /proc/meminfo for all 
threads attached to a memcg regardless of any namespace isolation; the LXC 
solution has existed for a couple of years by its procfs patchset that 
overlaps procfs with fuse and can suppress or modify any output in the 
context of a memory controller using things like 
memory.{limit,usage}_in_bytes.  I'm sure all other fields could be 
modified if outputted in some structured way via memcg; it looks like 
memory.stat would need to be extended to provide that.  If that's mounted 
prior to executing the application, then your isolation is achieved and 
all libraries should see the new output that you've defined in LXC.

However, this seems like a seperate topic than the patch at hand which 
does this directly to /proc/meminfo based on a thread's memcg context, 
that's the part that I'm nacking.  I'd recommend to Gao to expose this 
information via memory.stat and then use fuse and the procfs lxc support 
as your way of contextualizing the resources.
