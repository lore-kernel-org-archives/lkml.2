Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab0LTW3C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 17:29:02 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:47561 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab0LTW3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 17:29:00 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        eric.dumazet@gmail.com, tgraf@infradead.org, eugeneteo@kernel.org,
        kees.cook@canonical.com, mingo@elte.hu, davem@davemloft.net,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org
Subject: Re: [PATCH v3] kptr_restrict for hiding kernel pointers
In-Reply-To: Your message of "Sat, 18 Dec 2010 12:20:34 EST."
             <1292692835.10804.67.camel@dan>
From: Valdis.Kletnieks@vt.edu
References: <1292692835.10804.67.camel@dan>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1292883991_5161P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 20 Dec 2010 17:26:31 -0500
Message-ID: <50259.1292883991@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4D0FD81A.004D,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1292883991_5161P
Content-Type: text/plain; charset=us-ascii

On Sat, 18 Dec 2010 12:20:34 EST, Dan Rosenberg said:

> @@ -1035,6 +1038,26 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  		return buf + vsnprintf(buf, end - buf,
>  				       ((struct va_format *)ptr)->fmt,
>  				       *(((struct va_format *)ptr)->va));
> +	case 'K':
> +		/*
> +		 * %pK cannot be used in IRQ context because it tests
> +		 * CAP_SYSLOG.
> +		 */
> +		if (in_irq() || in_serving_softirq() || in_nmi())
> +			WARN_ONCE(1, "%%pK used in interrupt context.\n");

Should this then continue on and test CAP_SYSLOG anyhow, or should it
return a "" or or "<invalid>" or something?

--==_Exmh_1292883991_5161P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFND9gXcC3lWbTT17ARAlDxAKD02+4VO8q2qAP1QTVvM3JbWee6kgCg9JGO
DwMSZSe+Bkbl/fGMZD4p1pM=
=571E
-----END PGP SIGNATURE-----

--==_Exmh_1292883991_5161P--

