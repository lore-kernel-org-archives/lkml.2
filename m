Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1JKPee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 11:34:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48158 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab1JKPed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 11:34:33 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=vhdKIqpQuCYA:10 a=DBsgwU1kSp4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VwQbUJbxAAAA:8 a=kTZer95UXMY13QNFqvgA:9 a=Wezg9556JUJiPGegTGgA:7 a=QEXdDO2ut3YA:10 a=eA_X9dplh2M4FXXEgsgA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111011152026.701326733@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 11 Oct 2011 11:20:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2 v2] [GIT PULL][v3.2] tracing: queued updates
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

I found the build bug with ftrace disabled. It was in the second to last
patch of the series. It was a cut and paste error where the ftrace_is_dead()
stub had "extern static inline" which caused the error.

I rebased and pushed to my git tree. Please check the SHA1, even though
the mirrors should be updated by now.

I tested this branch with the following:

 allnoconfig + minconfig to boot

 full ftrace enabled to boot and test

 ftrace without function tracing to boot and test

 no tracing enabled to boot and test

 allmodconfig to boot and test - a call trace dumped from a non
  related bug (in slub). I will investigate this later.

 allyesconfig to build - just made sure it builds.

I'm only sending out the last two patches as the other patches are
still the same. The rebase started from the second patch.

-- Steve

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: d696b58ca2c3ca76e784ef89a7e0453d9b7ab187


Steven Rostedt (2):
      tracing: Warn on output if the function tracer was found corrupted
      tracing: Do not allocate buffer for trace_marker

----
 kernel/trace/ftrace.c |    8 +++
 kernel/trace/trace.c  |  126 ++++++++++++++++++++++++++++++++++++++-------=
----
 kernel/trace/trace.h  |    2 +
 3 files changed, 108 insertions(+), 28 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOlGIHAAoJEIy3vGnGbaoAgyAQALfcDC+Hp4U9MP4L+c9yODOJ
eg0U2ywfWxNBLqPdFd+uEy1UfyTGvKcLL8QJ8mMTOOJdEa3JH8cNFd203ZZQy60f
X+McXWWe21g3r8M81WElV6PeVUjIENeZpE+rCJf+dOtH6MCBm9ak4LDpGaE/TOXO
+EMGC0V+VdSLNkmT0OFJyWnJRjz3Xrmb49jxYiZ1N5YuRIZMMEICj0hFtPfMImz/
zYrZeiYuTF0Ip4ptCoPmwDxFbMzIq2W6T7mc4uYJxK0kMNYJKhv4fCAW6uKTc4qF
OIQewC1TfpB6OHtLKdh4l85Pk5Otwgh55sJBENq1nua9aABqxW61/X7z78qsx+jV
q9AYGKOAWW68DWPFGwqjqhs+3qsEQESTAdJeICgz6RgyBKdR5uZPvt5dLDqWSPyo
sZobFwRSezNSQC9gt8etufXanqvM3VZwvEpeXfQlfTR3tFp8/qn5/bZdGiDBG2/Q
9CvF0NWwBoWiStZ9bpc+cQ6m6GDX3dz7pVYwkNh50uOETd4Gq8YINzkjKLfNUO72
u2HXwaUaGZt/oRR8x6zjiY7mdxmKZ3ki+iTitCTn174ZNW8E+uKtQ9wCA07W4CZk
19sx8j6Co/RtESugYwkJBsVN9TRZ84j9uJi3CB2f3vKR9FX8yhFz7a5m5Tipqci5
VYUcmSUZNBrfXcR9ei5h
=0sdH
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
