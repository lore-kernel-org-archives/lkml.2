Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab2EaH6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 03:58:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48631 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757764Ab2EaH6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 03:58:10 -0400
X-IronPort-AV: E=Sophos;i="4.75,690,1330876800"; 
   d="scan'208";a="5084108"
Message-ID: <4FC724B1.70508@cn.fujitsu.com>
Date: Thu, 31 May 2012 15:58:41 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: David Rientjes <rientjes@google.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, hannes@cmpxchg.org,
        mhocko@suse.cz, bsingharora@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com> <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com> <4FC6B68C.2070703@jp.fujitsu.com> <CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com> <4FC6BC3E.5010807@jp.fujitsu.com> <alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com> <4FC6C111.2060108@jp.fujitsu.com> <alpine.DEB.2.00.1205301831270.25774@chino.kir.corp.google.com> <4FC6D881.4090706@jp.fujitsu.com> <alpine.DEB.2.00.1205302156090.25774@chino.kir.corp.google.com> <4FC70355.70805@jp.fujitsu.com> <alpine.DEB.2.00.1205302314190.25774@chino.kir.corp.google.com> <4FC70E5E.1010003@gmail.com> <alpine.DEB.2.00.1205302325500.25774@chino.kir.corp.google.com> <4FC711A5.4090003@gmail.com> <alpine.DEB.2.00.1205302351510.25774@chino.kir.corp.google.com> <CAHGf_=qVDVT6VW2j9gE3bQKwizW24iivrDryiCKoxVu4m_fWKw@mail.gmail.com> <alpine.DEB.2.00.1205310028420.8864@chino.kir.corp.google.com> <4FC720EE.3010307@gmail.com>
In-Reply-To: <4FC720EE.3010307@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/31 15:56:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/31 15:56:17
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年05月31日 15:42, KOSAKI Motohiro 写道:
> (5/31/12 3:35 AM), David Rientjes wrote:
>> On Thu, 31 May 2012, KOSAKI Motohiro wrote:
>>
>>>> As I said, LXC and namespace isolation is a tangent to the discussion of
>>>> faking the /proc/meminfo for the memcg context of a thread.
>>>
>>> Because of, /proc/meminfo affect a lot of libraries behavior. So, it's not only
>>> application issue. If you can't rewrite _all_ of userland assets, fake meminfo
>>> can't be escaped. Again see alternative container implementation.
>>>
>>
>> It's a tangent because it isn't a complete psuedo /proc/meminfo for all
>> threads attached to a memcg regardless of any namespace isolation; the LXC
>> solution has existed for a couple of years by its procfs patchset that
>> overlaps procfs with fuse and can suppress or modify any output in the
>> context of a memory controller using things like
>> memory.{limit,usage}_in_bytes.  I'm sure all other fields could be
>> modified if outputted in some structured way via memcg; it looks like
>> memory.stat would need to be extended to provide that.  If that's mounted
>> prior to executing the application, then your isolation is achieved and
>> all libraries should see the new output that you've defined in LXC.
>>
>> However, this seems like a seperate topic than the patch at hand which
>> does this directly to /proc/meminfo based on a thread's memcg context,
>> that's the part that I'm nacking.
> 
> Then, I NAKed current patch too. Yeah, current one is ugly. It assume _all_
> user need namespace isolation and it clearly is not.
> 
> 
>> I'd recommend to Gao to expose this
>> information via memory.stat and then use fuse and the procfs lxc support
>> as your way of contextualizing the resources.
> 
> It's one of a option. But, I seriously doubt fuse can make simpler than kamezawa-san's
> idea. But yeah, I might NACK kamezawa-san's one if he will post ugly patch.
> 

It seams I should do some homework to make the implement beautifully.

I think kamezawa-san's idea is more simpler.
thanks for your advice.

> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

