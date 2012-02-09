Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab2BIOxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:53:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55694 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757653Ab2BIOxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:53:20 -0500
Message-ID: <4F33DC9A.1090909@zytor.com>
Date: Thu, 09 Feb 2012 06:47:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
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
        ak@linux.intel.com, eric.dumazet@gmail.com, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
References: <20120116183730.GB21112@redhat.com>    <20120118015013.GR11715@one.firstfloor.org>    <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>    <20120118022217.GS11715@one.firstfloor.org>    <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>    <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>    <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>    <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>    <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>    <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com>    <dac05d1da093cb86e2f654fbfe66dfce.squirrel@webmail.greenhost.nl>    <4F3007AD.50307@zytor.com>    <c85c91a49cc62132ad1ddb97748c26b9.squirrel@webmail.greenhost.nl>    <4F33110D.3050904@zytor.com>    <13c2c571244c71c2ba87451987805eed.squirrel@webmail.greenhost.nl>    <4F334B8C.2050005@zytor.com> <5f13059f9b57d2a0fe2be094702b8177.squirrel@webmail.greenhost.nl>
In-Reply-To: <5f13059f9b57d2a0fe2be094702b8177.squirrel@webmail.greenhost.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 10:03 PM, Indan Zupancic wrote:
>
> You can check the syscall instruction itself, either before it's executed
> or afterwards by checking the IP. Though that's trickier, because the
> kernel points the IP to just after int80 for a sysenter call, so you have
> to check if there's a sysenter nearby too.
>

No, that's a total nightmare.  FAIL.

> But the kernel is actually changing the registers, so why hide that?
>
> I mean, once user space is aware that the kernel may do swizzling, is there
> any actual problem left? Because this sounds like user space was trying to
> be clever, but got it wrong. E.g. it knew the kernel was entered not via
> int80, but then got confused because of the swizzling.

I would be great if we didn't have an existing compatibility problem. 
As it is we can't get rid of it easily.

	-hpa

