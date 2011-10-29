Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab1J2Ji2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 05:38:28 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41697 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab1J2Ji0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 05:38:26 -0400
MIME-Version: 1.0
In-Reply-To: <20111028163021.1ce61f8a.akpm@linux-foundation.org>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
	<20111004150111.e9337268.akpm00@gmail.com>
	<CAAAKZwu67VMiZgdpp=i5p7zyGbOHGHXwF_iprufGPzTLkkUF2A@mail.gmail.com>
	<20111028163021.1ce61f8a.akpm@linux-foundation.org>
Date: Sat, 29 Oct 2011 11:38:25 +0200
Message-ID: <CAA6-i6o0SPfZJDx4SRR1hY-He0L6zHuv0saH6EaE7Mrc2HF6PA@mail.gmail.com>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v6
From: Glauber Costa <glommer@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tim Hockin <thockin@hockin.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 1:30 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 25 Oct 2011 13:06:35 -0700
> Tim Hockin <thockin@hockin.org> wrote:
>
>> On Tue, Oct 4, 2011 at 3:01 PM, Andrew Morton <akpm00@gmail.com> wrote:
>> > On Mon, __3 Oct 2011 21:07:02 +0200
>> > Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> >
>> >> Hi Andrew,
>> >>
>> >> This contains minor changes, mostly documentation and changelog
>> >> updates, off-case build fix, and a code optimization in
>> >> res_counter_common_ancestor().
>> >
>> > I'd normally duck a patch series like this when we're at -rc8 and ask
>> > for it to be resent late in -rc1. __But I was feeling frisky so I
>> > grabbed this lot for a bit of testing and will sit on it until -rc1.
>> >
>> > I'm still not convinced that the kernel has a burning need for a "task
>> > counter subsystem". __Someone convince me that we should merge this!
>>
>> We have real (accidental) DoS situations which happen because we don't
>> have this.  It usually takes the form of some library no re-joining
>> threads.  We end up deploying a few apps linked against this library,
>> and suddenly we're in trouble on a machine.  Except, this being
>> Google, we're in trouble on a lot of machines.
>
> This is a bit foggy.  I think you mean that machines are experiencing
> accidental forkbombs?
>
>> There may be other ways to cobble this sort of safety together, but
>> they are less appealing for various reasons.  cgroups are how we
>> control groups of related pids.
>>

In the end of the day, all cgroups are just a group of tasks. So I don't really
get the need to have a cgroup to control the number of tasks in the system.

Why don't we just allow all cgroups to have a limit on the number of
tasks it can hold?




-- 
Sent from my Atari.
