Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab1AEDBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 22:01:49 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:55843 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1AEDBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 22:01:48 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC patch 3/5] ftrace trace event add missing semicolumn
In-Reply-To: Your message of "Wed, 05 Jan 2011 03:08:02 +0100."
             <20110105020759.GG2911@nowhere>
From: Valdis.Kletnieks@vt.edu
References: <20110104231629.996422888@efficios.com> <20110104232419.441463699@efficios.com> <20110105000005.GE2911@nowhere> <20110105001837.GA9737@Krystal>
            <20110105020759.GG2911@nowhere>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1294196493_4845P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Jan 2011 22:01:33 -0500
Message-ID: <12932.1294196493@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4D23DF10.0086,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1294196493_4845P
Content-Type: text/plain; charset=us-ascii

On Wed, 05 Jan 2011 03:08:02 +0100, Frederic Weisbecker said:
> On Tue, Jan 04, 2011 at 07:18:37PM -0500, Mathieu Desnoyers wrote:

> > > > --- linux-2.6-lttng.orig/include/trace/ftrace.h
> > > > +++ linux-2.6-lttng/include/trace/ftrace.h
> > > > @@ -69,7 +69,7 @@
> > > >  #undef DEFINE_EVENT
> > > >  #define DEFINE_EVENT(template, name, proto, args)	\
> > > >  	static struct ftrace_event_call	__used		\
> > > > -	__attribute__((__aligned__(4))) event_##name
> > > > +	__attribute__((__aligned__(4))) event_##name;

> > Adding this semicolumn here ensures that all Ftrace macros are consistent wrt
> > semicolumns. We can get away without consistency currently exactly because the
> > current scheme adds many useless semicolumns between each TRACE_EVENT().

> Are you sure you want to put so much time on this?

> This will require a massive change for the sole win of removing double ";"
> in generated code. This won't optimize much the build, and it will make the things
> not so much more readable for very rare people who dare to have interest into the
> TRACE_EVENT generated code. That notwithstanding the obfuscation of that generated
> code resides more in the lack of indentation and newlines than in double
> semicolons that we barely notice.

Can DEFINE_EVENT ever be sensibly used in a context where the additional ; will
cause an issue (for instance, a hypothetical array initialization like:

static struct events[] = {DEFINE_EVENT(..), DEFINE_EVENT(...) }

or other places we usually do the 'do { X } while (0)' trick to make the code legal?


--==_Exmh_1294196493_4845P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNI98NcC3lWbTT17ARAv+3AKDh/fn+jdvpnM0YLbLH3SZS9ZOyAACg7R5Q
K3U9KWIZXkeHFtmkpPWLfaI=
=Q17B
-----END PGP SIGNATURE-----

--==_Exmh_1294196493_4845P--

