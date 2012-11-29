Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab2K2CPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 21:15:12 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57245 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab2K2CPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 21:15:10 -0500
Message-ID: <50B6C526.4090808@vlnb.net>
Date: Wed, 28 Nov 2012 21:15:02 -0500
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: Nico Williams <nico@cryptonector.com>
CC: Chris Friesen <chris.friesen@genband.com>,
        Ryan Johnson <ryan.johnson@cs.utoronto.ca>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Hipp <drh@hwaci.com>
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>	<m2fw5mtffg.fsf_-_@firstfloor.org>	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>	<5086F5A7.9090406@vlnb.net>	<20121025051445.GA9860@thunk.org>	<508B3EED.2080003@vlnb.net>	<20121027044456.GA2764@thunk.org>	<5090532D.4050902@vlnb.net>	<20121031095404.0ac18a4b@pyramind.ukuu.org.uk>	<5092D90F.7020105@vlnb.net>	<20121101212418.140e3a82@pyramind.ukuu.org.uk>	<50931601.4060102@symas.com>	<20121102123359.2479a7dc@pyramind.ukuu.org.uk>	<50A1C15E.2080605@vlnb.net>	<20121113174000.6457a68b@pyramind.ukuu.org.uk>	<CAK3OfOgK7a9+g-KU8v5-b2d+8-vLb75kuKKQnPK-zeFV1fLmxw@mail.gmail.com>	<50A442AF.9020407@vlnb.net>	<50A52133.9050204@cs.utoronto.ca>	<50A56E43.3040805@genband.com>	<50A71A7B.3040407@vlnb.net>	<50AADBA8.4090507@vlnb.net> <CAK3OfOjD4XBGfu3cnMwTvCfec0Lvg3zrO16+pXtiFF4UWpFjDw@mail.gmail.com>
In-Reply-To: <CAK3OfOjD4XBGfu3cnMwTvCfec0Lvg3zrO16+pXtiFF4UWpFjDw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:0uGVELvWz3qvQYvfnU6h9B4mrC9KfQHiJK2NrFi+O1D
 U+IvujOCg454GVGJp4sCqDFpBHUT7bgOaT9Aw31TA5BMwCw76H
 sbqtrQPMIDNgTeGjVONskZeA2j8/YmUwkD4vhSnk2keLdrfizM
 V5hRK7xN48PpiaHTenQVf4liQUT5nVC8jYNXOfYkMTWd0Taa0n
 ulqD+99KcZfDqMHbpp62T8auGovhxfIhcKgbPQXiDvOMjRT1xv
 RlcQ4HO7uYawkwvQ7VheGU2kP4a/peUruMIBwySkvE0C7KCWCT
 sk4kviryW7CFkiaXmZdmM8VZJYlySPHh4jCHpJ2ff3P3do+8Wu
 Y4+v4crz+oK9FOrCAQII=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nico Williams, on 11/26/2012 03:05 PM wrote:
> Vlad,
>
> You keep saying that programmers don't understand "barriers".  You've
> provided no evidence of this. Meanwhile memory barriers are generally
> well understood, and every programmer I know understands that a
> "barrier" is a synchronization primitive that says that all operations
> of a certain type will have completed prior to the barrier returning
> control to its caller.

Well, your understanding of memory barriers is wrong, and you are illustrating 
that the memory barriers concept is not so well understood on practice.

Simplifying, memory barrier instructions are not "cache flush" of this CPU as it 
is often thought. They set order how reads or writes from other CPUs are visible 
on this CPU. And nothing else. Locally on each CPU reads and writes are always 
seen in order. So, (1) on a single CPU system memory barrier instructions don't 
make any sense and (2) they should go at least in a pair for each participating in 
the interaction CPU, otherwise it's an apparent sign of a mistake.

There's nothing similar in storage, because storage has strong consistency 
requirements even if it is distributed. All those clouds and hadoops with weak 
consistency requirements are outside of this discussion, although even they don't 
have anything similar to memory barriers.

As I already wrote, concept of a flat Earth and Sun revolving around is also very 
simple to understand. Are you still using this concept?

> So just give us a barrier.

Similarly to the flat Earth, I'd strongly suggest you to start using adequate 
concept of what you want to achieve starting from what I proposed few e-mails ago 
in this thread.

If you look at it, it offers exactly what you want, only named correctly.

Vlad
