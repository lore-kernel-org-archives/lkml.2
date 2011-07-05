Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab1GEWWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 18:22:24 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47266 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab1GEWWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 18:22:22 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Beulich <JBeulich@novell.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 5/6] x86: Remove useless unwinder backlink from irq regs saving
In-Reply-To: Your message of "Mon, 04 Jul 2011 15:22:23 +0200."
             <20110704132158.GA5551@somewhere>
From: Valdis.Kletnieks@vt.edu
References: <1309624184-9790-1-git-send-email-fweisbec@gmail.com> <1309624184-9790-6-git-send-email-fweisbec@gmail.com> <4E1187E4020000780004BF2C@nat28.tlf.novell.com>
            <20110704132158.GA5551@somewhere>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1309904488_18528P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Jul 2011 18:21:28 -0400
Message-ID: <61768.1309904488@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4E138E6C.00AE,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1309904488_18528P
Content-Type: text/plain; charset=us-ascii

On Mon, 04 Jul 2011 15:22:23 +0200, Frederic Weisbecker said:
> On Mon, Jul 04, 2011 at 08:29:08AM +0100, Jan Beulich wrote:
> > >>> On 02.07.11 at 18:29, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > The unwinder backlink in interrupt entry is very useless.
> > > It's actually not part of the stack frame chain and thus is
> > > never used.
> > 
> > I very much doubt this - see dump_trace()'s comment in its IRQ-stack
> > related code portion (and the corresponding use of irq_stack_end[-1]).
> > 
> > Jan
> 
> Good point. I misunderstood that.
> 
> But then I believe I accidentally fixed it back in
> "x86: Don't use frame pointer to save old stack on irq entry" by
> pushing %rsi instead in the new stack. It contains the backlink to
> the old stack.
> 
> If we keep the macro as-is, I'll add a comment to explain further
> what is involved there.

Ahh.. I was wondering why there wasn't suddenly a very lonely popq
out there... :)

--==_Exmh_1309904488_18528P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOE45ocC3lWbTT17ARAtHHAJ99FxIHzak73r8p/IfHFg1Uaj6aLQCg662k
PDlq/BBgcxYMu3NKjXVwLcs=
=zeKm
-----END PGP SIGNATURE-----

--==_Exmh_1309904488_18528P--

