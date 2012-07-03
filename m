Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab2GCR5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 13:57:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906Ab2GCR5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 13:57:21 -0400
Date: Tue, 3 Jul 2012 19:57:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Calvin Walton <calvin.walton@kepstin.ca>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Subject: Re: long boot delays caused by 070ad7e7 floppy change
In-Reply-To: <CA+55aFzOD33eWj0FQuZ7RWmF-yYwaeNB-9J-YY+mX4mwP7VXuA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1207031953570.17304@pobox.suse.cz>
References: <20120702224648.GA20361@tassilo.jf.intel.com> <CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com> <1341323230.3292.10.camel@nayuki.kepstin.ca> <CA+55aFyvzz3Lp9zeA6X+QMan0iZFWq_0Xd+ff_trnP1tpn2iJQ@mail.gmail.com>
 <1341337257.2406.1.camel@nayuki.kepstin.ca> <CA+55aFzOD33eWj0FQuZ7RWmF-yYwaeNB-9J-YY+mX4mwP7VXuA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2012, Linus Torvalds wrote:

> > Ok, here's the dmesg output that I get:
> >
> > [    0.714316] floppy0: lock_fdc: -1 (out of 8)
> 
> Ok, thanks. That -1 definitely explains the long delay. It's using
> "drive=-1" because it has no actual drive number, just the
> *controller* number.
> 
> And the backtrace shows what's going on too: it's the
> 
>   user_reset_fdc(-1, FD_RESET_ALWAYS, false);
> 
> that passes in -1 as the floppy controller number.
> 
> Ugh.
> 
> It looks like the code meant for -1 to mean "regular delay"
> (current_reqD), and -2 to mean MAXTIMEOUT. For some reason the "-1"
> logic has gotten screwed.

I am still trying to understand the exact situation.

Andi, do I understand you correctly that even if you revert 070ad7e793dc 
on top of current Linus' tree, you are still seeing the 20 second delay 
inside the initcall?

-- 
Jiri Kosina
SUSE Labs
