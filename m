Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab0HIHx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 03:53:57 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:46925 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab0HIHx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 03:53:56 -0400
X-Spam-ASN: 
Date: Mon, 9 Aug 2010 11:53:43 +0400
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, john stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Joonwoo Park <joonwpark81@gmail.com>
Subject: Re: [PATCHv3 05/16] pps: access pps device by direct pointer
Message-ID: <20100809115343.122c4f2c@desktopvm.lvknet>
In-Reply-To: <20100805123147.GA19407@gundam.enneenne.com>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
 <244e91439eeb1c835b6fa82999fcd65a8a282183.1280952801.git.lasaine@lvk.cs.msu.su>
 <20100805093236.GI26615@gundam.enneenne.com>
 <20100805154231.52555130@desktopvm.lvknet>
 <20100805123147.GA19407@gundam.enneenne.com>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/MZEFwofvbj=fu6G/Avh8.uN"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/MZEFwofvbj=fu6G/Avh8.uN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Thu, 5 Aug 2010 14:31:47 +0200
Rodolfo Giometti <giometti@enneenne.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Thu, Aug 05, 2010 at 03:42:31PM +0400, Alexander Gordeev wrote:
> > ?? Thu, 5 Aug 2010 11:32:36 +0200
> > Rodolfo Giometti <giometti@enneenne.com> ??????????:
> >=20
> > > On Thu, Aug 05, 2010 at 01:06:42AM +0400, Alexander Gordeev wrote:
> > > > Using device index as a pointer needs some unnecessary work to be d=
one
> > > > every time the pointer is needed (in irq handler for example).
> > > > Using a direct pointer is much more easy (and safe as well).
> > > >=20
> > > > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> > [snip]
> > >=20
> > > If you remove these functions you can't be sure anymore that nobodies
> > > may call pps_event() over a non existent device...
> >=20
> > [snip]
> >=20
> > > By dropping pps_get_source you may be here by a call from (i.e.) a
> > > serial port driver whose doesn't know if your PPS source is gone or
> > > not...
> > >=20
> > > I don't understand how your modifications may resolve this problem.
> >=20
> > Well, this can happen only if PPS client module calls pps_event before
> > calling pps_register_source() or after pps_unregister_source(). This
> > means that it's broken! If we try to handle/workaround broken clients it
>=20
> Suppose we are using pps-ldisc client. How can you assure that
> nobodies may execute pps_tty_close() while you are into the
> pps_event() related to the same serial port?
>=20
> You can't disable serial interrupts in order to avoid
> pps_tty_dcd_change calls...

Hmm, yes, I see...
But this is custom problem of only one client. I think it should be
fixed in place instead of trying to fix it in the subsystem.

Are you 100% sure dcd_change can be called before open or after close?
Then I'll try to deal with this.

> > affects performance. So we have to choose what is the priority:
> > security or performance. My guru told me I shouldn't bother too much
> > about broken kernel-space code which my code interacts with. If it's
> > broken it should be fixed. Some assertions enabled by DEBUG define are
> > enough. For me it makes sense but I don't know what should I check here?
>=20
> I'm sorry but I disagree with you. Kernel code can't allow userland
> programs to corrupt it!
>=20
> We are not discussing about security or performance but about
> reliability.

Sure, now I see the problem (in the pps-ldisc).

--=20
  Alexander

--Sig_/MZEFwofvbj=fu6G/Avh8.uN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEcBAEBCAAGBQJMX7QHAAoJEElrwznyooJb3mIH/RJY3HOhDxMzxS5z3OubiseW
0NY3FMGS9HQaO+rRjKIpD7M8tiRCwCZxKiR3BNDJI24oSkC9KL+OwkCdX3QQcBLo
qOWc/8Ghy8MzTHk9SwHw4AJkPzSGnI5Z9zz0x2CwO9rpYXd9io8sz8GpOwlOz8gh
m7SnniNb4/PEzUZ9QxJ+RyY/JRVnP+bRyxxdkZm1peobNcuZKl6gZ+1nPk50Gn4+
+ENZ25leGxlaeVBa1I8J+/cyVO17sZg/vlxnJ5tTm99K4EhUASj1npYWxXZzvnpS
8rz2f+q5YfBHz2GXiTq+dOrLNcgHTK4Cn0s+lpJ7wze/ktEVBr30ymt6+uhecF4=
=M7xZ
-----END PGP SIGNATURE-----

--Sig_/MZEFwofvbj=fu6G/Avh8.uN--
