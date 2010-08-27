Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab0H0CC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 22:02:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57100 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab0H0CCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 22:02:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=isCyB3kzKHJiD6L1iXkgvijTULTFxHBI/Jnh2rkK5xtyxAt8F1+qbrd1noJ2BshVPa
         g8yOtckfQ0+7ANHlLxmF5BNNlgDgMEvskmVEj99YqYfAj1glHApQJq/uvYAjmTmOiyTR
         v1yR0Xr26NA7UXWkpHbXbqIceOFeBYhB7YKQI=
MIME-Version: 1.0
In-Reply-To: <20100827015041.GF7353@localhost>
References: <1282835656-5638-1-git-send-email-mel@csn.ul.ie>
	<20100826172038.GA6873@barrios-desktop>
	<20100827012147.GC7353@localhost>
	<AANLkTimLhZcP=eqB9TFfO_rgb-dhXUJh8iNTXuceuCq0@mail.gmail.com>
	<20100827015041.GF7353@localhost>
Date: Fri, 27 Aug 2010 11:02:52 +0900
Message-ID: <AANLkTin0PZu=ceoeyYa6qSv_piHL1yrfyEgTw35=gnex@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Do not wait the full timeout on congestion_wait
 when there is no congestion
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Li, Shaohua" <shaohua.li@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 10:50 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Fri, Aug 27, 2010 at 09:41:48AM +0800, Minchan Kim wrote:
>> Hi, Wu.
>>
>> On Fri, Aug 27, 2010 at 10:21 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> > Minchan,
>> >
>> > It's much cleaner to keep the unchanged congestion_wait() and add a
>> > congestion_wait_check() for converting problematic wait sites. The
>> > too_many_isolated() wait is merely a protective mechanism, I won't
>> > bother to improve it at the cost of more code.
>>
>> You means following as?
>
> No, I mean do not change the too_many_isolated() related code at all :)
> And to use congestion_wait_check() in other places that we can prove
> there is a problem that can be rightly fixed by changing to
> congestion_wait_check().

I always suffer from understanding your comment.
Apparently, my eyes have a problem. ;(

This patch is dependent of Mel's series.
With changing congestion_wait with just return when no congestion, it
would have CPU hogging in too_many_isolated. I think it would apply in
Li's congestion_wait_check, too.
If no change is current congestion_wait, we doesn't need this patch.

Still, maybe I can't understand your comment. Sorry.
-- 
Kind regards,
Minchan Kim
