Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab0E0OLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:11:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756880Ab0E0OLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:11:39 -0400
Message-ID: <4BFE7CFC.4060706@redhat.com>
Date: Thu, 27 May 2010 10:09:00 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>,
       Andrea Arcangeli <aarcange@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH 5/5] extend KSM refcounts to the anon_vma root
References: <20100526153819.6e5cec0d@annuminas.surriel.com> <20100526154124.04607d04@annuminas.surriel.com> <20100527140212.GE2112@barrios-desktop>
In-Reply-To: <20100527140212.GE2112@barrios-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2010 10:02 AM, Minchan Kim wrote:

> Hmm, I can understand this point.
> Now, rmap code always depeneds on root anon_vma's lock.
> I think it doesn't depends on KSM and MIGRATION.
>
> If we don't use KSM and MIGRATION and it is compiled out,
> Can root's anon_vma disappear during rmap walking?
> who prevent it?
>
> What am I missing?

unlink_anon_vmas walks the list in the order from newest
to oldest, ie. the root always gets unlinked (and potentially
freed) last.

-- 
All rights reversed
