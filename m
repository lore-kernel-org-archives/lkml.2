Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab1ETDAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:00:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53403 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081Ab1ETDAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:00:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD5D92B.8030209@jp.fujitsu.com>
Date: Fri, 20 May 2011 11:59:55 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-mm@kvack.org, yinghan@google.com, linux-kernel@vger.kernel.org
CC: kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH V2 2/2] change shrinker API by passing shrink_control
 struct
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, got Nick's email wrong.
> 
> --Ying

Ping.
Can you please explain current status? When I can see your answer?



> 
> On Tue, Apr 26, 2011 at 6:15 PM, Ying Han <yinghan@google.com> wrote:
>> On Tue, Apr 26, 2011 at 5:47 PM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>>>> > > {
>>>> > >    struct xfs_mount *mp;
>>>> > >    struct xfs_perag *pag;
>>>> > >    xfs_agnumber_t ag;
>>>> > >    int       reclaimable;
>>>> > > +   int nr_to_scan = sc->nr_slab_to_reclaim;
>>>> > > +   gfp_t gfp_mask = sc->gfp_mask;
>>>> >
>>>> > And, this very near meaning field .nr_scanned and .nr_slab_to_reclaim
>>>> > poped up new question.
>>>> > Why don't we pass more clever slab shrinker target? Why do we need pass
>>>> > similar two argument?
>>>> >
>>>>
>>>> I renamed the nr_slab_to_reclaim and nr_scanned in shrink struct.
>>>
>>> Oh no. that's not naming issue. example, Nick's previous similar patch pass
>>> zone-total-pages and how-much-scanned-pages. (ie shrink_slab don't calculate
>>> current magical target scanning objects anymore)
>>>    ie, "4 * max_pass * (scanned / nr- lru_pages-in-zones)"
>>>
>>> Instead, individual shrink_slab callback calculate this one.
>>> see git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
>>>
>>> I'm curious why you change the design from another guy's previous very similar effort and
>>> We have to be convinced which is better.
>>
>> Thank you for the pointer. My patch is intended to consolidate all
>> existing parameters passed from reclaim code
>> to the shrinker.
>>
>> Talked w/ Nick and Andrew from last LSF, we agree that this patch
>> will be useful for other extensions later which allows us easily
>> adding extensions to the shrinkers without shrinker files. Nick and I
>> talked about the effort later to pass the nodemask down to the
>> shrinker. He is cc-ed in the thread. Another thing I would like to
>> repost is to add the reclaim priority down to the shrinker, which we
>> won't throw tons of page caches pages by reclaiming one inode slab
>> object.
>>
>> --Ying


