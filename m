Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab2DBL0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:26:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab2DBL0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:26:39 -0400
Message-ID: <4F798B8C.2010802@redhat.com>
Date: Mon, 02 Apr 2012 12:20:44 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Extend core dump note section to contain file names of
 mapped files
References: <CAK1hOcPxVWDCTRLzH6X+88WXuw_Ywzbt+iAJ3QMEfxG22duk9g@mail.gmail.com> <20120401031329.GP17822@one.firstfloor.org> <20120402002448.GA27179@redhat.com>
In-Reply-To: <20120402002448.GA27179@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 01:24 AM, Oleg Nesterov wrote:

> On 04/01, Andi Kleen wrote:
>> >
>>> > > I propose to save this information in core dump, as a new note
>>> > > in note segment.
>> >
>> > Seems like a good idea but rather than write complicated code
> I agree, I feel it can be simplified...
> 
>> > i would just reuse
>> > the /proc/*/maps code and dump it in that format?
> I must have missed something. Do you really suggest to use
> show_pid_map/etc?
> 
> If nothing else, this code depends on CONFIG_PROC_FS. But in any
> case I think this will only complicate fill_files_note().
> 
> coredump is "simple", we are the last thread which can play with
> this ->mm. We do not need locks, we do not need the "restart after
> we dropped mmap_sem" logic. We know that the task_struct can't go
> away. The only problem is rename, that is why we can't allocate the
> whole buffer beforehand.
> 
> OK, I must have missed something ;)


In my perspective, it's about having a single format to consume.
Having only one format to care for in either the core or when
debugging a live process simplifies things for all parties involved.

(And it doesn't seem a good idea to me to have a better format that
handles more things when debugging cores than what tools have available
when debugging a live process.  If /proc/*/maps doesn't handle something
we might care for, then fix that too, not just the core note.)

The kernel.  The man pages.  Userspace tools.  E.g., GDB can trivially
be made to hook a new core note with /proc/*/maps-like contents with
the "(gdb) info proc maps" command (an often requested feature).

I even wish that more (if not all) of /proc/ 's objects were
copied verbatim (as much as possible) to a core dump.

-- 
Pedro Alves
