Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab2AQRpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:45:49 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:64431 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752707Ab2AQRpr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:45:47 -0500
MIME-Version: 1.0
In-Reply-To: <20120117170512.GB17070@redhat.com>
References: <20120112172315.GA26295@redhat.com> <CABqD9hZg4sKiVMS-g5ed7-HKOaiUb06y05TL=QkfBkm9kVmquA@mail.gmail.com>
 <20120113173153.GA24273@redhat.com> <CABqD9hYYJMNtupTiD48sE5wz6RKaFi9J3DpVRyV4X2FpnT3Mnw@mail.gmail.com>
 <CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com>
 <20120116183730.GB21112@redhat.com> <CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
 <20120117164523.GA17070@redhat.com> <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
 <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com> <20120117170512.GB17070@redhat.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 17 Jan 2012 09:45:25 -0800
X-Google-Sender-Auth: gVJrXdVKBVXVreP5iU_WzIz000w
Message-ID: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
To: Oleg Nesterov <oleg@redhat.com>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>,
        Andi Kleen <andi@firstfloor.org>, indan@nul.nu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 9:05 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/17, Andrew Lutomirski wrote:
>>
>> (is_compat_task says whether the executable was marked as 32-bit.  The
>> actual execution mode is determined by the cs register, which the user
>> can control.
>
> Confused... Afaics, TIF_IA32 says that the binary is 32-bit (this comes
> along with TS_COMPAT).
>
> TS_COMPAT says that, say, the task did "int 80" to enters the kernel.
> 64-bit or not, we should treat is as 32-bit in this case.

I think you're right, and checking which entry was used is better than
checking the cs register (since 64-bit code can use int80).  That's
what I get for insufficiently careful reading of the assembly.  (And
for going from memory from when I wrote the vsyscall emulation code --
that code is entered from a page fault, so the entry point used is
irrelevant.)

--Andy
