Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab0DFOgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 10:36:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab0DFOgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 10:36:13 -0400
Message-ID: <4BBB466D.3090705@redhat.com>
Date: Tue, 06 Apr 2010 10:34:21 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Minchan Kim <minchan.kim@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 2.6.34-rc3)
References: <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org> <20100406173754.7E5A.A69D9226@jp.fujitsu.com> <20100406190036.7E66.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100406190036.7E66.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 06:09 AM, KOSAKI Motohiro wrote:
>> (b) is also impossible. SLAB_DESTROY_BY_RCU delay the page for anon_vma
>> freeing until next rcu period. It mean rcu_read_lock()+page_mapped()
>> can see kfree()ed page. but it is safe. noone corrupt it.
>
> by the way: I haven't understand why rik's per process anon_vma concept
> works correctly with ksm. ksm increase anon_vma->ksm_refcount. but it seems
> not guranteed vma->anon_vma and page->anon_vma are the same.

KSM removes the page from its original anon_vma.

If the page gets reinstantiated (copy on write), it will be
created in the vma->anon_vma.

Am I overlooking something?
