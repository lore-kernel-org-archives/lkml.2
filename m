Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab1LIUox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 15:44:53 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:56523 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1LIUow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 15:44:52 -0500
Message-ID: <4EE27345.90003@gmail.com>
Date: Fri, 09 Dec 2011 15:44:53 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH] mm: simplify find_vma_prev
References: <1323461345-12805-1-git-send-email-kosaki.motohiro@gmail.com> <20111209122406.11f9e31a.akpm@linux-foundation.org>
In-Reply-To: <20111209122406.11f9e31a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This changes the (undocumented, naturally) interface in disturbing ways.
>
> Currently, *pprev will always be written to.  With this change, *pprev
> will only be written to if find_vma_prev() returns non-NULL.
>
> Looking through the code, this is mostly benign.  But it will cause the
> CONFIG_STACK_GROWSUP version of find_extend_vma() to use an
> uninitialised stack slot in ways which surely will crash the kernel.

Weird.


> So please have a think about that and fix it up.  And please add
> documentation for find_vma_prev()'s interface so we don't break it next
> time.

Sure thing. Thank you for good spotting!


