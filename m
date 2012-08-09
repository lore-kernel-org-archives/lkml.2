Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab2HIMtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 08:49:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50171 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab2HIMtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 08:49:14 -0400
Date: Thu, 9 Aug 2012 14:49:04 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>,
        David Henningsson <david.henningsson@canonical.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: hda - Defer probe when loading patch firmware
Message-ID: <20120809124904.GA830@avionic-0098.mockup.avionic-design.de>
References: <1344494723-6827-1-git-send-email-thierry.reding@avionic-design.de>
 <s5hhascft86.wl%tiwai@suse.de>
 <20120809070813.GA6979@avionic-0098.mockup.avionic-design.de>
 <s5hd330frn1.wl%tiwai@suse.de>
 <20120809073642.GA24695@avionic-0098.mockup.avionic-design.de>
 <s5h7gt8fr47.wl%tiwai@suse.de>
 <20120809080713.GC24808@avionic-0098.mockup.avionic-design.de>
 <s5hzk64earo.wl%tiwai@suse.de>
 <20120809103430.GA1560@avionic-0098.mockup.avionic-design.de>
 <s5hobmk2ql5.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <s5hobmk2ql5.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:nOI5OrlD44ZpcMTcFJwg4B0u9G3i2L1MlSQwHD3AAtc
 fUub1UDRBe69ZtNdJSybYpQF6Ts7+hSvgxDzR2N3enqDU1ir21
 d9Z+ZeVHzRMxlp5L/TbJkF2d4BsuX4av75nJDbG7MnD1k0OaMQ
 3CilKNDJTa0PZEeY5iEAssU2qIZKmzuMVo/al6OdkB57Z7v/E3
 yaquiW63oxwaQwhsac94PGxCSIighO8DA34TrCaXGq5a/mTUB3
 Ti4lJBmNg2oKrXi2yYdDEIrO6E2QFpGNYpIVrgp123A4jO92KC
 1HnyBdppCrOdTbqg88J2ucSZ6dMZRdBA54ja62OKTyJakuZjpp
 ZYw5VmdoORhlCywUMSnKnH8Hf10462z4bJp43vNrkEURunBIDF
 YgerNQ2fP0BKpLrFUh4sGgSk949RBOBZhk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 09, 2012 at 02:32:38PM +0200, Takashi Iwai wrote:
> At Thu, 9 Aug 2012 12:34:30 +0200,
> Thierry Reding wrote:
> >=20
> > On Thu, Aug 09, 2012 at 10:21:15AM +0200, Takashi Iwai wrote:
> > > At Thu, 9 Aug 2012 10:07:13 +0200,
> > > Thierry Reding wrote:
> > > >=20
> > > > On Thu, Aug 09, 2012 at 09:42:48AM +0200, Takashi Iwai wrote:
> > > > > At Thu, 9 Aug 2012 09:36:42 +0200,
> > > > > Thierry Reding wrote:
> > > > > >=20
> > > > > > On Thu, Aug 09, 2012 at 09:31:30AM +0200, Takashi Iwai wrote:
> > > > > > > At Thu, 9 Aug 2012 09:08:13 +0200,
> > > > > > > Thierry Reding wrote:
> > > > > > > >=20
> > > > > > > > On Thu, Aug 09, 2012 at 08:57:13AM +0200, Takashi Iwai wrot=
e:
> > > > > > > > > At Thu,  9 Aug 2012 08:45:23 +0200,
> > > > > > > > > Thierry Reding wrote:
> > > > > > > > > >=20
> > > > > > > > > > Recent changes to the firmware loading helpers cause dr=
ivers to stall
> > > > > > > > > > when firmware is loaded during the module_init() call. =
The snd-hda-intel
> > > > > > > > > > module requests firmware if the patch=3D parameter is u=
sed to load a patch
> > > > > > > > > > file. This patch works around the problem by deferring =
the probe in such
> > > > > > > > > > cases, which will cause the module to load successfully=
 and the driver
> > > > > > > > > > binding to the device outside the module_init() call.
> > > > > > > > >=20
> > > > > > > > > Is the "recent" change meant 3.6 kernel, or in linux-next?
> > > > > > > > >=20
> > > > > > > > > In anyway, I don't understand why such a change was allow=
ed.  Most
> > > > > > > > > drivers do call request_firmware() at the device probing =
time.
> > > > > > > > > If this really has to be resolved in the driver side, it =
must be a bug
> > > > > > > > > in the firmware loader core code.
> > > > > > > >=20
> > > > > > > > A good explanation of the problem and subsequent discussion=
 can be found
> > > > > > > > here:
> > > > > > > >=20
> > > > > > > > 	http://article.gmane.org/gmane.linux.drivers.video-input-i=
nfrastructure/49975
> > > > > > >=20
> > > > > > > Yeah, but it doesn't justify this ugly module option.
> > > > > > > It's a simple bug.  Papering over it with this option doesn't=
 fix
> > > > > > > anything.
> > > > > >=20
> > > > > > It's not an option, all it does is defer probing if and only if=
 the
> > > > > > patch parameter was specified to make sure the firmware load wo=
n't
> > > > > > stall. I realize that this may not be an optimal solution, but =
at least
> > > > > > it fixes the problem with no fallout.
> > > > >=20
> > > > > Ah sorry, I misread the patch.
> > > > >=20
> > > > > Then it shouldn't be checked at that point.  Since 3.5 kernel, the
> > > > > probing code was already split for vga_switcheroo support.
> > > >=20
> > > > Yes, I saw that. But unless you actually use vga_switcheroo, the se=
cond
> > > > stage, azx_probe_continue(), will still be called from azx_probe() =
and
> > > > therefore ultimately from module_init().
> > >=20
> > > Yeah, but this could be easily delayed.  The split was already done,
> > > so the next step would be to return after the first half at probe,
> > > then call the second half later.
> > >=20
> > > > Before coming up with this patch I actually did play around a bit w=
ith
> > > > using the asynchronous firmware load functions but it turned out to=
 be
> > > > rather difficult to do so I opted for the easy way. The biggest pro=
blem
> > > > I faced was that since patch loading needs to be done very early on=
, a
> > > > lot of the initialization would need to be done after .probe() and =
many
> > > > things could still fail, so cleaning up after errors would become
> > > > increasingly difficult.
> > >=20
> > > async probe is also on my TODO list, but it's deferred ;)
> > >=20
> > > > > The point you added is the second stage.
> > > >=20
> > > > I don't understand this sentence.
> > >=20
> > > I meant that your patch added the check at the second-half probing
> > > function (azx_probe_contine()).  That is, it could be already the
> > > point triggered by vga_switcheroo handler, not via module_init any
> > > longer.
> > >=20
> > > So, after rethinking what you suggested, I wrote a quick patch below.
> > > Could you check whether this works?
> >=20
> > It oopses, though I can't quite tell where. I need to test some more
> > later to see where it goes wrong.
>=20
> Yeah, I tested it here and noticed, too.  As mentioned, the behavior
> of -EPROBE_DEFER is somehow flaky.  For example, when it's used for
> modules, the deferred probe will be never triggered (unless a new
> device is bound).

Yes, the idea is that probing is only retried after other drivers have
bound to other devices because otherwise nothing about any missing
resources can have changed. This however would indicate that deferred
probing is not the right solution here, after all we're not waiting for
another resource to become available. Something like delayed work might
be better suited.

Well, asynchronous firmware load is actually the right solution, delayed
work just might be a better workaround. =3D)

For completeness I should say that I've been using deferred probing with
modules quite successfully on another platform, so it is not a general
problem. Rather as you said, it is only triggered if another module is
loaded after the deferral.

> Considering the problem again, it's currently an issue only for the
> built-in sound driver, right?  AFAIK, request_firmware() works fine
> for modules.  If so, a simple "fix" to avoid the unexpected behavior
> is to make CONFIG_SND_HDA_PATCH_LOADER depending on CONFIG_SND_HDA=3Dm.
> It'd be simple enough for merging 3.6 kernel.

I've actually seen this problem with snd-hda-intel built as a module as
well, so I don't think this kind of temporary fix will do.

> I almost finished writing the patch to use request_firmware_nowait()
> version, but I'm afraid it's too intrusive for 3.6.  If disabling the
> patch loader for the built-in driver is OK, I'd queue the
> request_firmware_nowait() patches to 3.7 queue.

I'm in no hurry, and the patch that I carry works for me. If there are
no other reasons to pull a corresponding fix into 3.6 I can certainly
wait for 3.7. The particular setup that I have requires other patches
that may not go into 3.6 anyway.

Thierry

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQI7G/AAoJEN0jrNd/PrOhcR4P/1gk74KzEWqINxyKIlLyE9xS
Kc+eWyihhIXns8eSoVS9+ahHuLTr/UESWMYACjXOSYe0SnZNgJYi5I41jp7+XRsH
U7qcIfyA8TRPU0+dAnNEvMPji0RuAmL5XMP/PDMW2puipwcFrjVxLzzPiJTV06Q9
calFnKcMDCYWNG/nOcyoPpH/wYevwK20kKRX8HgfX2x8c5wX9H0+8Hyxq971Yvpb
b6qDOS2DOi+maYzgO+H5vuGqTgmVUeK59owHyPTxegpviJM/Bf4e37eQCZlUm+2x
Eth8x8cnm3gNuD7eYRFg9zcViyQvPJDpFp/NmpjDbRFcQYss8AQx1t+HsD74VxJl
GWCSKMJIhmj4nJgFtMXjzA9X/pBZmzvXxmp4n3WW/v74Hc/d/kbscS3JV0wotF/y
7yyKb8HWjaSMbyfg9q84ku1NgQOrIP1vqbXRzV7L6/EEjQkpQ6430m9ZPyKJJpIB
GOdAJF6RT9rEUrGiv20HLXWSsj8qIlFYBv65jKtocox+GG+lBeFl/WmTnjfPABCi
DnWmjzG8lHusbKvK44JOhz5BP/1FLWIEDEBwFx1wptm4OTCJa43BMtZU00zmPdzE
N3LqaIUc9x54wsT1cKg3lmxoLtztGsgV8OwVy4La0GQsQYS/XtodnFbMn+4N8YFE
Jtzj0vSA3unrYPvz2cwK
=BSXP
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
