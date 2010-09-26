Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab0IZJNe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 05:13:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34058 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab0IZJNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 05:13:30 -0400
Date: Sun, 26 Sep 2010 11:13:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Brian Gerst <brgerst@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
        mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: what's papered over by set_fs(USER_DS) in amd64 signal delivery?
Message-ID: <20100926091306.GA3857@elte.hu>
References: <20100924155231.GQ19804@ZenIV.linux.org.uk>
 <AANLkTik+1k76vGccjwQWeEWZFng61ZoodDyWbN8wvPgE@mail.gmail.com>
 <20100924165716.GR19804@ZenIV.linux.org.uk>
 <AANLkTikV5O1QxYEHRzZzCrE=VSWj8aV6nA5Z3QOTxtL=@mail.gmail.com>
 <20100925024804.GS19804@ZenIV.linux.org.uk>
 <AANLkTikKtK1s8mGF4chhLtXRJW1G43BKAAY3wC-EVbQH@mail.gmail.com>
 <20100925052054.GU19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100925052054.GU19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1653]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> [...]  IOW, that set_fs() seems to have been useless from the day 1, 
> unless I'm missing something really subtle, like e.g. some processes 
> deliberately running (in 2.0) with %fs set to something with lower 
> limit, with signal handlers allowed to switch back to normal for 
> duration.  And even that would've been broken, since there wouldn't be 
> a matching set_fs() in sigreturn()...

I dont recall us ever having done anything particularly 'clever' with 
in-kernel set_fs()/restore_fs(). Beyond fork/clone it was always 
supposed to be set/restored in a balanced manner. We sometimes leaked it 
unintentionally, and those were security holes.

( Cleverness with security primitives was in fact always actively
  discouraged, even in the early days, as cleverness has the uncanny
  tendency to bit-rot and then has the tendency to slow-convert to a
  security hole by stealth. We always wanted obvious, boringly dumb,
  fail-safe primitives, which can take a few years of bitrot robustly. )

Thanks,

	Ingo
