Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2JBGcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 02:32:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62872 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab2JBGcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 02:32:08 -0400
Date: Mon, 1 Oct 2012 23:32:04 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.7-rc0
Message-ID: <20121002063204.GB3853@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. A few drivers were updated
with device tree bindings and others got a few small cleanups and fixes.

You will get a conflict in omap-keymap driver (a small formatting
cleanup clashed with work coming from another tree), please let me know
if you want me to resolve it.

Thanks!

Changelog:
---------

Alexandre Pereira da Silva (3):
      Input: gpio_keys - clean up device tree parser
      Input: gpio_keys_polled - convert to dt
      Input: gpio_keys_polled - fix dt pdata->nbuttons

Andy Shevchenko (1):
      Input: hgpk - use %*ph to dump small buffer

Baodong Chen (1):
      Input: random formatting fixes

Daniel Mack (3):
      Input: rotary-encoder - defer calls gpio_to_irq()
      Input: rotary-encoder - use gpio_request_one()
      Input: rotary-encoder - add DT bindings

David Herrmann (1):
      Input: uinput - return -EINVAL when read buffer size is too small

Dmitry Torokhov (8):
      Input: gpio-keys-polled - constify pointers to platform data
      Input: rotary-encoder - constify platform data pointers
      Input: get rid of MATCH_BIT() macro
      Input: uinput - take event lock when fetching events from buffer
      Input: uinput - fix race that can block nonblocking read
      Input: uinput - mark failed submission requests as free
      Input: uinput - specify exact bit sizes on userspace APIs
      Input: uinput - fix formatting

Jason Gerecke (2):
      Input: wacom - add support for EMR on Cintiq 24HD touch
      Input: wacom - mark Intuos5 pad as in-prox when touching buttons

Josh (1):
      Input: omap-keypad - fixed formatting

Michael Schutte (1):
      Input: Add KD[GS]KBDIACRUC ioctls to the compatible list

NeilBrown (2):
      Input: gpio_keys - report a wakeup_event for a button press
      Input: twl4030-pwrbutton - report a wakeup_event on button press

Sachin Kamat (1):
      Input: s3c2410_ts - make s3c_ts_pmops const

Seth Forshee (1):
      Input: synaptics - adjust threshold for treating position values as n=
egative

Stephen Warren (1):
      Input: tegra - move platform data header

Tobias Klauser (2):
      Input: samsung-keypad - use of_match_ptr()
      Input: samsung-keypad - use of_get_child_count() helper


Diffstat:
--------

 .../devicetree/bindings/input/gpio-keys-polled.txt |  38 ++++
 .../devicetree/bindings/input/rotary-encoder.txt   |  36 ++++
 drivers/input/apm-power.c                          |   2 +-
 drivers/input/ff-core.c                            |   4 +-
 drivers/input/ff-memless.c                         |  14 +-
 drivers/input/input.c                              |  43 +++--
 drivers/input/joydev.c                             |   2 +-
 drivers/input/keyboard/gpio_keys.c                 | 169 +++++++++---------
 drivers/input/keyboard/gpio_keys_polled.c          | 147 +++++++++++++--
 drivers/input/keyboard/omap-keypad.c               |   8 +-
 drivers/input/keyboard/samsung-keypad.c            |  10 +-
 drivers/input/keyboard/tegra-kbc.c                 |   2 +-
 drivers/input/misc/rotary_encoder.c                | 140 ++++++++++-----
 drivers/input/misc/twl4030-pwrbutton.c             |   1 +
 drivers/input/misc/uinput.c                        | 197 +++++++++++++----=
----
 drivers/input/mouse/hgpk.c                         |   9 +-
 drivers/input/mouse/synaptics.c                    |  31 +++-
 drivers/input/mousedev.c                           |   9 +-
 drivers/input/sparse-keymap.c                      |   4 +-
 drivers/input/tablet/wacom_wac.c                   |   2 +-
 drivers/input/touchscreen/s3c2410_ts.c             |   2 +-
 fs/compat_ioctl.c                                  |   2 +
 .../mach/kbc.h =3D> include/linux/input/tegra_kbc.h  |   0
 include/linux/uinput.h                             |  27 +--
 24 files changed, 611 insertions(+), 288 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/gpio-keys-polle=
d.txt
 create mode 100644 Documentation/devicetree/bindings/input/rotary-encoder.=
txt
 rename arch/arm/mach-tegra/include/mach/kbc.h =3D> include/linux/input/teg=
ra_kbc.h (100%)

--=20
Dmitry


--DocE+STaALJfprDB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQaopjAAoJEH70+W8r6ZYqcTkP/iDbJnHz8tpHlBQPdXhYXJdl
hQEGBagVZeHS1pmmc5saH1twB3EB0p32vJ6C1FUbkUWjeXXzP5BCXImQd7OUhzbS
KTQoy42O+XHXnISx7Vsqo5OSW1AMhVVp3buT/1BF6425DP2ez62Fhli0xVPawDHG
rt1I7XZxQWeVzv4uaFc9yiegE5vLODypFSApaSIr7AHqzRfHkbNc8zsMBnseSnPf
nl9ZPDdW7F3tEvJzJwFzTx4i+bRpb9vah/DIp4Y2sYBZXClEVEpA4vJpHnbcC10n
iqLs1pSER51ISTWsTEFyMHuwywk8gYdBBG9fRS4dLraDnCyUQypXyhdSMy/pG/Ss
iBcBKOlBC3F3SKiHdkjW6JYmyENW5cJixk9r91ZMl9eKUyUGbPuMehZxFKad+0ra
pOzEgUurrzFHo3YUEWu6T1HvN8rUFi+Pys4jhxvywi1DuI0O5Qt73sgUF27qYmXV
OOGyOAyjszTT8jpsfe04mmHC5ECa2iq7qEvGSaLhvdqPEXYzP/h7stsyBaMEevjK
+qte58aGpFHyXJ2j1HurZ8elOIKo27yaQbG9BQ4PpZ9lKhwIv45n4+0obqtWusgd
ksLSNTLgeNyl2hGUpsAGlVaEVKInvfF4X39dYvyQo3IQHxwWFygLDE0Xt41ST/bz
sxz1v3WyJLbnPFnGmjK2
=zY9q
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
