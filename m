Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab1JRRCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 13:02:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791Ab1JRRCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 13:02:20 -0400
Date: Tue, 18 Oct 2011 13:02:04 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: p.herz@profihost.ag, linux-kernel@vger.kernel.org
Subject: Re: Vanilla-Kernel 3 - page allocation failure
Message-ID: <20111018170204.GA10551@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, p.herz@profihost.ag,
	linux-kernel@vger.kernel.org
References: <4E9D53FF.7090609@profihost.ag>
 <m2ipnmz49x.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2ipnmz49x.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 08:51:54AM -0700, Andi Kleen wrote:
 > Philipp Herz - Profihost AG <p.herz@profihost.ag> writes:
 > 
 > > After updating kernel (x86_64) to stable version 3 there are a few
 > > messages appearing in the kernel log such as
 > >
 > > kworker/0:1: page allocation failure: order:1, mode:0x20
 > > mysql: page allocation failure: order:1, mode:0x20
 > > php5: page allocation failure: order:1, mode:0x20
 > 
 > You just ran out of memory.
 > 
 > The problem here seems to be that the kernel is unable to communicate
 > in a language you can understand. 
 > 
 > How do you think the message should have been phrased to make the 
 > issue more clear?

We get reports like this fairly regularly, usually accompanied by
"But I had lots of free memory and/or swap!"

The order/mode stuff is completely opaque to end-users, who have no
clue that there are different types of memory, and exhausting one type
can happen even when plenty of other memory is free.

I've been toying with the idea of hacking up a patch to turn those mode
flags into printing things like "mode:GFP_ATOMIC|GFP_NOIO" instead though, as I can
never remember those flags off the top of my head.
Still won't help end-users, but it would at least speed up diagnosing reports.

	Dave
 
