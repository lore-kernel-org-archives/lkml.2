Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab0HZJ3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:29:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33637 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab0HZJ3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:29:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lxCkRYPnqVfOmSaqAcly8GnKYlEe15Pb0TmrHBqiXtsfDGxctVKAN9Ru5aA8G99gyu
         gRXiOXFmKlFLj9g35hctvUnpt/imKlOh9wFUCeRIOkohNkPJgmn7R+0PejhGjOhqJeYz
         BIftd8jFQ12e3UUZxhVM8epa95EOdxTcJtLm0=
MIME-Version: 1.0
In-Reply-To: <1282810811.1975.246.camel@laptop>
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
	<1282310110.2605.976.camel@laptop>
	<20100825155814.25c783c7.akpm@linux-foundation.org>
	<20100825173125.0855a6b0@bike.lwn.net>
	<AANLkTinPaq+0MbdW81uoc5_OZ=1Gy_mVYEBnwv8zgOBd@mail.gmail.com>
	<1282810811.1975.246.camel@laptop>
Date: Thu, 26 Aug 2010 18:29:21 +0900
Message-ID: <AANLkTin7EBZw0-WY=NGOmYzZT5Cfy7oWVFBaT2cjK+vZ@mail.gmail.com>
Subject: Re: [PATCH/RFCv4 0/6] The Contiguous Memory Allocator framework
From: Minchan Kim <minchan.kim@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>, linux-mm@kvack.org,
        Daniel Walker <dwalker@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 5:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-08-26 at 11:49 +0900, Minchan Kim wrote:
>> But one of
>> problems is anonymous page which can be has a role of pinned page in
>> non-swapsystem.
>
> Well, compaction can move those around, but if you've got too many of
> them its a simple matter of over-commit and for that we've got the
> OOM-killer ;-)
>

As I said following mail, I said about free space problem.
Of course, compaction could move anon pages into somewhere.
What's is somewhere? At last, it's same zone.
It can prevent fragment problem but not size of free space.
So I mean it would be better to move it into another zone(ex, HIGHMEM)
rather than OOM kill.

-- 
Kind regards,
Minchan Kim
