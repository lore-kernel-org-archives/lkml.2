Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab0GYQkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 12:40:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38750 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab0GYQkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 12:40:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QZ1AeCbKTsalNiEY/uj0YGv4ej77+h0BYflCPC+yLL2gxHxElAC89MAh4db6QxItzJ
         Ez//m2rooXjg/TkwkqESqKbrd6pMMkvAtvPfnSrysI4NGdAC9ozoJ1bQRzkX2vHtmY5n
         JN6XlU+ERDE6w/hA5O2r8GHTPmstEsbo+wFBQ=
MIME-Version: 1.0
In-Reply-To: <20100725184322.40CF.A69D9226@jp.fujitsu.com>
References: <20100723154638.88C8.A69D9226@jp.fujitsu.com>
	<AANLkTikpZ8iH1oO1k84kvo2qYYS96LYuNmmw6xJL-1QV@mail.gmail.com>
	<20100725184322.40CF.A69D9226@jp.fujitsu.com>
Date: Sun, 25 Jul 2010 22:10:12 +0530
X-Google-Sender-Auth: _nM3u37rlU-0Zl27RFrWwGWKjS8
Message-ID: <AANLkTinD8=XycQJ-yFBW_tJiE0kH70s2g2asfWtykEgL@mail.gmail.com>
Subject: Re: [PATCH 1/7] memcg: sc.nr_to_reclaim should be initialized
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 25, 2010 at 3:18 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> >> 1. How far does this push pages (in terms of when limit is hit)?
>> >
>> > 32 pages per mem_cgroup_shrink_node_zone().
>> >
>> > That said, the algorithm is here.
>> >
>> > 1. call mem_cgroup_largest_soft_limit_node()
>> >   calculate largest cgroup
>> > 2. call mem_cgroup_shrink_node_zone() and shrink 32 pages
>> > 3. goto 1 if limit is still exceed.
>> >
>> > If it's not your intention, can you please your intended algorithm?
>>
>> We set it to 0, since we care only about a single page reclaim on
>> hitting the limit. IIRC, in the past we saw an excessive pushback on
>> reclaiming SWAP_CLUSTER_MAX pages, just wanted to check if you are
>> seeing the same behaviour even now after your changes.
>
> Actually, we have 32 pages reclaim batch size. (see nr_scan_try_batch() and related functions)
> thus <32 value doesn't works as your intended.
>
> But, If you run your test again, and (if there is) report any bugs. I'm very glad and fix it soon.
>

I understand that, the point is when to do stop the reclaim (do we
really need 32 pages to stop the reclaim, when we hit the limit,
something as low as a single page can help).  This is quite a subtle
thing, I'd mark it as low priority. I'll definitely come back if I see
unexpected behaviour.

Balbir
