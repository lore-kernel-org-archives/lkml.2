Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761992Ab0J2Usc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:48:32 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:9064 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758328Ab0J2Usb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:48:31 -0400
Message-ID: <4CCB331F.6070507@caviumnetworks.com>
Date: Fri, 29 Oct 2010 13:48:31 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: rostedt@goodmis.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        akpm@linux-foundation.org, fweisbec@gmail.com, jbaron@redhat.com
Subject: Re: [PATCH 4/8] jump label: Make arch_jump_label_text_poke_early()
 optional
References: <20101028135548.055490014@goodmis.org>	<20101028135647.822609872@goodmis.org> <20101029.133759.48489968.davem@davemloft.net>
In-Reply-To: <20101029.133759.48489968.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2010 20:49:01.0402 (UTC) FILETIME=[B75333A0:01CB77AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2010 01:37 PM, David Miller wrote:
> From: Steven Rostedt<rostedt@goodmis.org>
> Date: Thu, 28 Oct 2010 09:55:52 -0400
>
>> From: David Daney<ddaney@caviumnetworks.com>
>>
>> For the forthcoming MIPS jump label support,
>> arch_jump_label_text_poke_early() is unneeded as the MIPS NOP
>> instruction is already optimal.
>>
>> Supply a default implementation that does nothing.  Flag x86 and SPARC
>> as having arch_jump_label_text_poke_early().
>>
>> Cc: Jason Baron<jbaron@redhat.com>
>> Cc: David Miller<davem@davemloft.net>
>> Signed-off-by: David Daney<ddaney@caviumnetworks.com>
>> LKML-Reference:<1286218615-24011-2-git-send-email-ddaney@caviumnetworks.com>
>> Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
>
> On the SPARC side, it's not that the nop isn't optimal, on sparc it's
> always 0x01000000.

That's what I thought.  You could remove your
arch_jump_label_text_poke_early() function to no determent.

> The issue is that when written an I-cache flush is
> necessary using a 'flushi' instruction.
>
> Does MIPS not need a flush when poking instructions?

Yes, it does.

> I find this hard to believe, although it's been some time since I
> last touched that architecture :-)

I just looked at my patch again.  I am indeed flushing the I cache
after patching the code, so I don't really know what you are talking
about.

David Daney
