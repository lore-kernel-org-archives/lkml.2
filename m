Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1AGRKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:10:46 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:38661 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab1AGRKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:10:45 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Nick Piggin <npiggin@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Joel Becker <joel.becker@oracle.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: 2.6.37-next - kernel BUG at fs/dcache.c:1363
In-Reply-To: Your message of "Fri, 07 Jan 2011 00:12:09 +1100."
             <AANLkTi=nVJNJdBChyuD43sqWEf3O_1tDj0FTO8O_Ukib@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <8679.1294247741@localhost> <AANLkTimtrinH-7tnGE2zxtoNNTEnqqD3ZDTTTWM-m0Uk@mail.gmail.com>
            <AANLkTi=nVJNJdBChyuD43sqWEf3O_1tDj0FTO8O_Ukib@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1294420240_4860P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Jan 2011 12:10:40 -0500
Message-ID: <25743.1294420240@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4D274911.001B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1294420240_4860P
Content-Type: text/plain; charset=us-ascii

On Fri, 07 Jan 2011 00:12:09 +1100, Nick Piggin said:

> > Thanks. It actually passed in a dentry that appears to have already been
> > used for something. This is not exactly a nice thing for a filesystem to do
> > and probably indicates an underlying bug anyway (or at least something
> > the vfs doesn't guarantee the safety of).
> >
> > Taking a look now.
>
> This patch fixes it here

> config fs: avoid switching ->d_op on live dentry

> Switching d_op on a live dentry is racy in general, so avoid it. In this case
> it is a negative dentry, which is safer, but there are still concurrent ops
> which may be called on d_op in that case (eg. d_revalidate). So in general
> a filesystem may not do this. Fix configfs so as not to do this.

Confirming this patch fixes the crash I was seeing, so now I'm off to try to
finish bisecting my way through the other issue I was seeing...

--==_Exmh_1294420240_4860P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNJ0kQcC3lWbTT17ARAqcWAJ905Ah+tLCIHfpcQMP6hWKEJozdKACgrzKg
gjAD5amG+0mBWYq1k/g70sc=
=QVXC
-----END PGP SIGNATURE-----

--==_Exmh_1294420240_4860P--

