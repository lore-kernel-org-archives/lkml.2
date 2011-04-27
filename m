Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab1D0Ghh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:37:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48746 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab1D0Ghf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:37:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AgRntuvkTiv/mYMq8W8EooNnO2+c04O6NfHKXXahOayq/2Uo9r14SnsAHKuTX6xYr2
         FIWYnrgdI+uRXLzm5HyT2860CF/fAz9tY+B2i4+GMaYcIsAI54d2H18JmPlOIg6tVs4O
         25x7TMe78zp3Xo+SCQiOHsP6dDCKlyRynEqns=
Date: Wed, 27 Apr 2011 14:37:30 +0800
From: Lifeng Sun <lifongsun@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] Applying inappropriate ioctl operation on socket should
 return ENOTTY
Message-ID: <20110427063730.GA20313@md5.ntu.edu.sg>
References: <1303882625-28115-1-git-send-email-lifongsun@gmail.com>
 <1303883910.2699.53.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: attachment
In-Reply-To: <1303883910.2699.53.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21hg (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07:58 Wed 04/27/11 Apr, Eric Dumazet wrote:
> Really ?
>=20
> EINVAL is ok too : Request or argp is not valid.

I'm afraid not. SUSv4 specifies, say,

  int tcsetattr(int fildes, int optional_actions,
         const struct termios *termios_p);

 ERROR:
  [EINVAL]
      The optional_actions argument is not a supported value, or an
      attempt was made to change an attribute represented in the
      termios structure to an unsupported value.

  [ENOTTY]
      The file associated with fildes is not a terminal.

which means when we apply tcsetattr (implemented by ioctl) to _any_
non-terminal file descriptor, it should set errno to ENOTTY rather
than EINVAL.

> I would say, its not a bug as you claim.=20
>=20
> Its really too late to make such change and risk regressions.
>=20
> isatty(fd) performs well. Please use it instead.
>=20
> Also, networking patches should be sent to netdev@vger.kernel.org and
> David Miller, as mentioned in MAINTAINERS file.

Thank you.

--=20

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: GnuPG digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk23uaoACgkQJssKhx9gUzHlxQCfQ6k7kY3snFke8MV090quiODd
gigAn2hwfOlOcKGq8A5qNojSCuPTZukc
=xPrb
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
