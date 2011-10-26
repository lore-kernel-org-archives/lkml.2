Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab1JZPNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:13:22 -0400
Received: from home.keithp.com ([63.227.221.253]:49076 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933076Ab1JZPNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:13:21 -0400
From: Keith Packard <keithp@keithp.com>
To: Alex Davis <alex14641@yahoo.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mjg\@redhat.com" <mjg@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: Re: [Regression] Laptop screen dark when lid closed and reopened.with 3.1
In-Reply-To: <1319599156.52195.YahooMailNeo@web130106.mail.mud.yahoo.com>
References: <1316478488.72684.YahooMailNeo@web130114.mail.mud.yahoo.com> <1316868946.61433.YahooMailNeo@web130123.mail.mud.yahoo.com> <yunvcsim1wk.fsf@aiko.keithp.com> <1316877222.89367.YahooMailNeo@web130124.mail.mud.yahoo.com> <yunsjnln8it.fsf@aiko.keithp.com> <1316957004.77729.YahooMailNeo@web130108.mail.mud.yahoo.com> <1317583219.81808.YahooMailNeo@web130113.mail.mud.yahoo.com> <1319599156.52195.YahooMailNeo@web130106.mail.mud.yahoo.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 26 Oct 2011 08:13:14 -0700
Message-ID: <yunmxcnhjlh.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Oct 2011 20:19:16 -0700 (PDT), Alex Davis <alex14641@yahoo.com> =
wrote:

> At the request of Kamal Mostafa, an Ubuntu kernel developer, I am resubmi=
tting this patch which fixes my backlight issue.
> It seem that there are a number of people with different machines that ha=
ve this problem:

We have a patch that should land in a 3.1 stable release that should
resolve this issue; can you test that?

commit f52c619a590fa75276c07dfcaf380dee53e4ea4c
Author: Takashi Iwai <tiwai@suse.de>
Date:   Fri Oct 14 11:45:40 2011 +0200

    drm/i915/panel: Always record the backlight level again (but cleverly)
=20=20=20=20
    The commit 47356eb67285014527a5ab87543ba1fae3d1e10a introduced a
    mechanism to record the backlight level only at disabling time, but it
    also introduced a regression.  Since intel_lvds_enable() may be called
    without disabling (e.g. intel_lvds_commit() calls it unconditionally),
    the backlight gets back to the last recorded value.  For example, this
    happens when you dim the backlight, close the lid and open the lid,
    then the backlight suddenly goes to the brightest.
=20=20=20=20
    This patch fixes the bug by recording the backlight level always
    when changed via intel_panel_set_backlight().  And,
    intel_panel_{enable|disable}_backlight() call the internal function not
    to update the recorded level wrongly.
=20=20=20=20
    Cc: <stable@kernel.org>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>
    Reviewed-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Keith Packard <keithp@keithp.com>


=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTqgjijYtFsjWk68qAQjxABAAmbHALMgA+nCjzvK1p346Ef92oricjz3Z
KBpbBWQPilBmjYJz7C51D4cYdTPv+IKgy8tQGtSk8Hf046iw2kounhF21NLTPAy7
+z+TnsgA6kJpQehiE0jTzbVz16JhE7MyT+0Mjye+/DuUnVbTefbTpOrLLijsuxz5
Y61G4yojaxrv7LXwfPh90AC68sOEzUriko23RrWMt3OcwXBEGmh6uFITjM91w3Zd
9QC5ZOpsJ0OcFuJf2Jht9Hbjca/VdIOvPjSnHSnx65H6gFgaXxGJhhHry4kQQB1E
MOlrF/Bo1ZgmFBndFnUm0Pd4ZAGRxpYGoiM2ZF+QolTSoX/QRb51j9vn9sRt2ily
QwbgqUleFmHaV7bL4YGq/6VnVn4xsZExwFkMvu9vmwDaKzXaD9+vXwh85B9iYLl5
AEMTG5OC61ofYgJLJsZu39m5MTZyVT5ZavkQmrmLVE3OhS5Pm/4vpjJkvjhSQ5WX
uIUXVJ8Drgt3U1Ft9ds1uS5Ugndtnu9eS1DsIalZ+nSDQNHkljq8esCByEfSJobz
3bz2Hvnbf5UiWeRJpjGfM5/qaYG5YtFNK2RVwVXzMMbqKMKrKHO2xobTmufH8lRT
+VVD4YgCA7NtH4nav1HP1dfm/0+IAE1mifJ9s1udtof2vorU2IDJ9eNdVYVKHlve
j/lInyCLW6M=
=Yzq6
-----END PGP SIGNATURE-----
--=-=-=--
