Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab2FZRoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 13:44:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:58765 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab2FZRoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 13:44:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="162978099"
Date: Tue, 26 Jun 2012 20:45:42 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Doug Ledford <dledford@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [RFC, PATCH] CLONE_NEWIPC and exit_group()
Message-ID: <20120626174542.GA15482@otc-wbsnb-06>
References: <20120626120425.GA10275@otc-wbsnb-06>
 <20120626170457.GA31175@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <20120626170457.GA31175@mail.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 26, 2012 at 05:04:57PM +0000, Serge E. Hallyn wrote:
> Quoting Kirill A. Shutemov (kirill.shutemov@linux.intel.com):
> > Hi,
> >=20
> > Patch to move kern_unmount() out of exit_group() code path is below.
> > Dmitry, could you check if it's beneficial for your use-case?
>=20
> Hi,
>=20
> sorry, I don't seem to have the thread handy for contest.  What is the
> point of this?  The work being moved was not being done under lock,
> so what is this meant to gain?

It's basically addition to this patch (tested with the patch applied):

http://thread.gmane.org/gmane.linux.kernel.cifs/6347/focus=3D23929

Some context: Dmitry has workload which run a lot of short-living tasks in
sandboxed environment. He noticed that exit_group() syscall of the last
process in IPC namespace is a bottleneck.

The bottleneck was mainly due rcu_barrier() in kern_umount(). It's fixed
by patch in the link (Andrew took it in -mm).

But probably having kern_umount() in exit_group() code path is not a good
idea from scalability point of view?..

--=20
 Kirill A. Shutemov

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP6fVGAAoJEAd+omnVudOMK5EP/2zDDM2tgF3GKMFEH/PD9UZ/
Fea7aPU0ChwNRqlZWGBtZ4RpOniHufhKo+kTF5wd/AOSVD7H1x+3ll+Fv9yutxq/
o/61DGesNaUKMPYwdekgkskFb/1HrVP+/dRNr+DGVEM5mwTJScc/VrLbmc+By0+4
/yyngBu5k7YXYXNllNb7+DBsQ3gJh4JtbaxxFKmsIOF4UdXFViTH0t0M1YSge3cE
3UeTXrWzNSjS4k+9lxFLnO3oAOn5tuiJ0d3qaWlRQpF7wllY+e/VDLbj1wsInCcR
VCvzZHvWr05wEhjuOraVdKEAeLXk6urnv/ZcW848dFoVP/vKQs7+fnaXM06V9btn
8+U4OC2yDBzC4qsZ+vBipRVbKOHHSHHMAStwuNBojeEcWw30guRk7JOlI+HEWtt+
C3ExHKZuQLxWAAHsFdBchSF8RultuTQBS3gEt5tMy3v6u6V6htWq3l6bm2fkbOiW
FApMz0hUriOE8/hRw11vAOHbTY2OIawpRIsYXvvHoVhBuS8RCrjELpf/ozN4zOCH
x5ST/i8xKgLjL78ta9rPBQ0dAQVanWrYf4+ZSTwCYSJ4/KgqHY7wCn1aWLiL/S8+
jholwy7Zk3YBTYPA1eJtV/y2uoMLqYL+eyrJUsMMCo+Jr9LnCKvyWcI539fHvPj/
TYMnRSCGQUA0rJfw6UL2
=LGU6
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
