Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab0KYFgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 00:36:37 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:35677 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab0KYFge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 00:36:34 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2010-11-09 - lockdep splat in ext4/quota code
In-Reply-To: Your message of "Sat, 13 Nov 2010 00:33:43 +0100."
             <20101112233343.GA12153@quack.suse.cz>
From: Valdis.Kletnieks@vt.edu
References: <201011100003.oAA03O3c015222@imap1.linux-foundation.org> <19688.1289503541@localhost>
            <20101112233343.GA12153@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1290663350_4815P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Nov 2010 00:35:50 -0500
Message-ID: <28481.1290663350@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4CEDF5B8.003D,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1290663350_4815P
Content-Type: text/plain; charset=us-ascii

On Sat, 13 Nov 2010 00:33:43 +0100, Jan Kara said:

> > Still seeing this just after quotas get turned on ext4. First seen in
> > 2.6.36-mmotm1022, but problem has apparently been there since
> > 2.6.36-rc5-mmotm0922 (oldest kernel I have lying around).
>   Thanks for the report. In fact, it is a false positive caused by the fact
> that EXT4(inode)->i_data_sem for quota file inode would need a special
> locking class (or subclass) but does not have one. I'll have a look into
> implementing that sometime next week hopefully.

> > [   48.967833] =======================================================
> > [   48.968162] [ INFO: possible circular locking dependency detected ]
> > [   48.968411] 2.6.37-rc1-mmotm1109 #1

I haven't spotted the commit that fixed it, but I'm assuming it's in there
now, as I am not seeing it on 2.6.37-rc3-mmotm1123, thanks.

--==_Exmh_1290663350_4815P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM7fW2cC3lWbTT17ARAoVxAJ4sLo3KwvJStibz8WBr0DA5w8ouGwCeKiQL
3IomiXwJ5BKbCi1h2o52/xI=
=eAcb
-----END PGP SIGNATURE-----

--==_Exmh_1290663350_4815P--

