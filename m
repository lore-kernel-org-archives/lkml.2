Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab1FOQY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:24:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab1FOQY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:24:28 -0400
Message-ID: <4DF8DCB8.9050103@redhat.com>
Date: Wed, 15 Jun 2011 12:24:24 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kyle McMartin <kyle@redhat.com>
Subject: Re: SLUB BUG: check_slab called with interrupts enabled
References: <4DF8C80F.7090403@redhat.com> <alpine.DEB.2.00.1106150959500.768@router.home> <4DF8CCE1.80400@redhat.com> <alpine.DEB.2.00.1106151040020.768@router.home>
In-Reply-To: <alpine.DEB.2.00.1106151040020.768@router.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2011 11:45 AM, Christoph Lameter wrote:
> On Wed, 15 Jun 2011, Rik van Riel wrote:
>
>> > There are no additional special slub patches applied right? Because
>> some
>> > of the patches under discussion change the interrupt disable handling a
>> > bit.
>>
>> Just the two attached ones, which don't seem to touch the
>> code path in question...
>
> I also do not see how these could break something. But they are mucking
> around with the __GFP_WAIT flag. __GFP_WAIT determines the reenabling and
> redisabling of interrupts in __slab_alloc(). If some variables gets
> corrupted then this could be the result.
>
> Print out the value of gfpflags before and after the call to new_slab()
> from __slab_alloc()?

Since I'm building a new kernel anyway (with Neil Horman's
patch to make netconsole work with tun/tap), I have commented
out these two slub patches.

Lets see what happens...

-- 
All rights reversed
