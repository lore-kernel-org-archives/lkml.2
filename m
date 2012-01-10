Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab2AJQxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:53:32 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51482 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab2AJQxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:53:31 -0500
Message-ID: <1326214407.19095.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [BUG] kernel freezes with latest tree
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 10 Jan 2012 17:53:27 +0100
In-Reply-To: <CA+55aFyyZUJHELdbKfk2Gzpx9np7Ov74idttCo6+wi2+MAVG=g@mail.gmail.com>
References: <1326171444.6638.3.camel@edumazet-laptop>
	 <1326171798.6638.4.camel@edumazet-laptop>
	 <1326183371.6638.6.camel@edumazet-laptop>
	 <1326212033.19095.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+55aFwNVutn=Z8N9k3CHLri=EKWX2UcN8skZvMfJ9Tg1LHCpg@mail.gmail.com>
	 <1326213442.19095.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+55aFyyZUJHELdbKfk2Gzpx9np7Ov74idttCo6+wi2+MAVG=g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 10 janvier 2012 à 08:49 -0800, Linus Torvalds a écrit :
> On Tue, Jan 10, 2012 at 8:37 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > Just to make sure I understood well, here is what I tested :
> 
> Yup, that was it.
> 
> That was the obvious thing about the merge to check.
> 
> I suspect that what remains is now the sparse cleanups and
> usecs_to_cputime64() interaction. I note that you are running on a
> 32-bit setup, which is where such problems would show up (because any
> new casts to "unsigned long" due to the forced sparse casting would
> now actually truncate a 64-bit value down.
> 
> Just to test that theory, can you try this attached patch that simply
> removes the casts? That's what we used to have before adding the
> stricter type-checking (other things changed too, so this may not make
> any difference, but this is a "test a small change to *maybe* narrow
> things down")
> 
> Martin - mind re-running sparse on the 32-bit case to see if that
> shows some messed-up case?
> 
>                    Linus

I am compiling your patch, but I want to point out that I got also
lockups on my 64bit dev machine.

(But alas, my git bisect attempt on it stopped on un bootable kernels)



