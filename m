Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab2CUH3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 03:29:55 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53061 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab2CUH3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 03:29:52 -0400
Date: Wed, 21 Mar 2012 18:29:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Donggeun Kim <dg77.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: linux-next: build failure after merge of the final tree (mfd and
 input trees related)
Message-Id: <20120321182930.6f75199b7406044669891a14@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Mar_2012_18_29_30_+1100_HNfHShh=B.lskx=f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Mar_2012_18_29_30_+1100_HNfHShh=B.lskx=f
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from drivers/leds/leds-max8997.c:18:0:
include/linux/mfd/max8997.h:205:6: error: nested redefinition of 'enum max8=
997_haptic_motor_type'
include/linux/mfd/max8997.h:205:6: error: redeclaration of 'enum max8997_ha=
ptic_motor_type'
include/linux/mfd/max8997.h:134:6: note: originally defined here
include/linux/mfd/max8997.h:206:2: error: redeclaration of enumerator 'MAX8=
997_HAPTIC_ERM'
include/linux/mfd/max8997.h:135:2: note: previous definition of 'MAX8997_HA=
PTIC_ERM' was here
include/linux/mfd/max8997.h:207:2: error: redeclaration of enumerator 'MAX8=
997_HAPTIC_LRA'
include/linux/mfd/max8997.h:136:2: note: previous definition of 'MAX8997_HA=
PTIC_LRA' was here
include/linux/mfd/max8997.h:210:6: error: nested redefinition of 'enum max8=
997_haptic_pulse_mode'
include/linux/mfd/max8997.h:210:6: error: redeclaration of 'enum max8997_ha=
ptic_pulse_mode'
include/linux/mfd/max8997.h:139:6: note: originally defined here
include/linux/mfd/max8997.h:211:2: error: redeclaration of enumerator 'MAX8=
997_EXTERNAL_MODE'
include/linux/mfd/max8997.h:140:2: note: previous definition of 'MAX8997_EX=
TERNAL_MODE' was here
include/linux/mfd/max8997.h:212:2: error: redeclaration of enumerator 'MAX8=
997_INTERNAL_MODE'
include/linux/mfd/max8997.h:141:2: note: previous definition of 'MAX8997_IN=
TERNAL_MODE' was here
include/linux/mfd/max8997.h:215:6: error: nested redefinition of 'enum max8=
997_haptic_pwm_divisor'
include/linux/mfd/max8997.h:215:6: error: redeclaration of 'enum max8997_ha=
ptic_pwm_divisor'
include/linux/mfd/max8997.h:144:6: note: originally defined here
include/linux/mfd/max8997.h:216:2: error: redeclaration of enumerator 'MAX8=
997_PWM_DIVISOR_32'
include/linux/mfd/max8997.h:145:2: note: previous definition of 'MAX8997_PW=
M_DIVISOR_32' was here
include/linux/mfd/max8997.h:217:2: error: redeclaration of enumerator 'MAX8=
997_PWM_DIVISOR_64'
include/linux/mfd/max8997.h:146:2: note: previous definition of 'MAX8997_PW=
M_DIVISOR_64' was here
include/linux/mfd/max8997.h:218:2: error: redeclaration of enumerator 'MAX8=
997_PWM_DIVISOR_128'
include/linux/mfd/max8997.h:147:2: note: previous definition of 'MAX8997_PW=
M_DIVISOR_128' was here
include/linux/mfd/max8997.h:219:2: error: redeclaration of enumerator 'MAX8=
997_PWM_DIVISOR_256'
include/linux/mfd/max8997.h:148:2: note: previous definition of 'MAX8997_PW=
M_DIVISOR_256' was here
include/linux/mfd/max8997.h:241:8: error: redefinition of 'struct max8997_h=
aptic_platform_data'
include/linux/mfd/max8997.h:170:8: note: originally defined here

Caused by a bad merge of commits 104594b01ce7 ("Input: add driver support
for MAX8997-haptic") from the input tree and 02b09703e7a4 ("mfd: Add
platform data for MAX8997 haptic driver") from the mfd tree.

I applied this patch for today (which effectively removes the mfd tree
patch above):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 21 Mar 2012 18:25:30 +1100
Subject: [PATCH] fix up merge of include/linux/mfd/max8997.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/mfd/max8997.h |   49 ---------------------------------------=
----
 1 files changed, 0 insertions(+), 49 deletions(-)

diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
index 4ec373e..28726dd 100644
--- a/include/linux/mfd/max8997.h
+++ b/include/linux/mfd/max8997.h
@@ -202,55 +202,6 @@ struct max8997_led_platform_data {
 	u8 brightness[2];
 };
=20
-enum max8997_haptic_motor_type {
-	MAX8997_HAPTIC_ERM,
-	MAX8997_HAPTIC_LRA,
-};
-
-enum max8997_haptic_pulse_mode {
-	MAX8997_EXTERNAL_MODE,
-	MAX8997_INTERNAL_MODE,
-};
-
-enum max8997_haptic_pwm_divisor {
-	MAX8997_PWM_DIVISOR_32,
-	MAX8997_PWM_DIVISOR_64,
-	MAX8997_PWM_DIVISOR_128,
-	MAX8997_PWM_DIVISOR_256,
-};
-
-/*
- * max8997_haptic_platform_data
- * @pwm_channel_id: channel number of PWM device
- *		    valid for MAX8997_EXTERNAL_MODE
- * @pwm_period: period in nano second for PWM device
- *		valid for MAX8997_EXTERNAL_MODE
- * @type: motor type
- * @mode: pulse mode
- *     MAX8997_EXTERNAL_MODE: external PWM device is used to control motor
- *     MAX8997_INTERNAL_MODE: internal pulse generator is used to control =
motor
- * @pwm_divisor: divisor for external PWM device
- * @internal_mode_pattern: internal mode pattern for internal mode
- *     [0 - 3]: valid pattern number
- * @pattern_cycle: the number of cycles of the waveform
- *		   for the internal mode pattern
- *     [0 - 15]: available cycles
- * @pattern_signal_period: period of the waveform for the internal mode pa=
ttern
- *     [0 - 255]: available period
- */
-struct max8997_haptic_platform_data {
-	int pwm_channel_id;
-	int pwm_period;
-
-	enum max8997_haptic_motor_type type;
-	enum max8997_haptic_pulse_mode mode;
-	enum max8997_haptic_pwm_divisor pwm_divisor;
-
-	int internal_mode_pattern;
-	int pattern_cycle;
-	int pattern_signal_period;
-};
-
 struct max8997_platform_data {
 	/* IRQ */
 	int irq_base;
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__21_Mar_2012_18_29_30_+1100_HNfHShh=B.lskx=f
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPaYNaAAoJEECxmPOUX5FE0nEP/RDTteZWL4rg5M3szvqpKz+O
SWLxjT7p/XvQUfJdZwnCVLjD/fg0LUIy0kfkYMWQLsaCdoOC2ptity+M2CUIC47k
abhIxO3uqZpbDjNRL6Kh1eAKS+L4cTdnB0PZxWNGfT1rObFajRY3Rj2QQs9+T/wy
d+WUeWdM2kiEQdt+Q517JDUkVaMCnzhYKRQ+bPBLnRpyzXtju7/mA8LXjsa9FT5T
NsgWkwaZi6lNOhP5sTz+nhKshSac5ii1hSCANSOrIY8ivV3GNYMDvpLXKTsK2dkX
WEV+qOIKpzF8V3LviQ02QbAYBjvKUAWQQaDOnK7itCzudujSj1gzwwuVO0J913VH
u0ljSS862HNpDGcm6ryS3fzycsp3LKwVuGYhMld9E9VDWgTR3VQMyXQOtqdR5H0j
QOPs6KkGANKnp0gZNWYETdehBC/g0cVNIY2q5MioFrwCZBi7/jQwqME+3d5HiL09
Cdi2kLnJwAyid2hiMwJJ9sN2r3CXIizHMCCwJkIZwQdm5RPksyg6aSOgJ00ISEn5
Gc6YA0zVq83QMGdCWoD4C9I1tBU80Y7fJfZ183X/TQuSey24gIJ0YZDZTfyyYL65
OyVvy7afQTd/Uyvjheuv330A6B8dDbw0K+83naIlCyMYtD3LN76vS9M4kj1CbXpa
ZRfww11OTVPDMf9k6Lq6
=kwF4
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Mar_2012_18_29_30_+1100_HNfHShh=B.lskx=f--
