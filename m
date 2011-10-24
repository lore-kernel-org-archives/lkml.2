Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1JXKgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 06:36:37 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58254 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab1JXKgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 06:36:36 -0400
MIME-Version: 1.0
In-Reply-To: <20111022133648.GA21374@n2100.arm.linux.org.uk>
References: <4E9E0B71.9020708@am.sony.com>
	<1318983248.7569.5.camel@Joe-Laptop>
	<4E9E1944.80601@am.sony.com>
	<1500345.YeXPhIIHc5@wuerfel>
	<CACVXFVMb9p8PiTYWGTNn-FtQts0sRgmK+BQ6kaJ6-D89CAT=xQ@mail.gmail.com>
	<20111022133648.GA21374@n2100.arm.linux.org.uk>
Date: Mon, 24 Oct 2011 18:36:35 +0800
Message-ID: <CACVXFVPh1UK2kGoKRY6WuCiDGkk2ijNtgPNWy-PWU7e_v-0C=w@mail.gmail.com>
Subject: Re: [PATCH 0/3] ARM 4Kstacks: introduction
From: Ming Lei <tom.leiming@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Tim Bird <tim.bird@am.sony.com>, Joe Perches <joe@perches.com>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Oct 22, 2011 at 9:36 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, Oct 22, 2011 at 04:50:15PM +0800, Ming Lei wrote:
>> On Wed, Oct 19, 2011 at 6:51 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Tuesday 18 October 2011 17:26:44 Tim Bird wrote:
>> >> Even inside Sony, usage of 4K stacks is limited
>> >> to some very special cases, where memory is exceedingly
>> >> tight (we have one system with 4M of RAM).  And we
>> >> don't mind lopping off features or coding around
>> >> problem areas to support our special case.
>> >
>> > I would imagine that in those cases, you can gain more by reducing the
>> > number of threads in the system. What is the highest number of
>> > concurrent threads that you expect in a limited use case with no
>> > networking or block devices?
>>
>> If system run for some time, sometimes it may be difficult for
>> memory allocator to allocate 2 continuous page frames even  there are
>> many spare page frames in system because of
>> fragment issue, so the patch does make sense.
>
> If memory fragmentation is an issue for this, it probably means that we
> need to switch to a software page size of 8K (or maybe 16K) rather than
> stick with the hardware 4K size.  That would be a much more reliable
> solution, especially as the L1 page table is 16K (if you're suffering
> from memory fragmentation, the first thing which'd get you is the L1
> page table allocation, not the kernel stack allocation.)

If large page size is taken, memory utilization will be decreased a lot, so
may cause some low memory system not workable at all.

>> Anyway, it provides one option for user to apply 4k stack to avoid
>> such kind of process creation failure.
>
> I refer you to the comments made by people who've tried running with 4K
> stacks on x86, and their _vast_ experience of doing this.  If they say
> that it causes stack overflows, then it's a problem.

Stack overflow depends on code running path. For some low memory
and simple application, the code path is not deep as x86, so providing
a option of enabling 4K stack still makes sense for this kind of case or
application.


thanks,
-- 
Ming Lei
