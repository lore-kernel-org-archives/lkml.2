Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab2ASAlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 19:41:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33679 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab2ASAlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 19:41:45 -0500
Message-ID: <4F176605.5020101@zytor.com>
Date: Wed, 18 Jan 2012 16:38:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Roland McGrath <mcgrathr@google.com>, Indan Zupancic <indan@nul.nu>,
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
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
References: <20120116183730.GB21112@redhat.com> <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com> <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl> <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk> <20120118022217.GS11715@one.firstfloor.org> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl> <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com> <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com> <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl> <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com> <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com> <4F1731C1.4050007@zytor.com> <4F1733DF.7040905@zytor.com> <4F1737C9.3070905@zytor.com> <CAB=4xhqW8RK2UpU5PPjSQo3nZYt8oZkaBf1VEhX37tbMVrAigg@mail.gmail.com> <4F173F48.2070604@zytor.com> <CA+55aFw3kv_JRsSCQEf6fQd0gX939MuoevDxFtcXkPY+bmyjtA@mail.gmail.com>
In-Reply-To: <CA+55aFw3kv_JRsSCQEf6fQd0gX939MuoevDxFtcXkPY+bmyjtA@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 03:28 PM, Linus Torvalds wrote:
> On Wed, Jan 18, 2012 at 1:53 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> I think we can obviously agree that regsets is the only way to go for
>> any kind of new state.
> 
> So I really don't necessarily agree at all.
> 
> Exactly because there is a heavy burden to introducing new models.
> It's not only relatively much more kernel code, it's also relatively
> much more painful for user code. If we can hide it in existing
> structures, user code is *much* better off, because any existing code
> to get the state will just continue to work. Otherwise, you need to
> have the code to figure out the new structures (how do you compile it
> without the new kernel headers?), you need to do the extra accesses
> conditionally etc etc.
> 
> There's a real cost to introducing new interfaces. There's a *reason*
> people try to make do with old ones.
> 

Of course.  However, the whole point with regsets is that at the very
least the vast majority of the infrastructure is generic and extends
without a bunch of new machine.  What you are saying is "we might be
able to get away with existing state", what I'm saying is "if we add
state it should be a regset".

The question if this should be new state is currently open.  I
personally would still would prefer if this didn't overlay real CPU state.

	-hpa


