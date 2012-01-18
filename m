Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab2ART6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:58:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45937 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2ART63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:58:29 -0500
MIME-Version: 1.0
In-Reply-To: <CABqD9ha-ja1SDnnMqsnxm80UzdujZfUDJfARbr=4435kejHVKA@mail.gmail.com>
References: <20120118015013.GR11715@one.firstfloor.org>
	<20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
	<20120118022217.GS11715@one.firstfloor.org>
	<fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
	<CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
	<CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
	<fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
	<CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
	<20120118193602.GV11715@one.firstfloor.org>
	<CA+55aFz+NNf3SrAdno72EEVbhM-tgBcwjz0ao3TLiOSJR-yJoQ@mail.gmail.com>
	<20120118194420.GW11715@one.firstfloor.org>
	<CA+55aFwWXqjq=J0R2zfsRuHYBatC19KP6GJqiETS2LKToEPN9w@mail.gmail.com>
	<CABqD9ha-ja1SDnnMqsnxm80UzdujZfUDJfARbr=4435kejHVKA@mail.gmail.com>
Date: Wed, 18 Jan 2012 13:58:26 -0600
Message-ID: <CABqD9hZ25W58Yj6byoWTi+DdDGs6jvhtGpkRXiHPSGppbkTnhQ@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
From: Will Drewry <wad@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Indan Zupancic <indan@nul.nu>,
        Jamie Lokier <jamie@shareable.org>, Andrew Lutomirski <luto@mit.edu>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 1:52 PM, Will Drewry <wad@chromium.org> wrote:
> On Wed, Jan 18, 2012 at 1:47 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Wed, Jan 18, 2012 at 11:44 AM, Andi Kleen <andi@firstfloor.org> wrote:
>>>
>>> It can securely enable syscall auditing which can catch all syscalls
>>> (however you only get race free memory arguments for the ones with LSM hooks
>>> at the right place). Really need both.
>>>
>>> I agree it's not easy to get tight (and also not pretty), but you have a lot
>>> better chance doing it this way than with ptrace.
>>
>> .. And how the f*^& did you imagine that something like chrome would do that?
>>
>> You need massive amounts of privileges, and it's a total disaster in
>> every single respect.
>>
>> Stop pushing crap. No, ptrace isn't wonderful, but your LSM+auditing
>> idea is a billion times worse in all respects.
>>
>> We can definitely fix the ptrace issue with compat system calls.
>
> FWIW, it looks like audit needs fixing too.  If a process only uses
> TIF_SYSCALL_AUDIT, then the fast-path will properly annotate the entry
> with AUDIT_ARCH_I386, but if it takes the slow path because of some
> other tracing on a thread (ftrace, ptrace, ...), then the audit record
> will incorrectly use TIF_IA32 to write the audit record.  Easy patch
> (I'll write it up shortly), but yet another case of breakage.

Nevermind - mis-derefenced the IS_IA32 define.
