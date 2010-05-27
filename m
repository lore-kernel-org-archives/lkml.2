Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab0E0FFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 01:05:49 -0400
Received: from coyote.quickmin.net ([217.14.112.24]:59561 "EHLO
	coyote.quickmin.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab0E0FFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 01:05:48 -0400
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=telemotive.de;
  b=okqY7Uxq1ZQXKEagoL5WB3nllhU6e7sBtm4uvyVEtEsgkGja/OqN+b59uVtwt8L8fbT+5BKg1KZQhH4+fI9NzzjoJiSd3RqbFz8fC7D5MuxUUuybzLvQ6Z3JLhDnLLcyq9BXNbwOmst4laUntL2aKdsgmqGa0/kP9ECiLbsHMzI=  ;
From: Roman Fietze <roman.fietze@telemotive.de>
Organization: Telemotive AG
To: Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] dynamic_debug: allow to set dynamic debug flags right at module load time
User-Agent: KMail/1.13.3 (Linux/2.6.31.12-0.2-default; KDE/4.4.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201005261425.39058.roman.fietze@telemotive.de> <20100526183559.GA5094@redhat.com>
In-Reply-To: <20100526183559.GA5094@redhat.com>
MIME-Version: 1.0
Message-ID: <201005270705.44179.roman.fietze@telemotive.de>
Date: Thu, 27 May 2010 07:05:43 +0200
X-MIMETrack: Itemize by SMTP Server on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 27.05.2010 07:05:44,
	Serialize by Router on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 27.05.2010 07:05:45,
	Serialize complete at 27.05.2010 07:05:45
Content-Transfer-Encoding: 7bit
Content-Type: multipart/signed;
  boundary="nextPart1999108.7oBZeCiFiA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1999108.7oBZeCiFiA
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello Jason,

On Wednesday 26 May 2010 20:35:59 Jason Baron wrote:

> ... we want this to be runtime configurable.
> That is, we probably want this implemented as a module parameter, not as
> a compile time thing. something like: modprobe module verbose=3D1

Kind of

#define dynamic_pr_debug(fmt, ...) do {					\
	...
		DEBUG_HASH2, __LINE__,					\
		verbose ? _DPRINTK_FLAGS_PRINT : _DPRINTK_FLAGS_DEFAULT}; \
	...

But what if verbose isn't there?

Or something smarter inside dynamic_debug_setup() or
ddebug_add_module() looking for a module symbol or parameter with that
name?

If you'll give me a hint I could probably implement a proposal.


Roman

=2D-=20
Roman Fietze                Telemotive AG B=FCro M=FChlhausen
Breitwiesen                              73347 M=FChlhausen
Tel.: +49(0)7335/18493-45        http://www.telemotive.de

Amtsgericht Ulm                                HRB 541321
Vorstand:
Peter Kersten, Markus Fischer, Franz Diller, Markus Stolz

--nextPart1999108.7oBZeCiFiA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkv9/agACgkQp5XY/BK//MLE3wCdEx6iPZKQKlA2teXtrVjv4/gF
J7kAnRV7uqo5vkJWcArko1Lwe5tH0RXH
=MILq
-----END PGP SIGNATURE-----

--nextPart1999108.7oBZeCiFiA--
