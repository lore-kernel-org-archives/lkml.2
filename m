Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1KBRhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:37:13 -0400
Received: from home.keithp.com ([63.227.221.253]:35301 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735Ab1KBRhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:37:10 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 4/7] drm/i915: Let panel power sequencing hardware do its job
In-Reply-To: <20111102092310.2177a339@jbarnes-desktop>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-5-git-send-email-keithp@keithp.com> <yunwrbjvv37.fsf@aiko.keithp.com> <20111102092310.2177a339@jbarnes-desktop>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 02 Nov 2011 10:37:07 -0700
Message-ID: <yun39e6whmk.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Nov 2011 09:23:10 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:

> Note that PP_READY will incorrectly depend on some other register
> values, so in some configs the panel will happily power up even if
> PP_READY isn't set yet...

Here's the new version of that chunk:

@@ -906,32 +905,56 @@ intel_dp_mode_set(struct drm_encoder *encoder, struct=
 drm_display_mode *mode,
        }
 }
=20
=2Dstatic void ironlake_wait_panel_off(struct intel_dp *intel_dp)
+#define IDLE_ON_MASK           (PP_ON | 0        | PP_SEQUENCE_MASK | 0   =
                  | PP_SEQUENCE_STATE_MASK)
+#define IDLE_ON_VALUE          (PP_ON | 0        | PP_SEQUENCE_NONE | 0   =
                  | PP_SEQUENCE_STATE_ON_IDLE)
+
+#define IDLE_OFF_MASK          (PP_ON | 0        | PP_SEQUENCE_MASK | 0   =
                  | PP_SEQUENCE_STATE_MASK)
+#define IDLE_OFF_VALUE         (0     | 0        | PP_SEQUENCE_NONE | 0   =
                  | PP_SEQUENCE_STATE_OFF_IDLE)
+
+#define IDLE_CYCLE_MASK                (PP_ON | 0        | PP_SEQUENCE_MAS=
K | PP_CYCLE_DELAY_ACTIVE | PP_SEQUENCE_STATE_MASK)
+#define IDLE_CYCLE_VALUE       (0     | 0        | PP_SEQUENCE_NONE | 0   =
                  | PP_SEQUENCE_STATE_OFF_IDLE)
+
+static void ironlake_wait_panel_status(struct intel_dp *intel_dp,
+                                      u32 mask,
+                                      u32 value)
 {


=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrF/wzYtFsjWk68qAQhtDBAA0zYMr4jHrCVZYlCJuQDD3+qd7nAERnqr
QpTSBHkUGo7zEuvIig8+0GjnV8Px/qUa5rPmMHVPrD53SHNvzsVqdIzd+DoxeBEu
otIkdI/sNWIiDkRqQ9b9w3uwa3fMjjGKaSkMTKKxJA4i3Wa6Xc0g1vZpu2OjDGcC
uigVuGV+gtIPMZkHPjNLhmXbqW3eciNC13uXSav9qnSrAgTGaqOlTXkEKr/UChnE
r2Gv+9k2/3dMwuXVOXwvEgJdQssILLMWrQtZ2idPh1aDQFLLl006R5pBrClx77WA
R3sTk8efwUYy7cxiZHhQPHwl6xQIuj+log7gOyBmhKwV8sj4XlOxLh4GAsz4lwaF
x2RkLe7/r6HZ443U1WLOQ2befz6bQHBN1QuDJ/XV+h7ksbp4JM70y65Gerj3Z5F0
MwBc/ErKc2ne2/4mojgI6xO1Oz7EA9JXCaTlBS7YeJh7KvH35vPoEKPCc+8nSFXv
Haa7072Tj5VlpPpKGniKZ3kDrAbctUmAlzqcwT1J/AuYMjugHxCWYI1tpwy3ubUp
LMNldG9MPywGf2C8oTcm+iHC9KqLZM4S1l7vVRIudd6/qnq3exf7YZYigQIwAEGx
cE+WCYX1Faz/UTq1U8bKxTPqQOq0rzFq0NxzsCf/Jr7s6L6VCG52jKooxEGaislq
Uwc3edQGoeQ=
=ymEe
-----END PGP SIGNATURE-----
--=-=-=--
