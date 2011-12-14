Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab1LNRRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:17:16 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:9345 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab1LNRRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:17:07 -0500
Message-ID: <4EE8DA11.5020109@cavium.com>
Date: Wed, 14 Dec 2011 09:17:05 -0800
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: David Daney <ddaney.cavm@gmail.com>, ralf@linux-mips.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] jump-label: initialize jump-label subsystem somewhat
 later
References: <1323881315-23245-1-git-send-email-ddaney.cavm@gmail.com> <1323881470.28489.51.camel@twins>
In-Reply-To: <1323881470.28489.51.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Dec 2011 17:17:06.0203 (UTC) FILETIME=[34410EB0:01CCBA84]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 08:51 AM, Peter Zijlstra wrote:
> On Wed, 2011-12-14 at 08:48 -0800, David Daney wrote:
>> From: David Daney<david.daney@cavium.com>
>>
>> commit 97ce2c88f9ad42e3c60a9beb9fca87abf3639faa breaks MIPS.
>>
>> The jump-lable initialization does I-Cache flushing after modifying
>> code.  On MIPS this is done by calling through the function pointer
>> flush_icache_range().  This function pointer is initialized mm_init().

Actually I misspoke, for MIPS we need jump_label_init() after 
trap_init(), not mm_init().

>>
>> As things stand, we cannot be calling jump_label_init() until after
>> mm_init() completes, so we move the call down to satisfy this
>> constraint.
>
> I'm fine as long as it stays before sched_init(), which it does. Jeremy
> is this still early enough for you?
>

Just tested a revised patch that moves it to between trap_init() and 
mm_init(), I propose that we do that instead.

New patch in a couple of minutes.

David Daney
