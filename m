Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab1J0HKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:10:31 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43210 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1J0HKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:10:30 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Tao Ma <tm@tao.ma>
Cc: "Ted Ts'o" <tytso@mit.edu>, ext4 development <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH V1 00/17] ext4: Add inline data support.
In-Reply-To: Your message of "Wed, 26 Oct 2011 15:32:24 +0800."
             <4EA7B788.3040503@tao.ma>
From: Valdis.Kletnieks@vt.edu
References: <4EA7B788.3040503@tao.ma>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1319699422_3371P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Oct 2011 03:10:22 -0400
Message-ID: <7941.1319699422@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4EA903E2.0037,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1319699422_3371P
Content-Type: text/plain; charset=us-ascii

On Wed, 26 Oct 2011 15:32:24 +0800, Tao Ma said:

> Currently I use all the space between i_extra_isize and inode_size if
> inode_size = 256. For inode_size > 256, half of that space is used so as
> to leave some space for other xattrs.

I didn't check the code too closely - does this code DTRT if the user tries to
then attach a moby-sized xattr (or set of xattrs - if it's got a security.selinux
tag on it, and a security.capabilities xattr, and a user xattr or two, things are
going to be getting full).

> This is only a V1 and there are still something to do(e.g. I am thinking
> of using unused extent space), but I'd like to send it out earlier so
> that it can be reviewed ASAP.

If this works out, would it make sense to investigate doing this for all
tails in a V2?  So if your file was 4099 bytes long, you could save allocating
a second block.  Assuming random distribution of tail sizes, this wil save
an average of (space avail for tail)/(blocksize) per file.

--==_Exmh_1319699422_3371P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOqQPecC3lWbTT17ARAuHkAKCj3CNruCkDhLu8No83GgQQwl4iogCgghAR
DGtFIx2AfT8RBBJ3T+agO7A=
=DGK7
-----END PGP SIGNATURE-----

--==_Exmh_1319699422_3371P--

