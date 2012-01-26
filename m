Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab2AZSEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:04:10 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:55279 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab2AZSEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:04:08 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzDZhGoa1TH=RAtjK3Ti3=NPAYvreSxiTxTu3wnu8Z61g@mail.gmail.com>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <201201260032.57937.vda.linux@googlemail.com> <ca17a86f7c88f8884e4ffc9bafbf2dff.squirrel@webmail.greenhost.nl>
 <201201260209.54513.vda.linux@googlemail.com> <CA+55aFzDZhGoa1TH=RAtjK3Ti3=NPAYvreSxiTxTu3wnu8Z61g@mail.gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 26 Jan 2012 19:03:43 +0100
Message-ID: <CAK1hOcNFmG+3NTfQ559T-LkbcmcVfk9eF=JesdOqqj97tJncaw@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Indan Zupancic <indan@nul.nu>, Oleg Nesterov <oleg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Jamie Lokier <jamie@shareable.org>,
        Andrew Lutomirski <luto@mit.edu>, Will Drewry <wad@chromium.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, Jan 26, 2012 at 4:47 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>> Please look at strace source, get_scno() function, where
>> it reads syscall no and parameters. Let's see....
>> - POWERPC: has 32-bit and 64-bit mode
>> - X86_64: has 32-bit and 64-bit mode
>> - IA64: has i386-compat mode
>> - ARM: has more than one ABI
>> - SPARC: has 32-bit and 64-bit mode
>>
>> Do you want to re-invent a different arch-specific way to report
>> syscall type for each of these arches?
>
> I think an arch-specific one is better than trying to make some
> generic one that is messy.
>
> As you say, many architectures have multiple system call ABIs.
>
> But they tend to be very *different* issues. They can be about
> multiple ABI's, as you mention, and even when they *look* similar
> (32-bit vs 64-bit ABI's) they are actually totally different issues.
> [skip]

I don't have a particular attachment to my solution,
and I think we already talk about this problem for
far too long.

Looks like nobody is _strongly_ opposed to your patch
which uses a few bits in eflags to report bitness
of the x86 syscall.

Lets just do that already. If you commit it to kernel git,
I will immediately change strace accordingly.

-- 
vda
