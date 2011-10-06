Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935629Ab1JFARp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 20:17:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45643 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935580Ab1JFARo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 20:17:44 -0400
Message-ID: <4E8CF385.2080804@zytor.com>
Date: Wed, 05 Oct 2011 17:17:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been initialized,
 don't nop it out
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com> <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com> <20111003150205.GB2462@redhat.com> <4E89E28C.7010700@goop.org> <20111004141011.GA2520@redhat.com> <4E8B3489.60902@zytor.com> <4E8CF348.4080405@goop.org>
In-Reply-To: <4E8CF348.4080405@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2011 05:16 PM, Jeremy Fitzhardinge wrote:
> On 10/04/2011 09:30 AM, H. Peter Anvin wrote:
>> On 10/04/2011 07:10 AM, Jason Baron wrote:
>>> 1) The jmp +0, is a 'safe' no-op that I know is going to initially
>>> boot for all x86. I'm not sure if there is a 5-byte nop that works on
>>> all x86 variants - but by using jmp +0, we make it much easier to debug
>>> cases where we may be using broken no-ops.
>>>
>> There are *plenty*.  jmp+0 is about as pessimal as you can get.
> 
> As an aside, do you know if a 2-byte unconditional jmp is any more
> efficient than 5-byte, aside from just being a smaller instruction and
> taking less icache?
> 

I don't know for sure, no.  I probably depends on the CPU.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

