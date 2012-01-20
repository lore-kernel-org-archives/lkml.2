Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab2ATXuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 18:50:00 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:44927 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab2ATXt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 18:49:58 -0500
Message-ID: <d8be1991e82ec686433c5c6e255c2bd9.squirrel@webmail.greenhost.nl>
In-Reply-To: <4F19EDAF.2000109@zytor.com>
References: <20120116183730.GB21112@redhat.com>
    <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
    <20120118022217.GS11715@one.firstfloor.org>
    <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
    <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
    <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
    <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
    <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
    <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com>
    <4F1731C1.4050007@zytor.com> <4F1733DF.7040905@zytor.com>
    <4F1737C9.3070905@zytor.com>
    <CAB=4xhqW8RK2UpU5PPjSQo3nZYt8oZkaBf1VEhX37tbMVrAigg@mail.gmail.com>
    <4F173F48.2070604@zytor.com>
    <CA+55aFw3kv_JRsSCQEf6fQd0gX939MuoevDxFtcXkPY+bmyjtA@mail.gmail.com>
    <4F176605.5020101@zytor.com>
    <CAK1hOcManWsEvjS2xxtfGTKx=JLPvO2sBkWU-xQP+medV=rbAA@mail.gmail.com>
    <CAB=4xhqFYdU3s_NQkgdzVVG1r3vGDb=qPewPRFTrJ1B_eiEVDA@mail.gmail.com>
    <4F19EDAF.2000109@zytor.com>
Date: Sat, 21 Jan 2012 00:49:24 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
From: "Indan Zupancic" <indan@nul.nu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Roland McGrath" <mcgrathr@google.com>,
        "Denys Vlasenko" <vda.linux@googlemail.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>,
        "Jamie Lokier" <jamie@shareable.org>,
        "Andrew Lutomirski" <luto@mit.edu>, "Oleg Nesterov" <oleg@redhat.com>,
        "Will Drewry" <wad@chromium.org>, linux-kernel@vger.kernel.org,
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
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 1.4
X-Scan-Signature: a350ae07b5350cdad28cef237d2e7179
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, January 20, 2012 23:41, H. Peter Anvin wrote:
> On 01/20/2012 02:40 PM, Roland McGrath wrote:
>> If you change the size of a regset, then the new full size will be the size
>> of the core file notes.  Existing userland tools will not be expecting
>> this, they expect a known exact size.  If you need to add new stuff, it
>> really is easier all around to add a new regset flavor.  When adding a new
>> one, you can make it variable-sized from the start so as to be extensible
>> in the future.  We did this for NT_X86_XSTATE, for example.
>>
>
> Yes, that definitely seems cleaner.

I would prefer Linus' way of just stuffing it into cs. Jamie also wanted
a bit telling in what mode the userspace is running. That's 3 bits in total,
with one bit telling whether the other bits are valid or not. Anything else?
Maybe a bit telling whether it is syscall entry or exit?

As all this is very x86_64 specific and cs is already used to figure out
the mode, it seems overkill to add a new regset just for this.

It's a lot easier for existing code to add an extra cs check than to use
different register sets and different ptrace commands. Considering that
PTRACE_GETREGSET is undocumented it's likely that existing code isn't
using it much.

Greetings,

Indan


