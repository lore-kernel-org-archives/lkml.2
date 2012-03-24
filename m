Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab2CXPAJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 11:00:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50640 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab2CXPAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 11:00:07 -0400
Message-ID: <4F6DE172.7010604@openvz.org>
Date: Sat, 24 Mar 2012 19:00:02 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 00/16] mm: prepare for converting vm->vm_flags to 64-bit
References: <20120321065140.13852.52315.stgit@zurg>  <20120321100602.GA5522@barrios> <4F69D496.2040509@openvz.org>  <20120322053958.GA5278@barrios> <1332397358.2982.82.camel@pasglop> <4F6DDE56.3090401@openvz.org>
In-Reply-To: <4F6DDE56.3090401@openvz.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Khlebnikov wrote:
> Benjamin Herrenschmidt wrote:
>> On Thu, 2012-03-22 at 14:39 +0900, Minchan Kim wrote:
>>> I think we can also unify VM_MAPPED_COPY(nommu) and VM_SAO(powerpc)
>>> with one VM_ARCH_1
>>> Okay. After this series is merged, let's try to remove flags we can
>>> do. Then, other guys
>>> might suggest another ideas.
>>
>> Agreed. I would like more VM_ARCH while at it :-)
>
> Currently I see here four architecture-specific flags =)
>
> VM_ARCH_1 VM_ARCH_2 VM_ARCH_3 VM_ARCH_4
> x86 VM_NOHUGEPAGE VM_HUGEPAGE - VM_PFN_AT_MMAP
> powerpc - - VM_SAO -
> parisc VM_GROWSUP - - -
> ia64 VM_GROWSUP - - -
> nommu - VM_MAPPED_COPY - -
>
> Obviously we can combine VM_PFN_AT_MMAP, VM_SAO, VM_GROWSUP and VM_MAPPED_COPY into one.

Also logic and usage of VM_IO, VM_RESERVED, VM_PFNMAP, VM_MIXEDMAP,
VM_INSERTPAGE, VM_DONTEXPAND and VM_DONTCOPY are very messy.
I think some of them can be replaced with two flags:
VM_SPECIAL_PFN and VM_SPECIAL_PAGE, or something like this.
