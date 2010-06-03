Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab0FCH7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 03:59:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64922 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920Ab0FCH7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 03:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=bpLiELtTByO6Mjc5U+f2/ab1NRVXYO4FmyBXb6+mdYLjQfg5E9Ngo36VLBmNHvV+5i
         p+Ilj7xufcpgHMHCtNmahlWDZPcENIxzp5rSDy63EcAl2cnUDYaprPrPiU1C9wLDAYLY
         /MWZAoi5YLRRr51+owNTTjWaYrNwf9PCgvdQ0=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <AANLkTin2b7qE1zo0fQWIhYIzdV26zNBjHRcNAOELpUfK@mail.gmail.com>
References: <20100524070552.GR23411@kernel.dk> <AANLkTikogQtGpO9c94A7YSmP8zdyM8dZBrwJf1nwlR4j@mail.gmail.com> 
	<20100524173551.GU23411@kernel.dk> <AANLkTimDJjHWKISxnLax3r200Db8OQp_lMKOx14ONgkS@mail.gmail.com> 
	<20100524175649.GV23411@kernel.dk> <AANLkTim_yrRZG6v1tMPgefeaaI-nUa35Q-mLQpuXWJ1p@mail.gmail.com> 
	<20100601074534.GL1660@kernel.dk> <AANLkTinGfonivZvofBkMzv53IJZeKbFAEMVpv96BiJ30@mail.gmail.com> 
	<20100603061039.GD3564@kernel.dk> <AANLkTint7OJvmTn7d7bqTJzsCxV-VlVT46PQWVH-m73g@mail.gmail.com> 
	<20100603070126.GJ3564@kernel.dk> <AANLkTilwyuE-HiY0vX5askTNi1KoeuKIldmE85WrfIqU@mail.gmail.com> 
	<AANLkTin2b7qE1zo0fQWIhYIzdV26zNBjHRcNAOELpUfK@mail.gmail.com>
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Date: Thu, 3 Jun 2010 09:58:46 +0200
Message-ID: <AANLkTiliVv0RFCeZnUy0PeWS1LNQZGzLSDFnZlf8-hgO@mail.gmail.com>
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
To: Jens Axboe <jaxboe@fusionio.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On Thu, Jun 3, 2010 at 9:48 AM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
> On Thu, Jun 3, 2010 at 9:05 AM, Michael Kerrisk
> <mtk.manpages@googlemail.com> wrote:
>> On Thu, Jun 3, 2010 at 9:01 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>> On Thu, Jun 03 2010, Michael Kerrisk wrote:
>>>> Hi Jens,
>>>>
>>>> On Thu, Jun 3, 2010 at 8:10 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>>> > On Wed, Jun 02 2010, Michael Kerrisk wrote:
>>>> >> On Tue, Jun 1, 2010 at 9:45 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>> >> > On Thu, May 27 2010, Michael Kerrisk wrote:
>>>> >> >> Jens,
>>>> >> >>
>>>> >> >> On Mon, May 24, 2010 at 7:56 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>>>> >> >> > On Mon, May 24 2010, Michael Kerrisk wrote:
>>>> >> >> >> On Mon, May 24, 2010 at 7:35 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>>>> >> >> >> > On Mon, May 24 2010, Michael Kerrisk wrote:
>>>> >> >> >> >> > Right, that looks like a thinko.
>>>> >> >> >> >> >
>>>> >> >> >> >> > I'll submit a patch changing it to bytes and the agreed API and fix this
>>>> >> >> >> >> > -Eerror. Thanks for your comments and suggestions!
>>>> >> >> >> >>
>>>> >> >> >> >> Thanks. And of course you are welcome. (Please CC linux-api@vger on
>>>> >> >> >> >> this patche (and all patches that change the API/ABI.)
>>>> >> >> >> >
>>>> >> >> >> > The first change is this:
>>>> >> >> >> >
>>>> >> >> >> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=0191f8697bbdfefcd36e7b8dc3eeddfe82893e4b
>>>> >> >> >> >
>>>> >> >> >> > and the one dealing with the pages vs bytes API is this:
>>>> >> >> >> >
>>>> >> >> >> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=b9598db3401282bb27b4aef77e3eee12015f7f29
>>>> >> >> >> >
>>>> >> >> >> > Not tested yet, will do so before sending in of course.
>>>> >> >> >>
>>>> >> >> >> Eyeballing it quickly, these changes look right.
>>>> >> >> >
>>>> >> >> > Good, thanks.
>>>> >> >> >
>>>> >> >> >> Do you have some test programs you can make available?
>>>> >> >> >
>>>> >> >> > Actually I don't, I test it by modifying fio's splice engine to set/get
>>>> >> >> > the pipe size and test the resulting transfers.
>>>> >> >>
>>>> >> >> An afterthought. Do there not also need to be fixes to the /proc
>>>> >> >> interfaces. I don't think they were included in your revised patches.
>>>> >> >
>>>> >> > I think the proc part can be sanely left in pages, since it's just a
>>>> >> > memory limiter.
>>>> >>
>>>> >> I can't see any advantage to using two different units for these
>>>> >> closely related APIs, and it does seem like it could be a source of
>>>> >> confusion. Similar APIs that I can think of like RLIMIT_MEMLOCK and
>>>> >> shmget() SHMMAX that impose per-process memory-related limits use
>>>> >> bytes. Best to be consistent, don't you think?
>>>> >
>>>> > But they are different interfaces.  I think the 'pass in required size,
>>>> > return actual size' where actual size is >= required size makes sense
>>>> > for the syscall part, but for an "admin" interface it is more logical to
>>>> > deal in pages. Perhaps that's just me and the average admin does not
>>>> > agree. So while it's just detail, it's also an interface so has some
>>>> > importance. And if there's consensus that bytes is a cleaner interface
>>>> > on the proc side as well, then lets change it.
>>>>
>>>> I'll add one more datapoint to those that I already mentioned.
>>>> RLIMIT_STACK and RLIMIT_DATA (getrlimit()) is also expressed in bytes.
>>>>
>>>> There was only one vaguely related limit that I could find that
>>>> measured things in pages. Consider these two System V shared memory
>>>> limits:
>>>>
>>>> SHMMAX
>>>> This is the maximum size (in bytes) of a shared memory segment.
>>>>
>>>> SHMALL
>>>> This is a system-wide limit on the total number of pages of shared memory.
>>>>
>>>> But in a way this almost confirms my point. SHMMAX is a limit the
>>>> governs the behavior of individual processes (like your /proc file),
>>>> while SHMALL is a limit that governs the behavior of the system as a
>>>> whole. There is a (sort of) logic to using bytes for one and pages for
>>>> the other.
>>>>
>>>> I think that I've said all I need to say on the topic. I'm inclined to
>>>> think yours /proc file should use bytes, since it seems consistent
>>>> with other simialr APIs. Others may confirm, or someone else mught
>>>> have a different insight.
>>>
>>> I'll commit a patch to change it to bytes.
>>
>> Thanks Jens.
>
> Since I'm going to document the /proc file, it occurred to me... What
> are you going to call this file now? "pipe_max_pages"  no longer makes
> sense. "pipe_size_ceiling" may be more expressive than simply
> "pipe_max".

So, I'm looking at this interface still more closely now. How about
using CAP_SYS_RESOURCE, rather than the hugely overloaded
CAP_SYS_ADMIN as the governor for the capability check? Again, it's
about consistency. Here's what CAP_SYS_RESOURCE currently governs:

       CAP_SYS_RESOURCE
              * Use reserved space on ext2 file systems;
              * make ioctl(2) calls controlling ext3 journaling;
              * override disk quota limits;
              * increase resource limits (see setrlimit(2));
              * override RLIMIT_NPROC resource limit;
              * raise msg_qbytes limit for a System V message queue
above the limit
                in /proc/sys/kernel/msgmnb (see msgop(2) and msgctl(2)).

Including the pipe size limit in this list makes sense.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
