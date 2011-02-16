Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab1BPXPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 18:15:41 -0500
Received: from orca.ele.uri.edu ([131.128.51.63]:56504 "EHLO orca.ele.uri.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699Ab1BPXPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 18:15:33 -0500
X-Greylist: delayed 1350 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Feb 2011 18:15:33 EST
From: "Will Simoneau" <simoneau@ele.uri.edu>
Date: Wed, 16 Feb 2011 17:51:51 -0500
To: Will Newton <will.newton@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, David Miller <davem@davemloft.net>,
        hpa@zytor.com, matt@console-pimps.org, peterz@infradead.org,
        jbaron@redhat.com, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        vapier@gentoo.org, cmetcalf@tilera.com, dhowells@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
Message-ID: <20110216225151.GA10435@ele.uri.edu>
References: <4D59B891.8010300@zytor.com>
 <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
 <20110215211123.GA3094@ele.uri.edu>
 <20110215.132702.39199169.davem@davemloft.net>
 <20110215215604.GA3177@ele.uri.edu>
 <AANLkTikXy+AJ3tdEkEN--xJPefbXJ4-OVS3cg6R7yXzc@mail.gmail.com>
 <1297858734.23343.138.camel@gandalf.stny.rr.com>
 <AANLkTinzr6rb=WwFs7QApsvdy5f7PHZ1qS9ZVrncEzZD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <AANLkTinzr6rb=WwFs7QApsvdy5f7PHZ1qS9ZVrncEzZD@mail.gmail.com>
User-Agent: Mutt/1.5.21 [Linux 2.6.34 x86_64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12:41 Wed 16 Feb     , Will Newton wrote:
> On Wed, Feb 16, 2011 at 12:18 PM, Steven Rostedt <rostedt@goodmis.org> wr=
ote:
> > I'm curious, how is cmpxchg() implemented on this architecture? As there
> > are several places in the kernel that uses this on regular variables
> > without any "accessor" functions.
>=20
> We can invalidate the cache manually. The current cpu will see the new
> value (post-cache invalidate) and the other cpus will see either the
> old value or the new value depending on whether they read before or
> after the invalidate, which is racy but I don't think it is
> problematic. Unless I'm missing something...

If I understand this correctly, the manual invalidates must propagate to
all CPUs that potentially read the value, even if there is no
contention. Doesn't this involve IPIs? How does it not suck?

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk1cVQcACgkQLYBaX8VDLLXPqQCcDEOj0G7rborY20dv8QOrT9TY
S+cAoKeCEVbDMbuCMn2KN+PTvoigZiZh
=daK4
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
