Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab0CVOKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:10:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935Ab0CVOKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:10:08 -0400
Message-ID: <4BA77A86.2040109@redhat.com>
Date: Mon, 22 Mar 2010 10:11:18 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/10] Move Macro W to insn.h
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6> <20100320142505.11427.30133.sendpatchset@localhost6.localdomain6> <4BA4EEAE.10202@redhat.com> <20100322062450.GD30463@linux.vnet.ibm.com>
In-Reply-To: <20100322062450.GD30463@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srikar Dronamraju wrote:
> * Masami Hiramatsu <mhiramat@redhat.com> [2010-03-20 11:50:06]:
> 
>> Srikar Dronamraju wrote:
>>> Move Macro W to asm/insn.h
>>>
>>> Macro W used to know if the instructions are valid for
>>> user-space/kernel space.  This macro is used by kprobes and
>>> user_bkpt. (i.e user space breakpoint assistance layer.) So moving it
>>> to a common header file asm/insn.h.
>>
>> Hmm, I don't think this shortest macro name is good to expose
>> commonly... And also, since we already have inat (instruction
>> attribute) table, we'd better expand an inat bit to indicate
>> which instruction can be probed/boosted.
>>
> 
> Guess we would need three bits, 
> - Instruction can be probed in kernel.

Currently, we don't have any maps for this bit.

> - Instruction can be probed in user space.
> - Instruction can be boosted.

Other two bits are ok for me :)

Thank you,

> 
> Or do you have other ideas?
> 
> --
> Thanks and Regards
> Srikar

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com

