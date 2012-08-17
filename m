Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab2HQA4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 20:56:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54177 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab2HQA4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 20:56:46 -0400
Date: Fri, 17 Aug 2012 10:56:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Namhyung Kim <namhyung@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-Id: <20120817105633.0aba80ddf7eb9523e04c264d@canb.auug.org.au>
In-Reply-To: <20120816194651.GK2445@linux.vnet.ibm.com>
References: <20120816131236.13013e1ec18b1f1074f6dc92@canb.auug.org.au>
	<20120816194651.GK2445@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Aug_2012_10_56_33_+1000_koGK1pFl/2YDOtkW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Aug_2012_10_56_33_+1000_koGK1pFl/2YDOtkW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Thu, 16 Aug 2012 12:46:51 -0700 "Paul E. McKenney" <paulmck@linux.vnet.i=
bm.com> wrote:
>
> On Thu, Aug 16, 2012 at 01:12:36PM +1000, Stephen Rothwell wrote:
> >=20
> > After merging the tip tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >=20
> > drivers/infiniband/hw/ehca/ehca_irq.c: In function 'find_next_online_cp=
u':
> > drivers/infiniband/hw/ehca/ehca_irq.c:672:2: error: expected ';' before=
 'spin_unlock_irqrestore'
> >=20
> > Caused by commit 81942621bd6b ("infiniband: Ehca: Use hotplug thread
> > infrastructure").
> >=20
> > I have used the tip tree from next-20120814 for today.
>=20
> My first reaction was "we tested that!!!", but I see the conversion
> from while(1) to do-while.  Does the following cure it?

Yes, that fixes the build problem.

However, the same commit is also responsible for all these new warnings:

drivers/infiniband/hw/ehca/ehca_irq.c: In function 'queue_comp_task':
drivers/infiniband/hw/ehca/ehca_irq.c:710:9: warning: assignment from incom=
patible pointer type
drivers/infiniband/hw/ehca/ehca_irq.c:719:10: warning: assignment from inco=
mpatible pointer type
drivers/infiniband/hw/ehca/ehca_irq.c: In function 'comp_task_park':
drivers/infiniband/hw/ehca/ehca_irq.c:764:9: warning: assignment from incom=
patible pointer type
drivers/infiniband/hw/ehca/ehca_irq.c: In function 'comp_task':
drivers/infiniband/hw/ehca/ehca_irq.c:803:1: warning: no return statement i=
n function returning non-void
drivers/infiniband/hw/ehca/ehca_irq.c: At top level:
drivers/infiniband/hw/ehca/ehca_irq.c:807:2: warning: initialization from i=
ncompatible pointer type

Please address these.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__17_Aug_2012_10_56_33_+1000_koGK1pFl/2YDOtkW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQLZbBAAoJEECxmPOUX5FEnu4P/1t9ouJScG2zys2fwuk/woS1
lxyoTyHj6mZ6kkvObYRhnhMs/CvilJlqvxZrYOyX9D9wUKRQiYLJNpKfqhUjF+7U
MIRT4CyIzUY5y0xErVIvv7cTfP3+ijzAjy0JkNbKQYuvsdfD/n40hVQDfzvMDMQ/
K1ntuE3eu7p4JnRaFRvbn13nemOY+2QNYHOdj1Y8VZIzjmS1LASnq4ItEpB1OKdh
S0+5HXi90+/GsXAvQlX2xKJXtQywg3nzVDc3x/9B+sGGaMd9cBS5uSLNjzj5bGtd
IhnFMlnxCDDjgh2nAo4tpHR6BYb49PeNay71z+23yhhWdeuXTz3iVYXMu4+rc7dz
HEMnRone2P6OjFHshjdjlbr7cBaAkQmnSnduQXQXXjncxzYmNBicWVFLzqP0M8ow
lTibOoeMoMEO30KFyJnXCab7dFxILC7f0uUH82uMAuWuYkZdV5T3xI2fcZI8CE2Q
JIgRRqPn3bOWOgTfYt+RAuwVllN9RdohEc0bkTnQo467jSLlTg6APA4ltnxyThBJ
Hi8ZrAYMk65U0nGf06kB2LBb2vBqTkBd47jN3vv8Rdu6kWyc5aCVZS+k/aXq/AcI
08zJoxzuC8Hh8R8RPjPzbN6lPVAwuEq9TxJFfjOB7Zr+k84xZ0a3cBVsIRB9tDmg
xqMTsAJGtW89Mb3/Jp6m
=zNUV
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Aug_2012_10_56_33_+1000_koGK1pFl/2YDOtkW--
