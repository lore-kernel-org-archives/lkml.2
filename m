Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053Ab1EMQYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:24:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:28670 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932618Ab1EMQYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:24:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,365,1301900400"; 
   d="scan'208";a="746885609"
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Jones <davej@redhat.com>, Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
	<BANLkTi==OatTqfDbnAmHQA0t2DmokEd-CA@mail.gmail.com>
	<BANLkTik7wQc05OQTHThBbrFhKx2pM1Tx+A@mail.gmail.com>
	<BANLkTimjHiaZ+b03FLb1LX=ycv=cAVyJZw@mail.gmail.com>
	<20110512213542.GB17596@elte.hu>
	<BANLkTikPmq=NOt-9t0odVVnrRshM=MsnJw@mail.gmail.com>
	<20110512215023.GA20939@elte.hu> <20110512220715.GA7451@redhat.com>
	<20110513085752.GF13647@elte.hu>
Date: Fri, 13 May 2011 09:23:52 -0700
In-Reply-To: <20110513085752.GF13647@elte.hu> (Ingo Molnar's message of "Fri,
	13 May 2011 10:57:52 +0200")
Message-ID: <m2iptezi07.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

I agree that the current %kP default is really a catastrophe, clearly
on the trajectory of "the system is only secure when nothing works anymore"

> The x86 kernel is relocatable, so slightly randomizing the position of the 
> kernel would be feasible with no overhead on the vast majority of exising 
> distro installs, with just an updated kernel.

Problem is that we don't have a source of secure randomness early on
when the relocation would need to happen.

You could either pass it as an option, but that option would be right
now too exposed, or just use kexec and boot twice.

But all of this has drawbacks.

> When exposing randomized RIPs to user-space we could recalculate all RIPs back 
> to the 0xffffffff80000000 base, so oopses would have the usual non-randomized 
> form:

This would be very confusing because the register and stack contents 
would have the non relocated addresses.

I bet it would cause a lot of similar problems as the current %kP
madness, just more subtle ones.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
