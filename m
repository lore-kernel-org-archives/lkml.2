Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab2DFVOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:14:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592Ab2DFVOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:14:49 -0400
Message-ID: <4F7F5CC1.3080107@redhat.com>
Date: Fri, 06 Apr 2012 17:14:41 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix page-faults detection in swap-token logic
References: <20110827083201.21854.56111.stgit@zurg> <20110829160637.bfc86e63.akpm@linux-foundation.org>
In-Reply-To: <20110829160637.bfc86e63.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2011 07:06 PM, Andrew Morton wrote:
> On Sat, 27 Aug 2011 12:32:01 +0300
> Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>
>> After commit v2.6.36-5896-gd065bd8 "mm: retry page fault when blocking on disk transfer"
>> we usually wait in page-faults without mmap_sem held, so all swap-token logic was broken,
>> because it based on using rwsem_is_locked(&mm->mmap_sem) as sign of in progress page-faults.
>
> If I'm interpreting this correctly, the thrash-handling logic has been
> effectively disabled for a year and nobody noticed.
>
>> This patch adds to mm_struct atomic counter of in progress page-faults for mm with swap-token.
>
> We desperately need to delete some code from mm/.  This seems like a
> great candidate.  Someone prove me wrong?

You are absolutely right.  The swap token code broke without
anyone noticing, and there is no good way to integrate it with
cgroups naturalization...

I'll send a patch to remove the swap token code.

-- 
All rights reversed
