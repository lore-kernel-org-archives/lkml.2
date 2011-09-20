Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1ITMrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 08:47:15 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35048 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab1ITMrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 08:47:13 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for this_cpu_read/write()
In-Reply-To: Your message of "Mon, 19 Sep 2011 23:06:17 EDT."
             <1316487977.29966.32.camel@gandalf.stny.rr.com>
From: Valdis.Kletnieks@vt.edu
References: <20110919212040.745370781@goodmis.org> <alpine.DEB.2.00.1109191644190.19059@router.home>
            <1316487977.29966.32.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316522696_2734P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 20 Sep 2011 08:44:56 -0400
Message-ID: <27409.1316522696@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4E788AD8.0030,ss=1,fgs=0,
	ip=71.62.120.57,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316522696_2734P
Content-Type: text/plain; charset=us-ascii

On Mon, 19 Sep 2011 23:06:17 EDT, Steven Rostedt said:

> It is really confusing to know which version to use. I'm confused by the
> this_cpu_*() compared with __this_cpu_*(). I'm guessing that most places
> should use __this_cpu*(). But really this_cpu() should be the default,
> and the places that can have it outside of preemption should have
> another name. Maybe use the raw_this_cpu() or safe_this_cpu(), as there
> is an irqsafe_this_cpu(). Maybe make a preemptsafe_cpu_*(). There should
> only be a very few locations that are OK to have preemption enabled when
> calling the this_cpu() code. Lets have those have the funny names and
> not be the default "this_cpu_*()".

What's the latency hit on those very few locations if we simply put our
collective foot down and not support a preemptable version of this_cpu_*()?
"Yes, you *could* preempt here, but for our collective sanity that's not
supported"...

> All this_cpu*() code, except the funny named ones, should make sure
> preemption is disabled, otherwise give a nasty warning. As that is
> usually a bug if you are using a per cpu variable and can migrate away.
> The next reference to that value may be incorrect.

You get a much prettier diffstat if you just nuke the funny named ones. ;)

But of course it's early morning and I'm still caffeine-deficient and probably
overlooking some crucial use case. ;)



--==_Exmh_1316522696_2734P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOeIrIcC3lWbTT17ARAmnGAJ9hgwtg8mCfLJdRsHpyu5M5gzyUdwCg7Gi0
IlQRYtJI8RU+nu52ObCnIrQ=
=89ZR
-----END PGP SIGNATURE-----

--==_Exmh_1316522696_2734P--

