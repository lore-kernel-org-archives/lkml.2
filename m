Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319Ab1DTRxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 13:53:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab1DTRxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 13:53:46 -0400
Message-ID: <4DAF1DA7.9040705@redhat.com>
Date: Wed, 20 Apr 2011 13:53:43 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: rwhitton@iee.org
CC: linux-kernel@vger.kernel.org
Subject: Re: Background memory scrubbing
References: <20131.1303319102@jupiter.eclipse.co.uk>
In-Reply-To: <20131.1303319102@jupiter.eclipse.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2011 01:05 PM, Robert Whitton wrote:
> On Wed 20/04/11  6:45 PM , Rik van Riel<riel@redhat.com>  wrote:
>> On 04/20/2011 03:58 AM, Robert Whitton wrote:
>>
>>> for each PFN from 256 to the highest valid PFN
>>> {
>>> if (pfn_valid(PFN))
>>> {
>>> page = pfn_to_page(PFN)
>>> va = kmap(page)
>>> atomic_scrub(va, PAGE_SIZE)
>>> kunmap(page)
>>> }
>>>
>>> sleep(for_a_while)
>>> }
>>
>> What exactly does atomic_scrub do?
>
> atomic_scrub is part of the edac subsystem see arch/x86/include/asm/edac.h. It simply does a locked add of zero to each DWORD in the specified range.

I can think of only a few ways in which that could cause a
kernel page fault.

One of the more obvious causes would be running into an
area of kernel memory that is mapped read-only.  Writing
to a page that is mapped read-only would cause a page
fault :)

Walking the page tables to check whether my guess is correct
should be possible in the current context.  Look at current->mm->pgd for 
the page directory and start walking from there.

Incidentally, the kernel mappings should be the same for any
process, so the above should hold true from any context.
