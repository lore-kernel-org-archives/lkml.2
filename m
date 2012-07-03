Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab2GCTWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:22:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab2GCTWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:22:07 -0400
Date: Tue, 3 Jul 2012 15:22:03 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Steve French <smfrench@gmail.com>, linux-kernel@vger.kernel.org,
        linux-cifs@vger.kernel.org
Subject: Re: 3.5.0-rc3 (approximately) oops on cifs mount
Message-ID: <20120703152203.065838cb@tlielax.poochiereds.net>
In-Reply-To: <CALCETrV=7DrqzNBLBdUVycM8471+vfA5H3Hf7-PTjanH0K8=gg@mail.gmail.com>
References: <CALCETrVOwRyrBXDu0G=JE3dtwmXFNV6dAEHVPXYoJfUf6s2==w@mail.gmail.com>
	<CAH2r5muEUANOjGCkP40LfFF3XtkKKtf9RAabzt-1H+xn1v5ccg@mail.gmail.com>
	<CALCETrWnXh9cDMzF2=yo7XqvgmPGeSPQ+uXYkniVXP4PuRoQCw@mail.gmail.com>
	<CALCETrV=7DrqzNBLBdUVycM8471+vfA5H3Hf7-PTjanH0K8=gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2012 11:59:02 -0700
Andy Lutomirski <luto@amacapital.net> wrote:

> On Mon, Jul 2, 2012 at 5:28 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> > On Mon, Jul 2, 2012 at 5:21 PM, Steve French <smfrench@gmail.com> wrote:
> >> Any recreation information?
> >
> > I think it was a result of trying to mount with an incorrect password,
> > which surprises me a bit.  I'll try to reproduce in a little bit.
> 
> Correction: it was not a wrong password -- I mounted with the correct
> password.  So far, I can't reproduce it.
> 
> --Andy
> 

It crashed here:

    BUG_ON(cpu >= nr_cpu_ids && cpu != WORK_CPU_UNBOUND);

Very odd. Seems almost like this must be some sort of memory
corruption. The work is initialized just a little bit before it gets
queued. The only thing I can figure is that something raced in and
clobbered the work struct beforehand.

One thing you could do -- maybe disassemble get_work_gcwq() and post
the results here? Maybe from that we can see what the "cpu" value
actually was by figuring out the register that holds it?

-- 
Jeff Layton <jlayton@redhat.com>
