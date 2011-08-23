Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1HWQIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:08:25 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:55547 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab1HWQIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:08:19 -0400
MIME-Version: 1.0
In-Reply-To: <20110818143319.GC10441@somewhere>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <20110801161900.1fe24b76.akpm@linux-foundation.org> <CAAAKZwupGmw_+EaApZFAqVcXWBF885Gsjx6tUWUdMuebXrt_Mg@mail.gmail.com>
 <CAPXgP11aUfdkq-SdaHc8=tfjA4W7DYXjSXG-asoZMi6hK4iOPQ@mail.gmail.com> <20110818143319.GC10441@somewhere>
From: Paul Menage <paul@paulmenage.org>
Date: Tue, 23 Aug 2011 09:07:59 -0700
X-Google-Sender-Auth: YhuGVuUCc952dHYrCu1Ur-CBwqc
Message-ID: <CALdu-PA3+u-v1fj-DQuC-zyJ4Ud0Xi0sq0zcB0DLNcR_TMT6XQ@mail.gmail.com>
Subject: Re: [RFD] Task counter: cgroup core feature or cgroup subsystem? (was
 Re: [PATCH 0/8 v3] cgroups: Task counter subsystem)
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Tim Hockin <thockin@hockin.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 7:33 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
> So the problem with the task counter as a subsystem is that you could
> mount it in your systemd cgroups hierarchy but then it's not anymore
> available for those who want to use containers.

Another possible option is something that I prototyped a couple of
years ago, but dropped due to lack of compelling need and demand - the
ability to have subsystems that can be bound on multiple subsystems at
once. See

http://lkml.indiana.edu/hypermail/linux/kernel/0907.0/00574.html
http://lkml.indiana.edu/hypermail/linux/kernel/0907.0/00576.html
http://lkml.indiana.edu/hypermail/linux/kernel/0907.0/00577.html

It's applicable to subsystems whose state isn't tied to any specific
single resource in the kernel outside of cgroups (so e.g. the CPU
scheduler couldn't be usefully multi-bindable, since the CPU cgroup
state is tied to the machine's single CPU scheduler).

In the end I didn't work further on it, since it seemed that most
things that needed to be available to multiple hierarchies could more
simply be added to the core cgroups subsystem and automatically be
available on all hierarchies. But the point about tracking overhead
for fork/exit is certainly something that could make this worthwhile.

Paul
