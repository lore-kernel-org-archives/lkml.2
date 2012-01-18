Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab2ARVuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 16:50:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32985 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab2ARVuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 16:50:03 -0500
Message-ID: <4F173DD5.9000308@zytor.com>
Date: Wed, 18 Jan 2012 13:47:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
        Jamie Lokier <jamie@shareable.org>, Andrew Lutomirski <luto@mit.edu>,
        Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
References: <20120116183730.GB21112@redhat.com> <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl> <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk> <20120118022217.GS11715@one.firstfloor.org> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl> <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com> <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com> <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl> <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com> <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com> <4F1731C1.4050007@zytor.com> <CA+55aFwnvOxT_K7HFOkjCbfDtYkAVkvF+a7r-0=T6gga_x9t-g@mail.gmail.com> <4F1733DF.7040905@zytor.com> <CA+55aFzrHaJUKgUCx1uaeuqcyzZuUwQLiGj9dP5D3m-xt6v2SA@mail.gmail.com> <4F1739F1.2070902@zytor.com> <CA+55aFzEetCjgN4=2_+s2roN7GnBOhvbbz=u5x2n=-hvqYA41w@mail.gmail.com>
In-Reply-To: <CA+55aFzEetCjgN4=2_+s2roN7GnBOhvbbz=u5x2n=-hvqYA41w@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 01:42 PM, Linus Torvalds wrote:
> On Wed, Jan 18, 2012 at 1:30 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> I would have assumed it would be a new register set (which could be
>> expanded in the future if we have additional system information to provide.)
> 
> Well, I really don't think we want to expose much. In fact, I'd argue
> we should expose as little as humanly possible.
> 
> Which at this point is literally just a single bit (and effectively
> another bit to say "we support the new feature").
> 
> So...
> 

I actually think we need to also have a bit for some of the 32-bit entry
point differences, since the registers have different meanings for them.
 We have kluges in place for them, but those kluges cause their own
problems when registers are modified.

So that means at least four states (SYSCALL64, SYSENTER, SYSCALL32, INT
80) plus the presence bit.  Furthermore, three out of those states apply
even to pure 32-bit kernels.

	-hpa
