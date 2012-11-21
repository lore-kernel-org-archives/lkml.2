Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab2KUIKC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:10:02 -0500
Received: from nm6-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.146]:20908 "EHLO
	nm6-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634Ab2KUIKB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:10:01 -0500
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Nov 2012 03:10:00 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 529279.44201.bm@omp1005.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=onET3wcQ7rTvTZ9F3uLlaeHO4erKeZant7LI72Is33R5plG+FYiTLHV1oVwG/IoGBvXQatweuBx9Q6k3/lJ5fS2fm6GYwH+6Xz9Ce1JxlOHbHKCtF/qMdFClmjKuRklFzVFBSEcOxTd8edzfjfN15KL0z/MfNg0u/11Hht6FvYo=;
X-YMail-OSG: spmwjbMVM1kpjNjvqx6HTUWQMI2YSqOxm34e7VckV77WhD9
 1gGS3pPFBj._jPWsfnWMPHSIcFR4IjBYXNTtorfKnDbsNJ9b0jfuNhykhp9c
 BLffXPOgjzMY3CaQvdIypxMqK_dBFliUSVOm3qH5kMvo5GdhcY9IoSFf_I.D
 KRIB9CcbwhjWtnlMSriEpfS34h76mCTz0h_BeBknEFnW3.RUbEoOnxrmj2D_
 tSv6iR0nkYWEMmdvPB_QqOuW4CfgX44XBFsU3XZT_lJkpjKZkUYO1HTQVuTM
 _3gAjBgKeqRby7Sjk9shrvzdz2LALWOO7xTbGPJZ8zRadH7N2EvrUP8CiL4c
 E7ovFIqNSDNmdHTeyCeou9T4xZL2.vM9oWbo6OHxoHQSsmNJQ11ct3aJbLmD
 vrthAvE5FubXV3Ofay11PS0v8delNl6RV7Vuk__btUB4yLzlicP2qGayp7Do
 poxBavbRh4kFMwHqT6pcbT75wCDjizxUjbBcdoCXxOU8T4LX3uOaCOYb3ZM9
 l22o-
X-Rocket-MIMEInfo: 001.001,Cgo.IMKgQ3VyaW91cy4gQWRkZWQgbGludXgtbW0gbGlzdCB0byBDQyB0byBjYXRjaCBtb3JlIGF0dGVudGlvbi4gSWYgeW91IHJ1bgo.IGVjaG8gMSA.L3Byb2Mvc3lzL3ZtL2Ryb3BfY2FjaGVzwqBkb2VzIGl0IGV2aWN0IGRhdGEtMSBwYWdlcyBmcm9tIG1lbW9yeT8KCgpJJ20gZ3Vlc3NpbmcgaXQnZCBldmljdCB0aGUgZW50cmllcywgYnV0IGFtIHdvbmRlcmluZyBpZiB3ZSBjb3VsZCBydW4gYW55IG1vcmUgZGlhZ25vc3RpY3MgYmVmb3JlIHRyeWluZyB0aGlzLgoKV2UgcmVndWxhcmx5IHVzZSBhIHNldHUBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.123.460
References: <1353433362.85184.YahooMailNeo@web141101.mail.bf1.yahoo.com> <20121120182500.GH1408@quack.suse.cz>
Message-ID: <1353485020.53500.YahooMailNeo@web141104.mail.bf1.yahoo.com>
Date: Wed, 21 Nov 2012 00:03:40 -0800 (PST)
From: metin d <metdos@yahoo.com>
Reply-To: metin d <metdos@yahoo.com>
Subject: Re: Problem in Page Cache Replacement
To: Jan Kara <jack@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20121120182500.GH1408@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>  Curious. Added linux-mm list to CC to catch more attention. If you run
> echo 1 >/proc/sys/vm/drop_caches does it evict data-1 pages from memory?


I'm guessing it'd evict the entries, but am wondering if we could run any more diagnostics before trying this.

We regularly use a setup where we have two databases; one gets used frequently and the other one about once a month. It seems like the memory manager keeps unused pages in memory at the expense of frequently used database's performance.

My understanding was that under memory pressure from heavily accessed pages, unused pages would eventually get evicted. Is there anything else we can try on this host to understand why this is happening?

Thank you,

Metin


----- Original Message -----
From: Jan Kara <jack@suse.cz>
To: metin d <metdos@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; linux-mm@kvack.org
Sent: Tuesday, November 20, 2012 8:25 PM
Subject: Re: Problem in Page Cache Replacement

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
> and it seems that I use one NUMA instance, if  you think that it can a problem.
> 
> $ numactl --hardware
> available: 1 nodes (0)
> node 0 cpus: 0 1 2 3 4 5 6 7
> node 0 size: 70007 MB
> node 0 free: 360 MB
> node distances:
> node   0
>   0:  10

                                Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

