Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab2HPKxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:53:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62912 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2HPKw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:52:58 -0400
Date: Thu, 16 Aug 2012 12:52:46 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] Runtime Interpreted Power Sequences
Message-ID: <20120816105246.GA7595@avionic-0098.mockup.avionic-design.de>
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com>
 <1345097337-24170-2-git-send-email-acourbot@nvidia.com>
 <20120816074232.GA17917@avionic-0098.mockup.avionic-design.de>
 <502CBB0C.70102@nvidia.com>
 <20120816095251.GA30646@avionic-0098.mockup.avionic-design.de>
 <502CCC77.2010005@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <502CCC77.2010005@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Baup8kbI39X+jIL6NAR1ciWS7BD2X274oAFef7fDcCM
 6tBZ8rDG8UIirByBCECEYdovbW9SxKgg/u/ZUWikaPZi6QJibu
 Tz/SdyOXMq05yU/B5wdXAMmUZuhNWAhxK3mcDNihMTA+XbFlMk
 K30VfeIYX2JnfbB8TwE+SlcDAJ9ZnTmWqd/TtSfedqBGObiXMY
 fKoHsNZP+fSzwey2jPCGen3q7g/bVNKo0ryrdsj4rHboy9ZDaQ
 GmMgbO9f4OAb/TWl4tqefNxo/SWkkrSogWThT26IwOosBf8fyM
 zsDsMmuxJzQS3VdTyHnEMATmtKVgUrUKYLydZIlSo03DCXyXdm
 gEOne6VkLIx9QOZeDyiA763E+8FXNBjuVkQG6FFeXObtpIKns2
 0o++avneq7/4+1JM1inXX7jK/8ZlS2RjD4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 16, 2012 at 07:33:27PM +0900, Alex Courbot wrote:
> On 08/16/2012 06:52 PM, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> >
> >On Thu, Aug 16, 2012 at 06:19:08PM +0900, Alex Courbot wrote:
> >>On 08/16/2012 04:42 PM, Thierry Reding wrote:
> >>>>Old Signed by an unknown key
> >>>
> >>>On Thu, Aug 16, 2012 at 03:08:55PM +0900, Alexandre Courbot wrote:
> >[...]
> >>>>+Usage by Drivers and Resources Management
> >>>>+-----------------------------------------
> >>>>+Power sequences make use of resources that must be properly allocate=
d and
> >>>>+managed. The power_seq_build() function builds a power sequence from=
 the
> >>>>+platform data. It also takes care of resolving and allocating the re=
sources
> >>>>+referenced by the sequence if needed:
> >>>>+
> >>>>+  struct power_seq *power_seq_build(struct device *dev, struct list_=
head *ress,
> >>>>+                                    struct platform_power_seq *pseq);
> >>>>+
> >>>>+The 'dev' argument is the device in the name of which the resources =
are to be
> >>>>+allocated.
> >>>>+
> >>>>+The 'ress' argument is a list to which the resolved resources are ap=
pended. This
> >>>>+avoids allocating a resource referenced in several power sequences m=
ultiple
> >>>>+times.
> >>>>+
> >>>>+On success, the function returns a devm allocated resolved sequence =
that is
> >>>>+ready to be passed to power_seq_run(). In case of failure, and error=
 code is
> >>>>+returned.
> >>>>+
> >>>>+A resolved power sequence returned by power_seq_build can be run by
> >>>>+power_run_run():
> >>>>+
> >>>>+  int power_seq_run(power_seq *seq);
> >>>>+
> >>>>+It returns 0 if the sequence has successfully been run, or an error =
code if a
> >>>>+problem occured.
> >>>>+
> >>>>+There is no need to explicitly free the resources used by the sequen=
ce as they
> >>>>+are devm-allocated.
> >>>
> >>>I had some comments about this particular interface for creating
> >>>sequences in the last series. My point was that explicitly requiring
> >>>drivers to manage a list of already allocated resources may be too much
> >>>added complexity. Power sequences should be easy to use, and I find the
> >>>requirement for a separately managed list of resources cumbersome.
> >>>
> >>>What I proposed last time was to collect all power sequences under a
> >>>common parent object, which in turn would take care of managing the
> >>>resources.
> >>
> >>Yes, I remember that. While I see why you don't like this list,
> >>having a common parent object to all sequences will not reduce the
> >>number of arguments to pass to power_seq_build() (which is the only
> >>function that has to handle this list now). Also having the list of
> >>resources at hand is needed for some drivers: for instance,
> >>pwm-backlight needs to check that exactly one PWM has been
> >>allocated, and takes a reference to it from this list in order to
> >>control the brightness.
> >
> >I'm not complaining about the additional argument to power_seq_build()
> >but about the missing encapsulation. I just think that keeping a list
> >external to the power sequencing code is error-prone. Drivers could do
> >just about anything with it between calls to power_seq_build(). If you
> >do all of this internally, then you don't depend on the driver at all
> >and power sequencing code can just do the right thing.
>=20
> On the opposite side, I am concerned about over-encapsulation. :)
> IIRC you proposed to have a top structure to hold the power
> sequences, their resources and the associated device. Power
> sequences would then have a name and be run through a 2 arguments
> power_seq_run():
>=20
>   power_seq_run(sequences, "up");
>=20
> There are two things that bother me with this solution. First is
> that addressing power sequences by name looks a little bit overkill,
> when a single pointer should be enough. It would also complicate the
> design. Second thing is that this design would place the power
> sequences structure on top of the device - in effect, you could
> perfectly have several of these structures all using the same device
> and failing to see each other's resources. While that would be a
> error from the device driver's side, the design allows it.

I see. Perhaps I'm just bugged by the interface being a simple list. If
it was something just a little more sophisticated, like a very primitive
resource manager attached to one device, I would be appeased. Maybe an
opaque structure that carries the list and hides it for drivers would do
as well.

> >Obtaining a reference to the PWM, or any other resource for that matter,
> >from the power sequence could be done via an explicit API.
> >
> >>Ideally we could embed the list into the device structure, but I
> >>don't see how we can do that without modifying it (and we don't want
> >>to modify it). Another solution would be to keep a static mapping
> >>table that associates a device to its power_seq related resources
> >>within power_seq.c. If we protect it for concurrent access this
> >>should make it possible to make resources management transparent.
> >>How does this sound? Only drawback I see is that we would need to
> >>explicitly clean it up through a dedicated function when the driver
> >>exits.
> >
> >I don't think that's much better. Since the power sequences will be very
> >tightly coupled to a specific device, tying the sequences and their
> >resources to the device makes a lot of sense. Keeping a global list of
> >resources doesn't in my opinion.
>=20
> That is not what would happen actually - what I proposed is to have
> a mapping (hash map, or more likely binary tree) between a device
> and the list_head of the resources for that device. In C++ (forgive
> me, this makes the types more explicit) that would be:
>=20
> static std::map<struct device *, struct list_head> device_resources;
>=20
> That way you would have exactly one list per device, could keep
> resource-management totally transparent without exposing the
> list_head, and keep the API and design simple.
>=20
> For special cases (like pwm-backlight which needs to get the PWM),
> the list_head could be obtained through a dedicated API.

I understand. You could use an idr (include/linux/idr.h) for this
purpose. However I don't know if this would be any better than the
above.

Thierry

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQLND+AAoJEN0jrNd/PrOhslsP/RlLYMDwvTSGS9g8V0y1yFah
OwlcgVC8HHbXlv1rntIpTEGUZr3HZJAye6nENGW2XEDA1FlFXiF1GXjpubgytTno
8diOVhFAq2lSNKoniKbkoSoYg+FvHxY9xBNQDaAdTvAlRfwo1vAW9BtwBaGj7Ink
7XWKPloAeq/3fP9ntJ8QGZg6ZkqLbyDqOCsyH3PASal1lFq4K9inEf2Ur8kWPfrQ
oP72L1z+jBOqq9djSNj/ggxYO+aZ+cVNNBSqVDYuWH1TfodFjw6dDTWRVT5nQeWJ
0SLoBaJdzr28pvsnYexiRwaZ0nFE8H0v87qP7m8N/DUawqbq6itGRvV/gmx1mLXE
08jma3kWLlhVxYTeiRav2VXh3eFVWUIQu+OL4nrXXARFQZRav9X8FlQivYi1YxOs
GRNHr/01DxVI8obUQXfKUob1ESHiajwg3pbpX8Q5D2JIukl8pXu43jLWfMICJTVe
Kyx1TBE6vdyvMxEqlCPu6EHcYf5VUD3Unexhg2ddEz/QqRH817fUr5SqV4PpZpCG
vt/72F1SMGWannUWAqF4inhyxlLukTkfVg5cAoZ7gBSWoLYrCRBf5H+pyOQMcVnj
MClawa3nHwag3UhNa4S1NexI6T8HzDy43vdKuWGsL2klvH2LBw1yNAOOc6q6Q78w
AwjYqef4D0YCDsN25Hd9
=a+z0
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
