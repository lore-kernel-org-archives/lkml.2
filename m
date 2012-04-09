Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab2DIDL1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 23:11:27 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35641 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab2DIDLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 23:11:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120408195044.13ea6c8e.akpm@linux-foundation.org>
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com>
 <20120408195044.13ea6c8e.akpm@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 8 Apr 2012 20:11:04 -0700
X-Google-Sender-Auth: d0MF47JbOPGWFxJLBkzLGiCr1lo
Message-ID: <CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1 sticks-and-crashs)
To: Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>
Cc: David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 8, 2012 at 7:50 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sun, 8 Apr 2012 19:42:31 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>> > Apr __8 20:29:11 werner kernel: Normal free:44004kB min:44012kB low:55012kB
>> > high:66016kB active_anon:0kB inactive_anon:0kB active_file:132kB
>> > inactive_file:140kB unevictable:0kB isolated(anon):0kB isolated(file):0kB
>> > present:885944kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
>> > slab_reclaimable:13068kB slab_unreclaimable:147784kB kernel_stack:628952kB
>> > pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1376
>> > all_unreclaimable? yes
>
> That's claiming that 600MB of ZONE_NORMAL is being used for kernel stacks.

Well, that would certainly eat up memory that is hard to get back.

Werner - if you can reproduce this, can you get a "ps axl" or similar
when it starts happening? Or probably even long before, since it
probably starts long long earlier.

Or does anybody see anything that keeps thread counts raised so that
"free_task()" doesn't get done. kernel/profoe.c does that
"profile_handoff_task()" thing - but only oprofile and the android
low-memory-killer logic seems to use it though. But that's exactly the
kind of thing that Werner's "configure everything" might enable -
Werner?

What else would do this? I'd suspect the /proc code, but that grabs
the mm_struct, and those particular changes were pre-3.3 anyway.

Adding Oleg just in case he has any ideas about process code changes
(or some usermodehelper thing that leaks processes, or whatever).

                             Linus
