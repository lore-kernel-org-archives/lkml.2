Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab2BIEcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 23:32:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52440 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430Ab2BIEcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 23:32:17 -0500
Message-ID: <4F334B8C.2050005@zytor.com>
Date: Wed, 08 Feb 2012 20:29:00 -0800
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
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
References: <20120116183730.GB21112@redhat.com>    <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>    <20120118015013.GR11715@one.firstfloor.org>    <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>    <20120118022217.GS11715@one.firstfloor.org>    <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>    <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>    <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>    <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>    <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>    <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com>    <dac05d1da093cb86e2f654fbfe66dfce.squirrel@webmail.greenhost.nl>    <4F3007AD.50307@zytor.com>    <c85c91a49cc62132ad1ddb97748c26b9.squirrel@webmail.greenhost.nl>    <4F33110D.3050904@zytor.com> <13c2c571244c71c2ba87451987805eed.squirrel@webmail.greenhost.nl>
In-Reply-To: <13c2c571244c71c2ba87451987805eed.squirrel@webmail.greenhost.nl>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 08:20 PM, Indan Zupancic wrote:
> 
> CS is already available to user space, but any other value than 0x23 or 0x33
> will confuse user space, as that is all they know about. Apparently Xen uses
> different values, but if those are static then user space can check for them
> separately. But if the values change dynamically then some other way may be
> needed.
> 
> But does it make much sense to pass the CPU mode of user space if that mode
> can be changed at any moment? I don't think it really does. Can you give an
> example of how that info can be used by a ptracer?
> 

Uh... you could make THAT argument about ANY register state!

I believe H.J. can fill you in about the usage.

> 
> Only confusion I can think of is someone following the register values
> across a systemcall instruction. Then the swizzling may be unexpected.
> But if they do that they could check how the sycall was entered and
> compensate for that. (I can't think of any requirement why this would
> need to be race-free.)
> 

You'd have to know how you'd entered, which right now you don't have any
way to know.

	-hpa
