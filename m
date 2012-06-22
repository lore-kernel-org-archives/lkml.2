Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761089Ab2FVDdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 23:33:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2481 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753603Ab2FVDdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 23:33:44 -0400
X-IronPort-AV: E=Sophos;i="4.77,455,1336320000"; 
   d="scan'208";a="5245833"
Message-ID: <4FE3E7B0.3020802@cn.fujitsu.com>
Date: Fri, 22 Jun 2012 11:34:08 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
CC: Eric Dumazet <eric.dumazet@gmail.com>, Josh Hunt <johunt@akamai.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kaber@trash.net" <kaber@trash.net>,
        Debabrata Banerjee <dbavatar@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "pekkas@netcore.fi" <pekkas@netcore.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Bug in net/ipv6/ip6_fib.c:fib6_dump_table()
References: <CAATkVEzTxT6d5nzt_qwCuFWM-WcN8hdhjGxFRPXJ4=L35wKbGw@mail.gmail.com> <4FE37783.9000409@akamai.com> <1340310469.4604.6702.camel@edumazet-glaptop> <20120621215056.GA24908@ms2.inr.ac.ru>
In-Reply-To: <20120621215056.GA24908@ms2.inr.ac.ru>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/22 11:34:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/22 11:34:03
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年06月22日 05:50, Alexey Kuznetsov 写道:
> On Thu, Jun 21, 2012 at 10:27:49PM +0200, Eric Dumazet wrote:
>> Looking at this code, it lacks proper synchronization
>> between tree updaters and tree walkers.
>>
>> fib6_walker_lock rwlock is not enough to prevent races.
> 
> Hmm. As author of this weird code, I must say I honestly believed it was correct.
> At least I tried. :-)
> 
> 
> What's about 2bec5a336.., it does not look reasonable.
> The idea was that when you change tree, you fixup sleeping walkers, moving
> their location in tree to correct point. So, walkers must not have any stale pointers
> at any times (except when you under table write lock) and no skips/counts are required.
> I remember how damn difficult was it to make this right (well, sorry, if it is not yet :-)),
> so that understand that if some update is forgotten or done incorrectly, it is not so easy to find,
> but it is definitely worth of efforts.


Actually, I spent two months to try to reproduce this crash four months ago,
But finally I give up, I don't think there was any stale pointers,
we already correct it when we change the tree.
