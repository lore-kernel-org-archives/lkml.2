Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149Ab2BJUN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:13:26 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39826 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760043Ab2BJUNY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:13:24 -0500
MIME-Version: 1.0
X-Originating-IP: [89.138.49.59]
In-Reply-To: <1328899148.25989.38.camel@laptop>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
	<1327591185.2446.102.camel@twins>
	<CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com>
	<20120201170443.GE6731@somewhere.redhat.com>
	<CAOtvUMc8L1nh2eGJez0x44UkfPCqd+xYQASsKOP76atopZi5mw@mail.gmail.com>
	<4F2AAEB9.9070302@tilera.com>
	<CAOtvUMfE3xpwmRKnFPTsstr3SuUG7SnpWn5eomEQzkap4_nfrg@mail.gmail.com>
	<1328899148.25989.38.camel@laptop>
Date: Fri, 10 Feb 2012 22:13:23 +0200
Message-ID: <CAOtvUMfZ-sfTd-WTV=+RcerTk6ejC2mmjrMGg8KkdMR=RaV+CA@mail.gmail.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 8:39 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Sun, 2012-02-05 at 13:46 +0200, Gilad Ben-Yossef wrote:
>> > /*
>> >  * Cause all memory mappings to be populated in the page table.
>> >  * Specifying this when entering dataplane mode ensures that no future
>> >  * page fault events will occur to cause interrupts into the Linux
>> >  * kernel, as long as no new mappings are installed by mmap(), etc.
>> >  * Note that since the hardware TLB is of finite size, there will
>> >  * still be the potential for TLB misses that the hypervisor handles,
>> >  * either via its software TLB cache (fast path) or by walking the
>> >  * kernel page tables (slow path), so touching large amounts of memory
>> >  * will still incur hypervisor interrupt overhead.
>> >  */
>> > #define DP_POPULATE     0x8
>>
>> hmm... I've probably missed something, but doesn't this replicate
>> mlockall (MCL_CURRENT|MCL_FUTURE) ?
>
> Never use mlockall() its a sign you're doing it wrong, also his comment
> seems to imply MCL_FUTURE isn't required.
>


My current understanding is that if I have a real time task and wish it
have a deterministic performance time, you should call mlockall() to lock
the program data and text into physical memory so that  a  less often taken
branch or access to a new data region will not result in a page fault.

You still have to worry about TLB misses on non hardware page table
walk architecture, but at least everything is in the  page tables

If there is a better way to do this? I'm always happy to learn new
ways to do things. :-)


Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
