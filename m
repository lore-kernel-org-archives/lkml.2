Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab2BFUqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 15:46:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60649 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314Ab2BFUqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 15:46:22 -0500
Message-ID: <4F303B23.4020609@zytor.com>
Date: Mon, 06 Feb 2012 12:42:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Roland McGrath <mcgrathr@google.com>
CC: Denys Vlasenko <vda.linux@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
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
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
References: <20120116183730.GB21112@redhat.com> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl> <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com> <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com> <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl> <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com> <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com> <4F1731C1.4050007@zytor.com> <4F1733DF.7040905@zytor.com> <4F1737C9.3070905@zytor.com> <CAB=4xhqW8RK2UpU5PPjSQo3nZYt8oZkaBf1VEhX37tbMVrAigg@mail.gmail.com> <4F173F48.2070604@zytor.com> <CA+55aFw3kv_JRsSCQEf6fQd0gX939MuoevDxFtcXkPY+bmyjtA@mail.gmail.com> <4F176605.5020101@zytor.com> <CAK1hOcManWsEvjS2xxtfGTKx=JLPvO2sBkWU-xQP+medV=rbAA@mail.gmail.com> <CAB=4xhqFYdU3s_NQkgdzVVG1r3vGDb=qPewPRFTrJ1B_eiEVDA@mail.gmail.com> <4F30387A.9040209@zytor.com> <CAB=4xhrGqGi-XoG9xG=XrOkdSJeshxQ2WKw7TRO1XeKBuz+J4A@mail.gmail.com>
In-Reply-To: <CAB=4xhrGqGi-XoG9xG=XrOkdSJeshxQ2WKw7TRO1XeKBuz+J4A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 12:39 PM, Roland McGrath wrote:
> On Mon, Feb 6, 2012 at 12:30 PM, H. Peter Anvin<hpa@zytor.com>  wrote:
>> What is needed to make a regset variable-sized?  Just declaring that it
>> may change in size in the future, or does one need a length field at the
>> top (I would personally have expected that both notes and ptrace would
>> have out-of-band methods for getting the size?)
>
> ELF notes do have a size field, so core files are self-explanatory.  There
> is no ptrace interface to directly interrogate the regset details (one
> could be added).  But the PTRACE_GETREGSET interface is to accept an upper
> bound and yield the actual size filled in (which might be less than the
> regset's size if the user-supplied buffer was smaller).  So in practice, a
> caller can just use a buffer that's sure to be large enough, and then look
> at iov_len for the actual size delivered.  (And nobody has yet complained
> about this for xstate, though that might just be that nobody is really
> using it.)
>

That should be fine, since you'd just set it to the size of the fields 
that you know about, and if there are additional fields that you don't 
know about, you logically don't care about them.  If you want to dump 
the full set of data you'd just read until you get a short read... like 
if you were reading a regular file.

	-hpa

