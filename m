Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab0DWJtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 05:49:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756869Ab0DWJtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 05:49:21 -0400
Message-ID: <4BD16D09.2030803@redhat.com>
Date: Fri, 23 Apr 2010 12:48:57 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
       hugh.dickins@tiscali.co.uk, ngupta@vflare.org, JBeulich@novell.com,
       chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, npiggin@suse.de, akpm@linux-foundation.org,
       riel@redhat.com
Subject: Re: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
References: <20100422134249.GA2963@ca-server1.us.oracle.com> <4BD06B31.9050306@redhat.com> <53c81c97-b30f-4081-91a1-7cef1879c6fa@default 4BD07594.9080905@redhat.com> <b1036777-129b-4531-a730-1e9e5a87cea9@default>
In-Reply-To: <b1036777-129b-4531-a730-1e9e5a87cea9@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2010 11:15 PM, Dan Magenheimer wrote:
>>
>> Much easier to simulate an asynchronous API with a synchronous backend.
>>      
> Indeed.  But an asynchronous API is not appropriate for frontswap
> (or cleancache).  The reason the hooks are so simple is because they
> are assumed to be synchronous so that the page can be immediately
> freed/reused.
>    

Swapping is inherently asynchronous, so we'll have to wait for that to 
complete anyway (as frontswap does not guarantee swap-in will succeed).  
I don't doubt it makes things simpler, but also less flexible and useful.

Something else that bothers me is the double swapping.  Sure we're 
making swapin faster, but we we're still loading the io subsystem with 
writes.  Much better to make swap-to-ram authoritative (and have the 
hypervisor swap it to disk if it needs the memory).

>> Well, copying memory so you can use a zero-copy dma engine is
>> counterproductive.
>>      
> Yes, but for something like an SSD where copying can be used to
> build up a full 64K write, the cost of copying memory may not be
> counterproductive.
>    

I don't understand.  Please clarify.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

