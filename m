Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab2F2VlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 17:41:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15638 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2F2VlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 17:41:21 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=PhtVdaRf5awA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=hJ3ONOwfQc85rlPyP1EA:9 a=QEXdDO2ut3YA:10 a=j9zH3yVq2Vb4LOTxaDoA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120629213545.533870841@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 29 Jun 2012 17:35:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 0/2] [GIT PULL][v3.5] ring-buffer: Fixes for the changes in the last merge window
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

This patch series has a couple of fixes for bugs that snuck into the last
merge window. The first is a crash that can happen because of an
uninitialized list, and failing to allocate the requested amount. This
can happen by changing the buffer_size_kb to a huge amount as the first
change that is done to it after booting up (note, the bug does not happen
if a successful change happens first).

The second patch can cause the ring buffer accounting (which is used by
the infrastructure of the ring buffer) to get out of sync. This happens
if you fill the buffer and then remove a few pages from it while it
is full.

The fixes are pretty simple, and should go into the 3.5-rc.

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: 48fdc72f23ad9a9956e524a47843135d0bbc3317


Vaibhav Nagarnaik (2):
      ring-buffer: Fix crash due to uninitialized new_pages list head
      ring-buffer: Fix accounting of entries when removing pages

----
 kernel/trace/ring_buffer.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7iD7AAoJEIy3vGnGbaoA5OoQAKx/mJ/WDuQDgdtM9I2WJ55m
nV5CzPrbap63ZHXA9sZOR02OI2aup+tQI1qa643F6YKWzPMFnhJ1KpMAcqnxvG8u
0DiBQjE+no/zb3Pt04DM3o08bKFpTNfJiTYsuvOOMhU9BLxClp/ZsGoxtLvbdJQ8
6swC2UZ9y2dAK0/o6nLoupgo4oCGJRvtwUeW8rJqVCy0KC7UqGKr4LWX+0nyAoFW
VmUQ7bDNbmcrANz3Hw1xe4S5Ytw1qT127RE3JkO6Le6PFFcRX3/AinAD1N0azVDB
DSpiyuyirASYiajeiNT/2vLrCOSfbh5cYZ+d+p6tPZkcF5d/ohTVqp7afbAfvtH2
YuliJtJ9T6Ar4q18c8lyMSQvryhcyUHng2FMbPk6OiPJWWrx/yoJzInvArEPRGnR
aoqisDJfRfOFwymcOu4C/WA8wga7JtYqZjHDXCNadr7fXWtWcfrfKHlcEsBn/6nM
jYq7iyywJVGVvVANu9959NMoPUVsyLqLK4KsIsRKAx4F+F6TBxUgHeSk9KoIiF8P
EE9HKSDDsjTv9TPQvJvBc0wz+eovWb1TKMmKsRFIKFEzXQrTiavbuBfXcN8CTETO
aIQfcks/YwDSL3V+VK/9zrKb2iN/IjDnjLGWy06WkeyqS0Gv4RntmRGIkMrINIyn
MdtDnIAEMAL2MP+1bZt3
=OMCk
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
