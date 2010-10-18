Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab0JRT0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:26:17 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:42969 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975Ab0JRT0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:26:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19644.40666.197005.18146@quad.stoffel.home>
Date: Mon, 18 Oct 2010 15:24:10 -0400
From: "John Stoffel" <john@stoffel.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, James Morris <jmorris@namei.org>,
        Christoph Hellwig <hch@infradead.org>, kernel@lists.fedoraproject.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Serge Hallyn <serue@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
        eparis@redhat.com
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
In-Reply-To: <1287417785.2516.53.camel@localhost.localdomain>
References: <20101016065206.GO4681@dastard>
	<20101016192027.GA6883@infradead.org>
	<ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
	<20101017004945.GE1614@infradead.org>
	<20101017054008.GA16383@elte.hu>
	<20101017184652.GB28060@infradead.org>
	<alpine.LRH.2.00.1010181127480.9476@tundra.namei.org>
	<20101018062530.GD8332@bombadil.infradead.org>
	<1287417785.2516.53.camel@localhost.localdomain>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mimi" == Mimi Zohar <zohar@linux.vnet.ibm.com> writes:

Mimi> On Mon, 2010-10-18 at 02:25 -0400, Kyle McMartin wrote:
>> If someone gives me a good reason why Fedora actually needs this
>> enabled, I'm going to apply the following patch to our kernel so that
>> IMA is globally an opt-in feature... Otherwise I'm inclined to just
>> disable it.

Mimi> Am hoping others will chime in.

I'll chime in.  I run Debian Squeeze and Ubuntu 10.10 and neither of
them seem to have this monstrosity enabled at all, which is good.  It
should default to OFF and have a big fat warning saying it's a memory
pig.

>> (But the more I look at this, the more it looks like a completely niche
>> option that has little use outside of three-letter agencies.)
>> 
>> I regret not looking at this more closely when it was enabled,
>> (although, in my defence, when the option first showed up, I left it
>> off...)
>> 
>> It's probably way more heavyweight than necessary, as I think in most
>> cases the iint_initalized test will cover the call into IMA. But better
>> safe than sorry or something and there's a bunch of other cases where
>> -ENOMEM will leak back up from failing kmem_cache_alloc, iirc.
>> 
>> regards, Kyle

Mimi> Thanks, will compile/test patch.

>From what I'm reading, it's not even useful unless you have TPM
hardware?  

I dunno... I'm just hesitant to use this or SElinux because the
hassles are not worth the payoff.  

John
