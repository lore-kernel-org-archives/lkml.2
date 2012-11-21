Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab2KUINy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:13:54 -0500
Received: from nm1.bullet.mail.bf1.yahoo.com ([98.139.212.160]:27667 "EHLO
	nm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126Ab2KUINv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:13:51 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 754567.44531.bm@omp1012.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=dWa5lM5/v2GtjXj8OjIOJdLspjndJa9syCp2cD8pNvmX9nwFDv7vO1A3+RXTHOv7zUOawsUjAEl4CcoP3DwfVUxCBKd/VYv3nxUzQ/nnD2+rfo9QPLJXabM+DQFOYHjjCAUDfx2XYRThzTD/GG4Lg/K85uuL3hs5LXWbhdZDnyA=;
X-YMail-OSG: a0Cq4D4VM1nmea9T7n4bhYQ0IislFpihyboYIAKXDu4t9zC
 qkD.cowzDY3zphWUEpcipsuqPSAh4IdJ3Oh6JK74az0o8RfbfQ9ZanfMWcs7
 zBcIoly3apXtAPQXW2lReqYzdQmmiFfBHeEC1pCJDJxI1Upl6lsIpl1zJ8mO
 jFGhvZUnYE02sVsRIbq_GW5C_49qXMplPNzFOd5rzM2lVUhU2LkZojmt3FgR
 Any00mMn9.oR.kdMmAnh5UrgVWomDQKAagZDMdoI38UHFEjs7Uw1P.rdOPPf
 hjFaTSxqsANStsdHWVlLYq8UBy1OCXqLPbdiGOJnqNvGI88SpPsm0BPvJIZv
 dKkfKrcOu4V.ImHfxUhc_U0HG.eiooekVdUHi5FI3DdK5vPGjucKqap3NChB
 llRvSnag7Bw6q_5UH3ZCvYCd8TLPJo8pJCQbkxKK_POjlY3Yq442MPRGDX4u
 ATVw.bXZ9vfrLPseRztk3enZOorPuQ1fc9e5_BwIy30YklcF8m57eLO2yrBc
 rMDnh
X-Rocket-MIMEInfo: 001.001,PsKgIEN1cmlvdXMuIEFkZGVkIGxpbnV4LW1tIGxpc3QgdG8gQ0MgdG8gY2F0Y2ggbW9yZSBhdHRlbnRpb24uIElmIHlvdSBydW4KPiBlY2hvIDEgPi9wcm9jL3N5cy92bS9kcm9wX2NhY2hlcyBkb2VzIGl0IGV2aWN0IGRhdGEtMSBwYWdlcyBmcm9tIG1lbW9yeT8KCkknbSBndWVzc2luZyBpdCdkIGV2aWN0IHRoZSBlbnRyaWVzLCBidXQgYW0gd29uZGVyaW5nIGlmIHdlIGNvdWxkIHJ1biBhbnkgbW9yZSBkaWFnbm9zdGljcyBiZWZvcmUgdHJ5aW5nIHRoaXMuCgpXZSByZWd1bGFybHkgdXNlIGEgc2V0dXAgd2gBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.123.460
References: <1353433362.85184.YahooMailNeo@web141101.mail.bf1.yahoo.com> <20121120182500.GH1408@quack.suse.cz> <1353485020.53500.YahooMailNeo@web141104.mail.bf1.yahoo.com>
Message-ID: <1353485630.17455.YahooMailNeo@web141106.mail.bf1.yahoo.com>
Date: Wed, 21 Nov 2012 00:13:50 -0800 (PST)
From: metin d <metdos@yahoo.com>
Reply-To: metin d <metdos@yahoo.com>
Subject: Re: Problem in Page Cache Replacement
To: Jan Kara <jack@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <1353485020.53500.YahooMailNeo@web141104.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  Curious. Added linux-mm list to CC to catch more attention. If you run
> echo 1 >/proc/sys/vm/drop_caches does it evict data-1 pages from memory?

I'm guessing it'd evict the entries, but am wondering if we could run any more diagnostics before trying this.

We regularly use a setup where we have two databases; one gets used frequently and the other one about once a month. It seems like the memory manager keeps unused pages in memory at the expense of frequently used database's performance.

My understanding was that under memory pressure from heavily accessed pages, unused pages would eventually get evicted. Is there anything else we can try on this host to understand why this is happening?

Thank you,

Metin

On Tue 20-11-12 09:42:42, metin d wrote:
> I have two PostgreSQL databases named data-1 and data-2 that sit on the
> same machine. Both databases keep 40 GB of data, and the total memory
> available on the machine is 68GB.
> 
> I started data-1 and data-2, and ran several queries to go over all their
> data. Then, I shut down data-1 and kept issuing queries against data-2.
> For some reason, the OS still holds on to large parts of data-1's pages
> in its page cache, and reserves about 35 GB of RAM to data-2's files. As
> a result, my queries on data-2 keep hitting disk.
> 
> I'm checking page cache usage with fincore. When I run a table scan query
> against data-2, I see that data-2's pages get evicted and put back into
> the cache in a round-robin manner. Nothing happens to data-1's pages,
> although they haven't been touched for days.
> 
> Does anybody know why data-1's pages aren't evicted from the page cache?
> I'm open to all kind of suggestions you think it might relate to problem.
  Curious. Added linux-mm list to CC to catch more attention. If you run
echo 1 >/proc/sys/vm/drop_caches
  does it evict data-1 pages from memory?

> This is an EC2 m2.4xlarge instance on Amazon with 68 GB of RAM and no
> swap space. The kernel version is:
> 
> $ uname -r
> 3.2.28-45.62.amzn1.x86_64
> Edit:
> 
> and it seems that I use one NUMA instance, if  you think that it can a problem.
> 
> $ numactl --hardware
> available: 1 nodes (0)
> node 0 cpus: 0 1 2 3 4 5 6 7
> node 0 size: 70007 MB
> node 0 free: 360 MB
> node distances:
> node   0
>   0:  10

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

