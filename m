Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab3AJSzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:55:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62462 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab3AJSzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:55:11 -0500
Date: Thu, 10 Jan 2013 19:55:05 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/14] lib: Add I/O map cache implementation
Message-ID: <20130110185505.GA22944@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130109231758.GA27065@obsidianresearch.com>
 <20130110071937.GG15212@avionic-0098.adnet.avionic-design.de>
 <201301100917.19577.arnd@arndb.de>
 <20130110102544.GA5546@avionic-0098.adnet.avionic-design.de>
 <20130110182007.GA28004@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20130110182007.GA28004@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Ne2u0pHflpmgQAYrmuJW07ivpQxGQY7bplAIAWjvvdR
 YZ1AIasyry2r1Oue8Nh7kOD7+KdKmlXIw6hPelU0lnMLQxGlTa
 YQya/kscNmBL1UdLQJAGq1mK9FjC8GfLJwsrH2Kp8wLamZq3TV
 B7EB9JVGXXgmXWpq4d56wtvVgrpUWc5lufG2f7NAmvBt+Qx8Ht
 Fz1iz0rp0K9NFnuyi1vBrXig6svGwhNPvPOBgUml7YeJmDiMIH
 wG9pj8D3CuNeP9qBoMZCDThlSk7ct7R2UJMDIZ1fsKbbPxxq5b
 okWdshEt6p3NWCV5xYXqtyFbz/gtOK/Qm0E5w9tg914oghA/sd
 Dw2rtbN8S+5xDJ3ByWie3Ad6122rC7oeakiwwDqMNr2bZNxvhF
 tvH3QwnQKCfGAdSbNHfbk+zIqRpfuACSbKoM2ZazET9Nfnfmxj
 RDq/J
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10, 2013 at 11:20:07AM -0700, Jason Gunthorpe wrote:
> On Thu, Jan 10, 2013 at 11:25:44AM +0100, Thierry Reding wrote:
> > On Thu, Jan 10, 2013 at 09:17:19AM +0000, Arnd Bergmann wrote:
> > > On Thursday 10 January 2013, Thierry Reding wrote:
> > > > On Wed, Jan 09, 2013 at 04:17:58PM -0700, Jason Gunthorpe wrote:
> > > > > On Wed, Jan 09, 2013 at 04:12:31PM -0700, Stephen Warren wrote:
> > > > > You could decrease the size of the mapping to only span the bus
> > > > > numbers that are configured for use via DT.
> > > >=20
> > > > That won't work, unfortunately. The mapping is such that the bus nu=
mber
> > > > is not encoded in the uppermost bits, the extended register number =
is.
> > > > So the only thing that we could do is decrease the size of the exte=
nded
> > > > register space for *all* devices.
> > >=20
> > > But you could still a method to map 16 separate areas per bus, each 6=
5536
> > > bytes long, which results in 1MB per bus. That is probably ok, since
> > > very few systems have more than a handful of buses in practice.
> > >=20
> > > In theory, doing static mappings on a per-page base would let you
> > > do 16 devices at a time, but it's probably worth doing at this fine
> > > granularity.
> >=20
> > I don't understand how this would help. The encoding is like this:
> >=20
> > 	[27:24] extended register number
> > 	[23:16] bus number
> > 	[15:11] device number
> > 	[10: 8] function number
> > 	[ 7: 0] register number
> >=20
> > So it doesn't matter whether I use separate areas per bus or not. As
> > soon as the whole extended configuration space needs to be accessed a
> > whopping 28 bits (256 MiB) are required.
>=20
> You'd piece a mapping together, each bus requires 16 64k mappings, a
> simple 2d array of busnr*16 of pointers would do the trick. A more
> clever solution would be to allocate contiguous virtual memory and
> split that up..

Oh, I see. I'm not very familiar with the internals of remapping, so
I'll need to do some more reading. Thanks for the hints.

> > > Actually, AER probably needs this, and I believe some broken devices=
=20
> > > need to mask interrupts using the PCI command word in the config spac=
e,
> > > it it can happen.
> >=20
> > Ugh... that would kill any such dynamic mapping approach. Perhaps if we
> > could mark a device as requiring a static mapping we could pin that
> > cache entry. But that doesn't sound very encouraging.
>=20
> AER applies to pretty much every PCI-E device these days.

So given there's no way around a segmented static mapping as you
suggested, right?

Thierry

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7w6JAAoJEN0jrNd/PrOhPIEQAI+YHn8apatm07IyaSaF1RT2
vtXnc//hV3lmQzwNjTewIIFYR19z7NLG1L/hct0VAa3RSKQHgU128Hle8cV/cxeR
IaJzPJV8mJzhK3Ieh5vH/5ZTSpp+YG5LxK4JejTDajGECdhmqAKtehxwOcVZVMZC
k3PX2146XGQwlITURLYmBwmwqc1tmFUJ3gjG2O8Hz00UviKzvD5iXgLhIUTseCXK
fMRYAwSEqOT8Wxc5M4AygHdXvnRbmf8XMpfFQrAHazSL8zdUJ8gMbXOHVX95CVky
neGps2EVTL8h5nUI7En2kxo6oawSIa2jKRbY8a9nB72XBCD4LBRy3U94N+B2nv9m
+T+He6Q4qGQZzc02YdAWr6KvoHljpxPBNTMs2rEsesnye7QN313h+n/EV9DcfdTW
yxiUnOUDlPApF7IenLaBvVVUGQhIN4jnUmgrrIuKcicLVW4lTdCdvTGk6R17T/V/
fqeRs9lixSgs1Xs7u/QNAVdPCLf+Koi4g37/sjL/nQ73B3mNexHKRRp+MbsxkAS9
0zzvu9wpM93RS6zHExH5rww7hOc0GABE3EAwxQEY91Uk3+qCJ/sBKv7cszvovTcU
f4ymEAMPrW34TXek5xcnKyRKT9tm/jRaWOkv69J4acxsubD15Kf8Hy1w/OfBTob9
K9DB7rAV1fatgSvaLPh5
=lss6
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
