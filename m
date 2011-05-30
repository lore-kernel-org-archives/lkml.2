Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1E3LEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 07:04:33 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:51848 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332Ab1E3LEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 07:04:32 -0400
X-AuditID: 1209190f-b7c4dae0000007bd-ca-4de379c287f9
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20110530105809.GA20133@elte.hu>
Date: Mon, 30 May 2011 07:04:27 -0400
Cc: David Woodhouse <dwmw2@infradead.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
References: <1306707270.2029.377.camel@i7.infradead.org> <20110530072300.GA9802@elte.hu> <1306745835.2029.389.camel@i7.infradead.org> <20110530104231.GF17821@elte.hu> <20110530104656.GA19532@elte.hu> <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu> <20110530105809.GA20133@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.1084)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsUixCmqrXuo8rGvQftnCYuJKyczW1zeNYfN
	YsulZlaLHxseszqweNxq+8PssXmFlsemVZ1sHp83yQWwRHHZpKTmZJalFunbJXBlfF57ma3g
	G2fF8ZUzmBoYX7B3MXJySAiYSFzt38MKYYtJXLi3nq2LkYtDSGAfo8T+U22sEM4GRonvX3vA
	qoQETjNJzP7PB2ILC3hIzJ90lAnE5hUwlFi6qR1sKrOAlsSNfy/B4mwCShJ3Pu1nAbE5BXQl
	Nna/ZgaxWQRUJa682c8EUZ8gcfzcFzYIW15i+9s5zBAzrSQ+bOqHumg6k8TLHUfAGkSAivYc
	+wJ0EAfQ2bISTcsyJjAKzkJyxiwkZ8xCMnYBI/MqRtmU3Crd3MTMnOLUZN3i5MS8vNQiXRO9
	3MwSvdSU0k2M4CCX5N/B+O2g0iFGAQ5GJR5ey6JHvkKsiWXFlbmHGCU5mJREeVeXPPYV4kvK
	T6nMSCzOiC8qzUktPsQowcGsJMKbmAiU401JrKxKLcqHSUlzsCiJ886SVPcVEkhPLEnNTk0t
	SC2CycpwcChJ8P6vAGoULEpNT61Iy8wpQUgzcXCCDOcBGr4SpIa3uCAxtzgzHSJ/ilGX4/ra
	rQcZhVjy8vNSpcR5f4AUCYAUZZTmwc2BJadXjOJAbwnzSgJTlRAPMLHBTXoFtIQJaEnvu4cg
	S0oSEVJSDYz5b/ffYk2cJii+vq568UvB40nTgra91t4X/ajwVLhu4LWHida/Zr0Ntp/tp16T
	0qZmYKNe+err0oO6j2W/zPjt/fCTtIiK3vmJtofl973c2/bNdOJ72dCHH0uU5vco/++80+NS
	Gqsm9N/UfusckRszZmrc+n2uxmxT5t6wG6nacWsb8iLn3w1TYinOSDTUYi4qTgQAtTYEMykD
	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 30, 2011, at 6:58 AM, Ingo Molnar wrote:

> 
> * Theodore Tso <tytso@MIT.EDU> wrote:
> 
>> I'd think that "make ARCH=x86_64 oldconfig"
>> 
>> ... where the old configuration contained CONFIG_X86_32
>> should trigger a warning, if not an outright error that 
>> stops the build....
> 
> That would be a rather sad regression for me: i use that command 
> regularly to transform .configs that came in bugreports into a config 
> suitable for a testbox that has a different bitness userspace 
> installed.

OK, so to clarify, what you want is for ARCH=xxx to always override
whatever is in .config?  Are we all on the same page here?  I thought
David was arguing that what was in .config should always be more
important, since he regards "ARCH=xxxx" as "legacy".

Or maybe I'm missing something here.... since people seem to be slinging
around examples what should or should not work, as opposed to 
simply saying, "ARCH=xxx" must always override all else, even in 
cases like "oldconfig", "randconfig", etc.  Is that what the patch
is going to do?

All this talk of how it's OK for randconfig to give you i386 50% of the time
even when ARCH=x86_64 is specified is confusing me?  Maybe that
was just intended to be sarcasm?

-- Ted

