Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab1HYQeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:34:25 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52574 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753579Ab1HYQeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:34:09 -0400
References: <1313650253-21794-1-git-send-email-gthelen@google.com> <20110818144025.8e122a67.akpm@linux-foundation.org> <1314284272.27911.32.camel@twins> <alpine.DEB.2.00.1108251009120.27407@router.home> <1314289208.3268.4.camel@mulgrave> <alpine.DEB.2.00.1108251128460.27407@router.home>
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.DEB.2.00.1108251128460.27407@router.home>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] memcg: remove unneeded preempt_disable
From: James Bottomley <James.bottomley@HansenPartnership.com>
Date: Thu, 25 Aug 2011 09:34:06 -0700
To: Christoph Lameter <cl@linux.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-arch@vger.kernel.org
Message-ID: <986ca4ed-6810-426f-b32f-5c8687e3a10b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Christoph Lameter <cl@linux.com> wrote:

>On Thu, 25 Aug 2011, James Bottomley wrote:
>
>> On Thu, 2011-08-25 at 10:11 -0500, Christoph Lameter wrote:
>> > On Thu, 25 Aug 2011, Peter Zijlstra wrote:
>> >
>> > > On Thu, 2011-08-18 at 14:40 -0700, Andrew Morton wrote:
>> > > >
>> > > > I think I'll apply it, as the call frequency is low (correct?)
>and the
>> > > > problem will correct itself as other architectures implement
>their
>> > > > atomic this_cpu_foo() operations.
>> > >
>> > > Which leads me to wonder, can anything but x86 implement that
>this_cpu_*
>> > > muck? I doubt any of the risk chips can actually do all this.
>> > > Maybe Itanic, but then that seems to be dying fast.
>> >
>> > The cpu needs to have an RMW instruction that does something to a
>> > variable relative to a register that points to the per cpu base.
>> >
>> > Thats generally possible. The problem is how expensive the RMW is
>going to
>> > be.
>>
>> Risc systems generally don't have a single instruction for this,
>that's
>> correct.  Obviously we can do it as a non atomic sequence: read
>> variable, compute relative, read, modify, write ... but there's
>> absolutely no point hand crafting that in asm since the compiler can
>> usually work it out nicely.  And, of course, to have this atomic, we
>> have to use locks, which ends up being very expensive.
>
>ARM seems to have these LDREX/STREX instructions for that purpose which
>seem to be used for generating atomic instructions without lockes. I
>guess
>other RISC architectures have similar means of doing it?

Arm isn't really risc.  Most don't.  However even with ldrex/strex you need two instructions for rmw.

James
-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity and top posting.
