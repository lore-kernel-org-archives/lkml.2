Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab0HEMA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:00:57 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:50864 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760079Ab0HEMAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:00:54 -0400
X-Spam-ASN: 
Date: Thu, 5 Aug 2010 16:00:45 +0400
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCHv3 12/16] ntp: add hardpps implementation
Message-ID: <20100805160045.69ff77ce@desktopvm.lvknet>
In-Reply-To: <1280962187.2678.14.camel@localhost.localdomain>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
	<358275628c418f5f328adc4a4ea23fc902776566.1280952801.git.lasaine@lvk.cs.msu.su>
	<1280962187.2678.14.camel@localhost.localdomain>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/T632GCAKqO6QWEK3qBfHgkC"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/T632GCAKqO6QWEK3qBfHgkC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Wed, 04 Aug 2010 15:49:47 -0700
john stultz <johnstul@us.ibm.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Thu, 2010-08-05 at 01:06 +0400, Alexander Gordeev wrote:
> > This commit adds hardpps() implementation based upon the original one
> > from the NTPv4 reference kernel code from David Mills. However, it is
> > highly optimized towards very fast syncronization and maximum stickness
> > to PPS signal. The typical error is less then a microsecond.
> > To make it sync faster I had to throw away exponential phase filter so
> > that the full phase offset is corrected immediately. Then I also had to
> > throw away median phase filter because it gives a bigger error itself
> > if used without exponential filter.
> > Maybe we will find an appropriate filtering scheme in the future but
> > it's not necessary if the signal quality is ok.
> >=20
> > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
>=20
> [snip]
>=20
> > +#ifdef	CONFIG_NTP_PPS
> > +
> > +struct pps_normtime {
> > +	__kernel_time_t	sec;	/* seconds */
> > +	long		nsec;	/* nanoseconds */
> > +};
>=20
> I don't quite remember the history here (it may be I suggested you use
> this instead of overloading a timespec? I honestly don't recall), but
> could you add some extra context in a comment here for what a
> pps_normtime structure represents and why its used instead of a
> timespec? The comment below sort of hints at it, but it would be useful
> if it was more explicit.

Yes, you asked me to do this. :)
Sure, I'll add an explicit comment.

> > +/* normalize the timestamp so that nsec is in the
> > +   ( -NSEC_PER_SEC / 2, NSEC_PER_SEC / 2 ] interval */
> > +static inline struct pps_normtime pps_normalize_ts(struct timespec ts)
> > +{
> > +	struct pps_normtime norm =3D {
> > +		.sec =3D ts.tv_sec,
> > +		.nsec =3D ts.tv_nsec
> > +	};
> > +
> > +	if (norm.nsec > (NSEC_PER_SEC >> 1)) {
> > +		norm.nsec -=3D NSEC_PER_SEC;
> > +		norm.sec++;
> > +	}
> > +
> > +	return norm;
> > +}
>=20
> Otherwise the code looks pretty good to me.
>=20
> Acked-by: John Stultz <johnstul@us.ibm.com>

Thanks!

--=20
  Alexander

--Sig_/T632GCAKqO6QWEK3qBfHgkC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEcBAEBCAAGBQJMWqftAAoJEElrwznyooJbMvAH/jG56HdEpKOSTnrRf3rJIllj
sljZxbaAJ5uNtGDYfgGo+20Z6E+zF+239AO9pDxgnSfCoGZ0+qdv2LA+3fUBokEm
TW7VIasCv6reI7bK422OxroSbwyLIfL9ZYANW+OEXcIG60OLKtP7XNp9p4XcmVA2
anlKOKYAccu2RAtR+fY29SP2X1G3OyL1ckCW0EovxU5CFvrOTfX0Kg9D5JhMkOcP
tpepiXsXN/53wyCX6bv9DrVzn4m3aYXYu8sWS9wGEBXt1sia83hJWey6fj5TYpRY
cu8xlHD/B1BSdVdjsfcv9xyDzMfdnqOf3H6mNsRNX3Uf514gBtgnhRUr99KJPCw=
=luZB
-----END PGP SIGNATURE-----

--Sig_/T632GCAKqO6QWEK3qBfHgkC--
