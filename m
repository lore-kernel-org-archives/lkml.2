Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237Ab2HIOEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:04:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50695 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932626Ab2HIOEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:04:10 -0400
Date: Thu, 9 Aug 2012 16:04:03 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: David Henningsson <david.henningsson@canonical.com>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] ALSA: hda - Deferred probing with
 request_firmware_nowait()
Message-ID: <20120809140403.GA10145@avionic-0098.mockup.avionic-design.de>
References: <20120809080713.GC24808@avionic-0098.mockup.avionic-design.de>
 <s5hzk64earo.wl%tiwai@suse.de>
 <20120809103430.GA1560@avionic-0098.mockup.avionic-design.de>
 <s5hobmk2ql5.wl%tiwai@suse.de>
 <s5hd3302ovw.wl%tiwai@suse.de>
 <s5ha9y42os2.wl%tiwai@suse.de>
 <5023BAA0.1080304@canonical.com>
 <s5h4noc2ntn.wl%tiwai@suse.de>
 <s5h1ujg2nm7.wl%tiwai@suse.de>
 <5023C0FC.2030207@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <5023C0FC.2030207@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:G7m7mCfpehv7qNLn+//Uo+s1m88D5vnxrLTJZ3LwcNf
 nEOxwu7IWWNGBk6v/FxUj+p8a92J7nkQI9zUaoAMEtXChUp1ld
 wOmLf3saxkY6cVy5cHIyx+ATcfOKK1D/zQTrKmJAyZLoEMdWsL
 VBo9dNNEaOj3PR9P856xwUOkWPAAHwrKcn2Bwe+gejll7es0Rp
 QrgFejNokIVAwOY82DP7ofh3IrNY0Ek5ge7lKnxetSZgAvsp5v
 tYNT7Ps7CHv6UHo+1AFKfOBhcol/nOplb1z/vt0GslVSNA5y+j
 GF8UA2gRwJC0D5B3uDd5l2nU8ewpKsE31g0bglG2Pyv6xUSxke
 9k9z8rb+KLojosSS6hUN5XGhZ61Py8c1AEgeSiTXOMnJJ8mq1k
 QsXOygNFRZ8FlIMT7RfeybRa07BWcLVRy8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 09, 2012 at 03:54:04PM +0200, David Henningsson wrote:
> On 08/09/2012 03:36 PM, Takashi Iwai wrote:
> >+/* callback from request_firmware_nowait() */
> >+static void azx_firmware_cb(const struct firmware *fw, void *context)
> >+{
> >+	struct snd_card *card =3D context;
> >+	struct azx *chip =3D card->private_data;
> >+	struct pci_dev *pci =3D chip->pci;
> >+
> >+	if (!fw) {
> >+		snd_printk(KERN_ERR SFX "Cannot load firmware, aborting\n");
> >+		goto error;
> >+	}
>=20
> Another thing, aren't you missing a
>=20
> chip->fw =3D fw;
>=20
> here?

Adding that line here fixes the problem for me.

Thierry

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQI8NTAAoJEN0jrNd/PrOh+1MP/32F4f/B7NVwAF0xDBuZhYaB
DN9KkfSUi8Y8O7wJnIpi2INXjuO4DQycbJuLw4Om645R+Ok1m/EUtM9s30Lm3Mkc
3iJTo6598mwMHuI5qMLIJ+5j0iY3saSCqHLgexY/9FeyVpvRLj5zlp9f/n+aOhwf
U1ZYHtfoLsh9JpeppbnfTtCe/3RkpMsOYsMoF8iMRc8IourVC6grBIrTBRV3qDcp
XufoM8Ik1CwmTD86cfEcVGvA6SDMt4zFFwSEdJVQstKHuXRPugOGiB7V9Qe1E4yU
Rb89YDORAhcxDPRz812ki0GN6l8CdownZ+MlZ+URG98h40CqPyM+Vfa8AYgJWvwu
HYgnr3/dGh9n7h19NdENN7e6pqrb5HgxvgbJM4z85l6GWLwUC50NehQJs2McYeNf
ChIE65aH8gfyrCQmIxvpelv6tw2jBHNhmGnAymSK6YYp1lgHLiDPRBxn5wGGtqZr
kzARmrgLHnyV37F650dTfw64Eo8R0dZt3rF3hCXbeUvDzDYXTJYYZGEuNIZwYNCF
H9GvINevaMscUAsz09+q4QgBNZZ5S/FNstPrSTZBctatYkTJ1WaQ+prrd4Ayb3o3
yv77I1aKEOFDxfA6Ash9NMvdQi9q3Ev+BVj6CA+Fk9Zn+4/VVwSSpV7zW3SspOmk
Gj9yPgwxCwRq9EiAUFeC
=JnU1
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
