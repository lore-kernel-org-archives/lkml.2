Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab2BIQA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 11:00:57 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:42094 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab2BIQAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 11:00:54 -0500
MIME-Version: 1.0
In-Reply-To: <4F334B8C.2050005@zytor.com>
References: <20120116183730.GB21112@redhat.com>
	<49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
	<20120118015013.GR11715@one.firstfloor.org>
	<20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
	<20120118022217.GS11715@one.firstfloor.org>
	<fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
	<CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
	<CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
	<fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
	<CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
	<CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com>
	<dac05d1da093cb86e2f654fbfe66dfce.squirrel@webmail.greenhost.nl>
	<4F3007AD.50307@zytor.com>
	<c85c91a49cc62132ad1ddb97748c26b9.squirrel@webmail.greenhost.nl>
	<4F33110D.3050904@zytor.com>
	<13c2c571244c71c2ba87451987805eed.squirrel@webmail.greenhost.nl>
	<4F334B8C.2050005@zytor.com>
Date: Thu, 9 Feb 2012 08:00:53 -0800
Message-ID: <CAMe9rOrf-DrgdwsnpX7pa=h1p9qSpqa9fwJAQJvjSzgR9MAB_w@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Indan Zupancic <indan@nul.nu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Jamie Lokier <jamie@shareable.org>,
        Andrew Lutomirski <luto@mit.edu>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 8:29 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/08/2012 08:20 PM, Indan Zupancic wrote:
>>
>> CS is already available to user space, but any other value than 0x23 or 0x33
>> will confuse user space, as that is all they know about. Apparently Xen uses
>> different values, but if those are static then user space can check for them
>> separately. But if the values change dynamically then some other way may be
>> needed.
>>
>> But does it make much sense to pass the CPU mode of user space if that mode
>> can be changed at any moment? I don't think it really does. Can you give an
>> example of how that info can be used by a ptracer?
>>
>
> Uh... you could make THAT argument about ANY register state!
>
> I believe H.J. can fill you in about the usage.
>

GDB uses CS value to tell ia32 process from x86-64 process.
At minimum, we need a bit in CS for GDB.  But any changes
will break old GDB.

H.J.
