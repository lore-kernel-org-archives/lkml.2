Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab2AQTgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:36:06 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59623 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab2AQTgB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:36:01 -0500
MIME-Version: 1.0
In-Reply-To: <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
References: <1326302710-9427-2-git-send-email-wad@chromium.org>
	<20120112162231.GA23960@redhat.com>
	<CABqD9hbjGYA-jAOe-3CZEUV3MG2Qgs6SJ2irN7N+JMB2wj-mzA@mail.gmail.com>
	<20120112172315.GA26295@redhat.com>
	<CABqD9hZg4sKiVMS-g5ed7-HKOaiUb06y05TL=QkfBkm9kVmquA@mail.gmail.com>
	<20120113173153.GA24273@redhat.com>
	<CABqD9hYYJMNtupTiD48sE5wz6RKaFi9J3DpVRyV4X2FpnT3Mnw@mail.gmail.com>
	<CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com>
	<20120116183730.GB21112@redhat.com>
	<CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
	<20120117164523.GA17070@redhat.com>
	<CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
Date: Tue, 17 Jan 2012 13:35:59 -0600
Message-ID: <CABqD9hYG0HsQfp2SBZ7URvw+VZy3PePkMwng9ND_Z3pqfkqBWA@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>, Indan Zupancic <indan@nul.nu>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 10:56 AM, Will Drewry <wad@chromium.org> wrote:
> On Tue, Jan 17, 2012 at 10:45 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> On 01/16, Will Drewry wrote:
>>>
>>> On Mon, Jan 16, 2012 at 12:37 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>>> >
>>> > Yes, thanks, I forgot about compat tasks again. But this is easy, just
>>> > we need regs_64_to_32().
>>>
>>> Yup - we could make the assumption that is_compat_task is always
>>> 32-bit and the pt_regs is always 64-bit, then copy_and_truncate with
>>> regs_64_to_32.  Seems kinda wonky though :/
>>
>> much simpler/faster than what regset does to create the artificial
>> user_regs_struct32.
>
> True, I could collapse pt_regs to looks like the exported ABI pt_regs.
>  Then only compat processes would get the copy overhead.  That could
> be tidy and not break ABI.  It would mean that I have to assume that
> if unsigned long == 64-bit and is_compat_task(), then the task is
> 32-bit.  Do you think if we ever add a crazy 128-bit "supercomputer"
> arch that we will add a is_compat64_task() so that I could properly
> collapse? :)
>
> I like this idea!

Ouch, so a few issues:
- pt_regs isn't exported for most arches
- is_compat_task arches would need custom fixups

I think Indan takes this round :) I'll being integrating a
syscall_get_arguments approach.  Hopefully it can be quite efficient.

cheers!
will
