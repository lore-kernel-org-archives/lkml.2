Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab1ITWTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 18:19:53 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:33487 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab1ITWTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 18:19:52 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for this_cpu_read/write()
In-Reply-To: Your message of "Tue, 20 Sep 2011 11:19:47 EDT."
             <1316531987.29966.65.camel@gandalf.stny.rr.com>
From: Valdis.Kletnieks@vt.edu
References: <20110919212040.745370781@goodmis.org> <alpine.DEB.2.00.1109191644190.19059@router.home> <1316487977.29966.32.camel@gandalf.stny.rr.com> <27409.1316522696@turing-police.cc.vt.edu> <alpine.DEB.2.00.1109200955190.8056@router.home>
            <1316531987.29966.65.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316557072_2679P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 20 Sep 2011 18:17:52 -0400
Message-ID: <25599.1316557072@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4E791114.00B7,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316557072_2679P
Content-Type: text/plain; charset=us-ascii

On Tue, 20 Sep 2011 11:19:47 EDT, Steven Rostedt said:
> On Tue, 2011-09-20 at 09:57 -0500, Christoph Lameter wrote:
> 
> > this_cpu_xx functions are made for those locations that have
> > preemption enabled. If you can use those function (classic case is a
> > per cpu counter increment in the network subsystem) then you can avoid
> > preempt disable/enable or get_cpu/put_cpu.
> 
> If the variables are used for a very short time, then the latencies
> introduced by a simple:
> 
> 	var = get_cpu_var(my_var);
> 	if (var)
> 		do_something_quick();
> 	put_cpu_var(my_var);
> 
> Otherwise if that do_something_quick(); migrates, it may be doing
> something it shouldn't be doing!

This has the added advantage of making the calling function take the blame
in latency traces, doesn't it?

--==_Exmh_1316557072_2679P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOeREQcC3lWbTT17ARAluuAKDV2kPqEAgeJJZ8tKHi3NMhtLc6/gCcD4Rv
UXPeTNuf11K6J9iOOiKNPUI=
=NIQb
-----END PGP SIGNATURE-----

--==_Exmh_1316557072_2679P--

