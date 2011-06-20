Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab1FTRuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:50:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab1FTRug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:50:36 -0400
Message-ID: <4DFF8848.2060802@redhat.com>
Date: Mon, 20 Jun 2011 13:50:00 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: completely disable THP by transparent_hugepage=never
References: <1308587683-2555-1-git-send-email-amwang@redhat.com> <20110620165844.GA9396@suse.de> <4DFF7E3B.1040404@redhat.com> <4DFF7F0A.8090604@redhat.com> <4DFF8106.8090702@redhat.com> <4DFF8327.1090203@redhat.com> <4DFF84BB.3050209@redhat.com>
In-Reply-To: <4DFF84BB.3050209@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2011 01:34 PM, Cong Wang wrote:

> Even if it is really 10K, why not save it since it doesn't
> much effort to make this. ;) Not only memory, but also time,
> this could also save a little time to initialize the kernel.
>
> For me, the more serious thing is the logic, there is
> no way to totally disable it as long as I have THP in .config
> currently. This is why I said the design is broken.

There are many things you cannot totally disable as long
as they are enabled in the .config.  Think about things
like swap, or tmpfs - neither of which you are going to
use in the crashdump kernel.

I believe we need to keep the kernel optimized for common
use and convenience.

Crashdump is very much a corner case.  Yes, using less
memory in crashdump is worthwhile, but lets face it -
the big memory user there is likely to be the struct page
array, with everything else down in the noise...
