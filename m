Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab0LVVoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 16:44:34 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:38200 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab0LVVoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 16:44:32 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        jmorris@namei.org, eric.dumazet@gmail.com, tgraf@infradead.org,
        eugeneteo@kernel.org, kees.cook@canonical.com, davem@davemloft.net,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        eparis@parisplace.org
Subject: Re: [PATCH v5] kptr_restrict for hiding kernel pointers
In-Reply-To: Your message of "Wed, 22 Dec 2010 12:17:59 EST."
             <1293038279.9820.250.camel@dan>
From: Valdis.Kletnieks@vt.edu
References: <1293037246.9820.236.camel@dan> <20101222171307.GA25611@elte.hu>
            <1293038279.9820.250.camel@dan>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1293054216_7139P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 22 Dec 2010 16:43:36 -0500
Message-ID: <34753.1293054216@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4D12710A.0131,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1293054216_7139P
Content-Type: text/plain; charset=us-ascii

On Wed, 22 Dec 2010 12:17:59 EST, Dan Rosenberg said:
> On Wed, 2010-12-22 at 18:13 +0100, Ingo Molnar wrote:
> > * Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> > 
> > > +	case 'K':
> > > +		/*
> > > +		 * %pK cannot be used in IRQ context because its test
> > > +		 * for CAP_SYSLOG would be meaningless.
> > > +		 */
> > > +		if (in_irq() || in_serving_softirq() || in_nmi())
> > > +			WARN_ONCE(1, "%%pK used in interrupt context.\n");
> > 
> > Hm, that bit looks possibly broken - some useful warning in irq context could print
> > a pointer into the syslog and this would generate a second warning? That probably
> > would crash as it recurses back into the printk code?

> The double "%%" acts as an escape and simply prints "%" rather than
> treating it as a format specifier.

I think Ingo was more worried about the fact that we're doing a WARN_ONCE which
will generate a call to printk() - while we're in the middle of a printk() already.

So if we hit a 'printk(KERN_INFO "Some blather with a %pK pointer in it",ptr) in irq
context, what we'll get (if we're lucky is:

Some blather with a <50-60 lines of WARN_ONCE output> pointer in it.

If we're unlucky? Well... 


--==_Exmh_1293054216_7139P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNEnEIcC3lWbTT17ARAqG3AJ9koQENqu9aWBtsHfZd0aO8iyYlnACfU8F6
tktz447GAnb/xeOirKQFB+A=
=MEhx
-----END PGP SIGNATURE-----

--==_Exmh_1293054216_7139P--

