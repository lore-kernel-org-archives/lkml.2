Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab1BBXIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 18:08:22 -0500
Received: from lo.gmane.org ([80.91.229.12]:43302 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268Ab1BBXIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 18:08:21 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: ARM unaligned MMIO access with attribute((packed))
Date: Wed, 02 Feb 2011 23:08:01 +0000
Message-ID: <yw1xei7qm3vy.fsf@unicorn.mansr.com>
References: <201102021700.20683.arnd@arndb.de>
 <20110202163702.GA23240@n2100.arm.linux.org.uk>
 <20110202.133831.193702414.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: unicorn.mansr.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (garbanzo, linux)
Cancel-Lock: sha1:QMWNlAEstw0uKN7aMC7o5dVqpGc=
Cc: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        gcc@gcc.gnu.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Date: Wed, 2 Feb 2011 16:37:02 +0000
>
>> 1. there's no way to tell GCC that the inline assembly is a load
>>    instruction and therefore it needs to schedule the following
>>    instructions appropriately.
>
> Just add a dummy '"m" (pointer)' asm input argument to the inline asm
> statement.  Just make sure "typeof(pointer)" has a size matching the
> size of the load your are performing.

That should be "m"(*pointer).

>> 2. GCC will needlessly reload pointers from structures and other such
>>    behaviour because it can't be told clearly what the inline assembly
>>    is doing, so the inline asm needs to have a "memory" clobber.
>
> This behavior is correct, and in fact needed.  Writing to chip registers
> can trigger changes to arbitrary main memory locations.
>
>> 3. It seems to misses out using the pre-index addressing, prefering to
>>    create add/sub instructions prior to each inline assembly load/store.
>
> Yes, this is indeed a problem.

GCC has trouble doing anything more complicated than simple indexing.
Load/store instructions with writeback seem not to be in its
vocabulary at all.

> But you really need that memory clobber there whether you like it or
> not, see above.

I don't know of any device where the side-effects are not explicitly
indicated by other means in the code triggering them, so it probably
is safe without the clobber as Russel says.

-- 
Måns Rullgård
mans@mansr.com

