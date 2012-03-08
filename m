Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876Ab2CHWWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:22:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15050 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728Ab2CHWWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:22:02 -0500
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=JwEzzm2Qo8kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=MW9TR38vLfj99IOdX0wA:9 a=QEXdDO2ut3YA:10 a=PHYEcKVQtTFqr12RrKEA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120308221730.807074710@goodmis.org>
User-Agent: quilt/0.50-1
Date: Thu, 08 Mar 2012 17:17:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH 0/7] [GIT PULL] jump-labels: Implement 2 and 5 byte jumps
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

A while ago I posted this series and you discovered a bug. I fixed that
bug, but due to traveling and other responsibilities I'm not sure
I posted the fix.

The fix is the last patch in this series.

As things have changed since the last post, there were a lot of conflicts,
and I had to rebase the patch set against tip/perf/jump-labels and
fix up the patches. Mostly the changes from JUMP_LABEL_* to STATIC_KEY_*.

But I got this done and retested them.

-- Steve

Please pull the latest tip/perf/jump-label-5 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/jump-label-5

Head SHA1: b0fdf8910bf8e30fd3542b05062ca9a9721cf26f


Steven Rostedt (7):
      x86/jump-label: Use best default nops for inital jump label calls
      x86/jump-label: Do not bother updating nops if they are correct
      x86/jump-label: Add safety checks to jump label conversions
      jump labels: Add infrastructure to update jump labels at compile time
      x86/jump labels: Use etiher 5 byte or 2 byte jumps
      x86/jump lables: Show where and what was wrong on errors
      x86/jump labels: Handle initialization of enabled nops

----
 Makefile                          |    7 +
 arch/Kconfig                      |    6 +
 arch/x86/Kconfig                  |    1 +
 arch/x86/include/asm/jump_label.h |   14 ++-
 arch/x86/kernel/jump_label.c      |  121 ++++++++++++-
 scripts/Makefile                  |    1 +
 scripts/Makefile.build            |   15 ++-
 scripts/update_jump_label.c       |  341 +++++++++++++++++++++++++++++++++=
++++
 scripts/update_jump_label.h       |  208 ++++++++++++++++++++++
 9 files changed, 700 insertions(+), 14 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPWTEFAAoJEIy3vGnGbaoAzL4P/j/DjzMgYVr9cF6fluAV+XZZ
eYiC/YhE5U/+7QTiYe9Az64gClM0IMM/9aHB6roJGPYSDIeeWGJ2eSKloCG2pvfm
oARGTKDdIBZHLL+TUtfGEPex7d8WMkQv8WOJ9zKJrmExBMdYwJTwXEh80c8IMo04
ax+CoVfjd7L/hUdpWIE+arRNalCA/RZBxpDUofaajDiLOado1scqK3D4v5Z/u1an
UW8dhiiWTtVGIlIEe8EVlYf4SFzK+mGESqwO/PVJV9HxdE3OAVm+yHQ9lL/fBL4N
g5sNpEgmPPnmI+b8r6ENX+Nuqda7HwIN/Nx42O8Qt199/Rrz/JunpKN0XTkKEDxE
Y3IObqxrTfzTT64VM68Ef0hZMGh3QSRQIdtxKzwvjT/65HtQal4rQ11Wtnq3nCTC
EZt05eUtJOriTowdb664j+9ELrnXeJRmJAb5OYy9SEzsvAlzPKoXT47ynrzDO7ie
CSD8jDePRoHJFA4uF7FtjOXGu91bMQg5/j8skyeR6kV7nB5GeXcC6OWqO9yREshC
kJa7MeWXrxlY+UDVyOcWyPUxxRfK0P+WyKFf/wQxnKmJPKhqjPnDDLVEfEQj5n0y
V3yI7aY3q0CrVsLgXoiyIgZM2zn406R4Bx6boHlgs5HuQfEJFfpDseODb1XOfEAt
yQVc4mpC2klqXYFaJDRG
=ji6H
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
