Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab2ASBrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:47:37 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:45033 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab2ASBrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:47:33 -0500
Message-ID: <2b59b7f90f89952223d4b4c063c62b75.squirrel@webmail.greenhost.nl>
In-Reply-To: <CAObL_7HOWzGUBQ4ZOCMZ+CR-1wCQLUMXB0bN5QO_0o5U-kGc2g@mail.gmail.com>
References: <20120112172315.GA26295@redhat.com>
    <CABqD9hZg4sKiVMS-g5ed7-HKOaiUb06y05TL=QkfBkm9kVmquA@mail.gmail.com>
    <20120113173153.GA24273@redhat.com>
    <CABqD9hYYJMNtupTiD48sE5wz6RKaFi9J3DpVRyV4X2FpnT3Mnw@mail.gmail.com>
    <CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com>
    <20120116183730.GB21112@redhat.com>
    <CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
    <20120117164523.GA17070@redhat.com>
    <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
    <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>
    <20120117170512.GB17070@redhat.com>
    <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
    <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
    <CAObL_7HVGNdFhYfUDvJJWMK-2fVoG8KJj2_fuPvc7aBLBhBO4g@mail.gmail.com>
    <c378bf0311a5a647e7172d1aa8500379.squirrel@webmail.greenhost.nl>
    <CAObL_7HOWzGUBQ4ZOCMZ+CR-1wCQLUMXB0bN5QO_0o5U-kGc2g@mail.gmail.com>
Date: Thu, 19 Jan 2012 02:47:25 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
 [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
From: "Indan Zupancic" <indan@nul.nu>
To: "Andrew Lutomirski" <luto@mit.edu>
Cc: "Oleg Nesterov" <oleg@redhat.com>, "Will Drewry" <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com,
        "Roland McGrath" <mcgrathr@chromium.org>,
        "Andi Kleen" <andi@firstfloor.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 1.4
X-Scan-Signature: 919fae14bc17c74543a025539baad412
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, January 19, 2012 02:19, Andrew Lutomirski wrote:
> On Wed, Jan 18, 2012 at 5:06 PM, Indan Zupancic <indan@nul.nu> wrote:
>> On Wed, January 18, 2012 02:01, Andrew Lutomirski wrote:
>>> On Tue, Jan 17, 2012 at 4:56 PM, Indan Zupancic <indan@nul.nu> wrote:
>>> I don't know what your ptrace jailer does.  But a task can switch
>>> itself between 32-bit and 64-bit execution at will, and there's
>>> nothing the kernel can do about it.  (That isn't quite true -- in
>>> theory the kernel could fiddle with the GDT, but that would be
>>> expensive and wouldn't work on Xen.)
>>
>> That's why we don't cache the CS value but check it for every system call.
>> But you said elsewhere that checking CS isn't always correct either.
>> I grepped arch/x86 for "user_64bit_mode", but couldn't find anything,
>> but maybe my kernel sources are too old, I haven't updated this system
>> for almost a year. The current code only handles 0x23 and 0x33 and kills
>> the jail if it encounters anything else.
>
> I think you're hosed on Xen, then.  Xen regularly runs with a
> different Xen-specific cs value.

That's fine as long as a cs value of 0x23 or 0x33 gives reliable information.
Not running is highly prefered above running insecurely. Security first,
functionality second.

Greetings,

Indan


