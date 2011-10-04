Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab1JDQbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:31:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34592 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932466Ab1JDQbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:31:09 -0400
Message-ID: <4E8B3489.60902@zytor.com>
Date: Tue, 04 Oct 2011 09:30:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com> <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com> <20111003150205.GB2462@redhat.com> <4E89E28C.7010700@goop.org> <20111004141011.GA2520@redhat.com>
In-Reply-To: <20111004141011.GA2520@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2011 07:10 AM, Jason Baron wrote:
> 
> 1) The jmp +0, is a 'safe' no-op that I know is going to initially
> boot for all x86. I'm not sure if there is a 5-byte nop that works on
> all x86 variants - but by using jmp +0, we make it much easier to debug
> cases where we may be using broken no-ops.
> 

There are *plenty*.  jmp+0 is about as pessimal as you can get.

The current recommendation when you don't know the CPU you're running at is:

	3E 8D 74 26 00	(GENERIC_NOP5_ATOMIC)

... on 32 bits and ...

	0F 1F 44 00 00	(P6_NOP5_ATOMIC)

... on 64 bits.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

