Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437Ab2GCTiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:38:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51348 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032Ab2GCTiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:38:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120703152203.065838cb@tlielax.poochiereds.net>
References: <CALCETrVOwRyrBXDu0G=JE3dtwmXFNV6dAEHVPXYoJfUf6s2==w@mail.gmail.com>
 <CAH2r5muEUANOjGCkP40LfFF3XtkKKtf9RAabzt-1H+xn1v5ccg@mail.gmail.com>
 <CALCETrWnXh9cDMzF2=yo7XqvgmPGeSPQ+uXYkniVXP4PuRoQCw@mail.gmail.com>
 <CALCETrV=7DrqzNBLBdUVycM8471+vfA5H3Hf7-PTjanH0K8=gg@mail.gmail.com> <20120703152203.065838cb@tlielax.poochiereds.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 3 Jul 2012 12:37:44 -0700
Message-ID: <CALCETrVLG5y6B-DWHX_5pOMifxq562VM9LYVgpNNa5qoEKUhHg@mail.gmail.com>
Subject: Re: 3.5.0-rc3 (approximately) oops on cifs mount
To: Jeff Layton <jlayton@redhat.com>
Cc: Steve French <smfrench@gmail.com>, linux-kernel@vger.kernel.org,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 12:22 PM, Jeff Layton <jlayton@redhat.com> wrote:
> On Tue, 3 Jul 2012 11:59:02 -0700
> Andy Lutomirski <luto@amacapital.net> wrote:
>
>> On Mon, Jul 2, 2012 at 5:28 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> > On Mon, Jul 2, 2012 at 5:21 PM, Steve French <smfrench@gmail.com> wrote:
>> >> Any recreation information?
>> >
>> > I think it was a result of trying to mount with an incorrect password,
>> > which surprises me a bit.  I'll try to reproduce in a little bit.
>>
>> Correction: it was not a wrong password -- I mounted with the correct
>> password.  So far, I can't reproduce it.
>>
>> --Andy
>>
>
> It crashed here:
>
>     BUG_ON(cpu >= nr_cpu_ids && cpu != WORK_CPU_UNBOUND);
>
> Very odd. Seems almost like this must be some sort of memory
> corruption. The work is initialized just a little bit before it gets
> queued. The only thing I can figure is that something raced in and
> clobbered the work struct beforehand.
>
> One thing you could do -- maybe disassemble get_work_gcwq() and post
> the results here? Maybe from that we can see what the "cpu" value
> actually was by figuring out the register that holds it?

I'll see if I can find an identical kernel build.  Unfortunately, I
hit this oops after building and installing a new kernel but before
rebooting into it.

--Andy

>
> --
> Jeff Layton <jlayton@redhat.com>



-- 
Andy Lutomirski
AMA Capital Management, LLC
