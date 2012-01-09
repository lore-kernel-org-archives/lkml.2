Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579Ab2AIXt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 18:49:56 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46337 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab2AIXtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 18:49:55 -0500
Message-ID: <4F0B7D1F.7040802@gmail.com>
Date: Mon, 09 Jan 2012 18:49:51 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH -mm] make swapin readahead skip over holes
References: <20120109181023.7c81d0be@annuminas.surriel.com>
In-Reply-To: <20120109181023.7c81d0be@annuminas.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(1/9/12 6:10 PM), Rik van Riel wrote:
> Ever since abandoning the virtual scan of processes, for scalability
> reasons, swap space has been a little more fragmented than before.
> This can lead to the situation where a large memory user is killed,
> swap space ends up full of "holes" and swapin readahead is totally
> ineffective.
>
> On my home system, after killing a leaky firefox it took over an
> hour to page just under 2GB of memory back in, slowing the virtual
> machines down to a crawl.
>
> This patch makes swapin readahead simply skip over holes, instead
> of stopping at them.  This allows the system to swap things back in
> at rates of several MB/second, instead of a few hundred kB/second.

If I understand correctly, this patch have

Pros
  - increase IO throughput
Cons
  - increase a risk to pick up unrelated swap entries by swap readahead


The changelog explained former but doesn't explained latter. I'm a bit
hesitate now.
