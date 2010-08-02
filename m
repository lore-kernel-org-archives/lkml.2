Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab0HBEic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 00:38:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39747 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab0HBEia convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 00:38:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EG7Uu8ake7Nf1ltnIrUANywnHeepLP0OboLTWTBkXmQTA+0WKUkavYX2OAgJznMAEF
         sOktEiqhQAOyuNsX7G2J6M5PasFL4XvMujIwpCWDxi87ZmUJKtVGZSc5ap1yxzgwMr/1
         5PhHSZg2E1+vc6pqrqcLDoJA89agCU6ixlPD8=
MIME-Version: 1.0
In-Reply-To: <20100802131016.4F7D.A69D9226@jp.fujitsu.com>
References: <20100801180751.4B0E.A69D9226@jp.fujitsu.com>
	<20100801134117.GA2034@barrios-desktop>
	<20100802131016.4F7D.A69D9226@jp.fujitsu.com>
Date: Mon, 2 Aug 2010 13:38:29 +0900
Message-ID: <AANLkTinqDTy1S+DvKaCCQQ7bA7E-XZ-3S0Xx6c64EvGb@mail.gmail.com>
Subject: Re: [PATCH] vmscan: synchronous lumpy reclaim don't call 
	congestion_wait()
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Andy Whitcroft <apw@shadowen.org>, Rik van Riel <riel@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Andreas Mohr <andi@lisas.de>,
        Bill Davidsen <davidsen@tmr.com>, Ben Gamari <bgamari.foss@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 1:13 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> Hi KOSAKI,
>>
>> On Sun, Aug 01, 2010 at 06:12:47PM +0900, KOSAKI Motohiro wrote:
>> > rebased onto Wu's patch
>> >
>> > ----------------------------------------------
>> > From 35772ad03e202c1c9a2252de3a9d3715e30d180f Mon Sep 17 00:00:00 2001
>> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> > Date: Sun, 1 Aug 2010 17:23:41 +0900
>> > Subject: [PATCH] vmscan: synchronous lumpy reclaim don't call congestion_wait()
>> >
>> > congestion_wait() mean "waiting for number of requests in IO queue is
>> > under congestion threshold".
>> > That said, if the system have plenty dirty pages, flusher thread push
>> > new request to IO queue conteniously. So, IO queue are not cleared
>> > congestion status for a long time. thus, congestion_wait(HZ/10) is
>> > almostly equivalent schedule_timeout(HZ/10).
>> Just a nitpick.
>> Why is it a problem?
>> HZ/10 is upper bound we intended.  If is is rahter high, we can low it.
>> But totally I agree on this patch. It would be better to remove it
>> than lowing.
>
> because all of _unnecessary_ sleep is evil. the problem is, congestion_wait()
> mean "wait until queue congestion will be cleared, iow, wait all of IO".
> but we want to wait until _my_ IO finished.
>
> So, if flusher thread conteniously push new IO into the queue, that makes
> big difference.
>

Agree. Please include this explanation in description to make it kind
if you resent this patch.
Thanks


-- 
Kind regards,
Minchan Kim
