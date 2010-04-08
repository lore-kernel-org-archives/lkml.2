Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab0DHS0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:26:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758895Ab0DHS0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:26:51 -0400
Message-ID: <4BBE1F92.3060802@redhat.com>
Date: Thu, 08 Apr 2010 14:25:22 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Borislav Petkov <bp@alien8.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
References: <alpine.LFD.2.00.1004071505510.3586@i5.linux-foundation.org> <alpine.LFD.2.00.1004071625490.3586@i5.linux-foundation.org> <20100408101925.FB9F.A69D9226@jp.fujitsu.com> <alpine.LFD.2.00.1004071929090.3586@i5.linux-foundation.org> <20100408054707.GA9299@a1.tnic> <alpine.LFD.2.00.1004080706500.3586@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004080706500.3586@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 10:11 AM, Linus Torvalds wrote:
>
>
> On Thu, 8 Apr 2010, Borislav Petkov wrote:
>>
>> There are still issues: vma_adjust() grabs mapping->i_mmap_lock for file
>> mappings while we might sleep in anon_vma_prepare():
>
> Ahh. Good catch. So I can't actually do that anon_vma_prepare() thing in
> __insert_vm_struct.
>
> It should be simple enough to just move it into the caller, just after it
> releases that lock. There's only one user of that __insert_vm_struct()
> anyway. You can do it yourself, or you can replace my previous patch with
> this..
>
> [ The patch below also makes it warn once and return SIGBUS for the case
>    where there is no anon_vma.  I decided I still want to hear about it if
>    there might be some path that tries to insert a vma on its own ]

Reviewed-by: Rik van Riel <riel@redhat.com>

I haven't seen any places that insert VMAs by itself.
Several strange places that allocate them, but they
all appear to use the standard functions to insert them.
