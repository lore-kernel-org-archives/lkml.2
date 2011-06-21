Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab1FUUCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:02:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab1FUUB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:01:59 -0400
Message-ID: <4E00F88F.2080603@redhat.com>
Date: Tue, 21 Jun 2011 16:01:19 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: Andrea Arcangeli <aarcange@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: completely disable THP by transparent_hugepage=never
References: <1308587683-2555-1-git-send-email-amwang@redhat.com> <20110620165844.GA9396@suse.de> <4DFF7E3B.1040404@redhat.com> <4DFF7F0A.8090604@redhat.com> <4DFF8106.8090702@redhat.com> <4DFF8327.1090203@redhat.com> <4DFF84BB.3050209@redhat.com> <4DFF8848.2060802@redhat.com> <20110620182558.GF4749@redhat.com> <20110620192117.GG20843@redhat.com> <4E00192E.70901@redhat.com>
In-Reply-To: <4E00192E.70901@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2011 12:08 AM, Cong Wang wrote:

> The thing is that we can save ~10K by adding 3 lines of code as this
> patch showed, where else in kernel can you save 10K by 3 lines of code?
> (except some kfree() cases, of course) So, again, why not have it? ;)

Because we'll end up with hundreds of lines of code, just
to save under 1MB of memory.  Which ends up not being saved
at all, because people will still give their kdump kernel
128MB :)

The only really big gain you are likely to get is making
sure all the per-cpu memory is not allocated in the kdump
kernel (which is booted with 1 cpu).

That is a big, multi-MB, optimization that can be implemented
in one place.  Large savings for a localized change, so you
actually have a chance of having the changes accepted upstream.

-- 
All rights reversed
