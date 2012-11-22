Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab2KWAsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 19:48:18 -0500
Received: from nm40-vm1.bullet.mail.bf1.yahoo.com ([72.30.239.209]:32805 "EHLO
	nm40-vm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756547Ab2KWAsN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 19:48:13 -0500
X-Greylist: delayed 14417 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Nov 2012 19:48:13 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 533563.18359.bm@omp1047.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=s0HtsvC1sQkTgpMrxqMys/8ujR5zNr+8pOzW94kifpBklMBOo6uXaaHJ5uupsq/8wm2XxtfdlGDjE4rlU48gJlSyL0iB0C0FRS0YYJBBwtQQ0duogKlJsGwLCghtxiSEYsHTWP2uYHaabGetbd1zIbt24lZAMXLX2kS7YHUe4A4=;
X-YMail-OSG: 0AvVFeoVM1kMdcoJAPOAzdAM1uQE7j37baX.yqMukeRvZGJ
 dGw62EXkyaOdZ8enqFLVCh_ntkyTkPmn4p7LTGoPYrbR6aTT0yMigNhIk1hu
 VtdOMRgHYmU5fmmRPZKsNo5rcIhUSjQaeu1NmzWki4qK99Ua5g3jy7rjVPx9
 atp0UDNPUGgATbCYakYJOINAk6Osxy_NadT4AfgrR7oP3oIvtQ71vwzBC65J
 7c8mzoUdsd.19v7rDwF7cFPhMPkoGdR.9DXDJFIQaKtmGEUpmk60cYd5L1Rh
 crAG9YJ_8jENabCVKbcr2s5RUA0aoSHiteFghtTYgzP7nXK_tSN9DhRvfkqe
 KdUL.HaFsEhJGb1gLOi4vZrcG1SOqV5aZemjGBwmdvnc6mUkZS51Lfo5GPiz
 04NA4OQM7hfiX2fdt5xg9UB._I8zU2IskoJci29BG9x6AbD9BopvLe8Uv.QE
 a33gC2VkO_dGy.lPBOHs0YbLSSGgIxU.hrejCtJJM0zYWUCnRi6G57zn1jU2
 Jf4jv
X-Rocket-MIMEInfo: 001.001,SGkgSm9oYW5uZXMsCgpZZXMsIHByb2JsZW0gd2FzIGFzIHlvdSBwcm9qZWN0ZWQuIEkgdHJpZWQgdG8gbWFrZSAiYWN0aXZlIiBkYXRhLTIgcGFnZXMgYnkgbWFudWFsbHkgcmVhZGluZyB0aGVtIHR3aWNlLCBhbmQgZmluYWxseSBkYXRhLTEgYXJlIGdvdCBvdXQgb2YgcGFnZSBjYWNoZS4KCldlIGhhdmUgbGFyZ2UgZmlsZXMgaW4gUG9zdGdyZVNRTCBhbmQgSGFkb29wIHRoYXQgd2Ugc2VxdWVudGlhbGx5IHNjYW4gb3ZlcjsgYW5kIHRyeSB0byBmaXQgb3VyIHdvcmtpbmcgc2V0IGludG8gdG90YWwgbWVtb3IBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.123.460
References: <1353433362.85184.YahooMailNeo@web141101.mail.bf1.yahoo.com> <20121120182500.GH1408@quack.suse.cz> <20121121213417.GC24381@cmpxchg.org> <50AD7647.7050200@gmail.com> <20121122010959.GF24381@cmpxchg.org>
Message-ID: <1353577068.19982.YahooMailNeo@web141101.mail.bf1.yahoo.com>
Date: Thu, 22 Nov 2012 01:37:48 -0800 (PST)
From: metin d <metdos@yahoo.com>
Reply-To: metin d <metdos@yahoo.com>
Subject: Re: Problem in Page Cache Replacement
To: Johannes Weiner <hannes@cmpxchg.org>,
        Jaegeuk Hanse <jaegeuk.hanse@gmail.com>
Cc: Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        =?utf-8?B?TWV0aW4gRMO2xZ9sw7w=?= <metindoslu@gmail.com>
In-Reply-To: <20121122010959.GF24381@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

Yes, problem was as you projected. I tried to make "active" data-2 pages by manually reading them twice, and finally data-1 are got out of page cache.

We have large files in PostgreSQL and Hadoop that we sequentially scan over; and try to fit our working set into total memory. So I hope your patches will take place in the soonest linux kernel version.

Thanks,
Metin


----- Original Message -----
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>
Cc: Jan Kara <jack@suse.cz>; metin d <metdos@yahoo.com>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; linux-mm@kvack.org
Sent: Thursday, November 22, 2012 3:09 AM
Subject: Re: Problem in Page Cache Replacement

On Thu, Nov 22, 2012 at 08:48:07AM +0800, Jaegeuk Hanse wrote:
> On 11/22/2012 05:34 AM, Johannes Weiner wrote:
> >Hi,
> >
> >On Tue, Nov 20, 2012 at 07:25:00PM +0100, Jan Kara wrote:
> >>On Tue 20-11-12 09:42:42, metin d wrote:
> >>>I have two PostgreSQL databases named data-1 and data-2 that sit on the
> >>>same machine. Both databases keep 40 GB of data, and the total memory
> >>>available on the machine is 68GB.
> >>>
> >>>I started data-1 and data-2, and ran several queries to go over all their
> >>>data. Then, I shut down data-1 and kept issuing queries against data-2.
> >>>For some reason, the OS still holds on to large parts of data-1's pages
> >>>in its page cache, and reserves about 35 GB of RAM to data-2's files. As
> >>>a result, my queries on data-2 keep hitting disk.
> >>>
> >>>I'm checking page cache usage with fincore. When I run a table scan query
> >>>against data-2, I see that data-2's pages get evicted and put back into
> >>>the cache in a round-robin manner. Nothing happens to data-1's pages,
> >>>although they haven't been touched for days.
> >>>
> >>>Does anybody know why data-1's pages aren't evicted from the page cache?
> >>>I'm open to all kind of suggestions you think it might relate to problem.
> >This might be because we do not deactive pages as long as there is
> >cache on the inactive list.  I'm guessing that the inter-reference
> >distance of data-2 is bigger than half of memory, so it's never
> >getting activated and data-1 is never challenged.
> 
> Hi Johannes,
> 
> What's the meaning of "inter-reference distance"

It's the number of memory accesses between two accesses to the same
page:

  A B C D A B C E ...
    |_______|
    |       |

> and why compare it with half of memoy, what's the trick?

If B gets accessed twice, it gets activated.  If it gets evicted in
between, the second access will be a fresh page fault and B will not
be recognized as frequently used.

Our cutoff for scanning the active list is cache size / 2 right now
(inactive_file_is_low), leaving 50% of memory to the inactive list.
If the inter-reference distance for pages on the inactive list is
bigger than that, they get evicted before their second access.

