Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab2HFCPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 22:15:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab2HFCPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 22:15:38 -0400
Message-ID: <501F20BC.2030107@redhat.com>
Date: Sun, 05 Aug 2012 21:41:16 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: peterz@infradead.org, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v2 6/9] rbtree: low level optimizations in rb_erase()
References: <1343946858-8170-1-git-send-email-walken@google.com> <1343946858-8170-7-git-send-email-walken@google.com>
In-Reply-To: <1343946858-8170-7-git-send-email-walken@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 06:34 PM, Michel Lespinasse wrote:
> Various minor optimizations in rb_erase():
> - Avoid multiple loading of node->__rb_parent_color when computing parent
>    and color information (possibly not in close sequence, as there might
>    be further branches in the algorithm)
> - In the 1-child subcase of case 1, copy the __rb_parent_color field from
>    the erased node to the child instead of recomputing it from the desired
>    parent and color
> - When searching for the erased node's successor, differentiate between
>    cases 2 and 3 based on whether any left links were followed. This avoids
>    a condition later down.
> - In case 3, keep a pointer to the erased node's right child so we don't
>    have to refetch it later to adjust its parent.
> - In the no-childs subcase of cases 2 and 3, place the rebalance assigment
>    last so that the compiler can remove the following if(rebalance) test.
>
> Also, added some comments to illustrate cases 2 and 3.
>
> Signed-off-by: Michel Lespinasse<walken@google.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
