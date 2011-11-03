Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab1KCVHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:07:07 -0400
Received: from home.keithp.com ([63.227.221.253]:41910 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab1KCVHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:07:06 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel@ffwll.ch>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>, stable@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Morton\, Andrew" <akpm@linux-foundation.org>
Subject: Re: [Intel-gfx] [PATCH 2/2] drm/i915: properly prefault for pread/pwrite
In-Reply-To: <20111023221157.GH2953@phenom.ffwll.local>
References: <1317203844-2930-1-git-send-email-daniel.vetter@ffwll.ch> <1317203844-2930-2-git-send-email-daniel.vetter@ffwll.ch> <f80fcd$212d29@fmsmga001.fm.intel.com> <20111023101830.GE2953@phenom.ffwll.local> <yun7h3vbjgc.fsf@aiko.keithp.com> <20111023221157.GH2953@phenom.ffwll.local>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 03 Nov 2011 14:06:55 -0700
Message-ID: <yunzkgcrk40.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Oct 2011 00:11:57 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:

> This patch only fixes things up so that we prefault the entire page range
> and not just the first PAGE_SIZE bytes (i.e. at most 2 pages). So I don't
> see the risk of extending the current behaviour to all pages. Userspace
> can already see these zero writes, but only when doing something stupid.

When we posted a patch to instead fix fault_in_pages_writeable, Andrew
complained that we'd have modified memory even on a short read, which
wasn't considered polite. Could we read/write the same value and avoid
that problem?

Also, we should be fixing fault_in_pages_* going forward, rather than
kludging in more code. And, we'd get to remove the version in ntfs,
which should end in a patch that removes more code than it adds...

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrMCbzYtFsjWk68qAQgrfRAAsCZyxc9aaWTYWh6nm0TFXUiSbe3mhIRn
p1l3BgsiJ+ATp53HaCFSHgG54HGNk3bxnMiUGeWg9K79UHnf8CAE3ZGWJyJmzS+t
1UOhy0lWtLl3UHmujk6jFPNgoqsAkP0KCZHXkfDr8s17JWWf5Az5kFFUg7gIzSEQ
FKdQ5EMlVX+Y/yWdMIzwqCjI4UV/tKmShRDWHT64olYERFzCppOfM6SoXLijmyhV
jTXTG92K2r1dw44YBDTonEVjqThaHE+rsKkVyHeZavTt3xQ1b2ug80Cv4nnbThdV
swjwCpaCs7KElVRnurqJplQQWWDNVRwTRvKNzCau2D1Ji3klOTPZUZ8Xm4w2n5eP
qYzerWSlEuCm/yD5eGLAD+pVBxcxltrXGTfFLtzjD4AfPCR9Bvdb4bntUgBrN4OC
HmavzwPeHU6e965mHgxqWr+ZQcaFr0FG1ukEueiqbmZJi8pJYZwlkcjswMrvW/Xs
y+IHyFuDYcXq9spUXEcSaz7FkL57KIwtLov98nHYvKIHTiM0ssz02ajZpcr1JLXX
PPLIAAm6X8+3HrhS7Nffl4RMKQQq6xk3RqNGH86aXIwqSL1azjZMO+QsMmAaH+zI
MPz+IVjRoNJF57FwwlyrmpGReIYEq+88wU1JDjr2pd8/p66Tr+U61m328P1P/07u
6w636prxbKA=
=gH6w
-----END PGP SIGNATURE-----
--=-=-=--
