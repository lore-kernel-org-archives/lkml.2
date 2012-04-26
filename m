Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2DZChO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 22:37:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5204 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2DZChJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 22:37:09 -0400
X-Authority-Analysis: v=2.0 cv=IaEFqBWa c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=_-UaAGdScbEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=CQKkfJl2KeeFz0EUn1AA:9 a=CQe82pGuQ8RVVRQGJf8A:7 a=QEXdDO2ut3YA:10 a=1mLKGT7Vnfs52oAO2g8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120426022922.683707508@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 25 Apr 2012 22:29:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/6][RFC] tracing/kprobes: Get ready for -mfentry
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

As I want to add the -mfentry to allow for function tracing without
frame pointers (as some distros are now disabling function tracing :-(

I have to handle the case that a kprobe is placed on a ftrace nop.
As ftrace nops with -mfentry will be the first instruction of a
function, it being the location of a kprobe is a likely occurrence.

Ideally, kprobes would just use the function tracing infrastructure
to make an automatic optimized jump. But that is for another day as it
requires a bit of work in the function tracer to handle regs and such.

So the quick fix for now is to simply move the probe to the next
instruction after the ftrace nop. As the nop shouldn't be doing anything
anyway (and tracing should return to the function in the same state)
moving the location of the probe should not cause any harm.

The first 5 patches are non controversial, and could probably just be
pushed for 3.5 inclusion. The last patch makes the change to move the
probe to the next instruction after the ftrace nop.

Anyone see any problem with this?

-- Steve


Steven Rostedt (6):
      ftrace: Sort all function addresses, not just per page
      ftrace: Remove extra helper functions
      ftrace: Speed up search by skipping pages by address
      ftrace: Consolidate ftrace_location() and ftrace_text_reserved()
      ftrace: Return record ip addr for ftrace_location()
      kprobes: Allow probe on ftrace reserved text (but move it)

----
 include/asm-generic/vmlinux.lds.h |    2 +-
 include/linux/ftrace.h            |    2 +-
 kernel/kprobes.c                  |   11 ++-
 kernel/trace/ftrace.c             |  173 ++++++++++++++++++++-------------=
----
 4 files changed, 104 insertions(+), 84 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPmLTMAAoJEIy3vGnGbaoADWQQAOMn5AtLXtrcJmm4Y8d0jdUb
+JaWygIe/Tq7PtDmcPLHVNqXhPew/bHhcpZ1pZU9lDTqyqM+/QxtlzQYeEAQbeOe
902PGy9rcT6TUVrMinwKM74ZKRRfdas5jpn/DyJmnhzv47HVsGLF/Gcne8XehY0a
slqrjlP1t8TGKW+1bE842DjuG7VMculxUvBZT+liIkd32JA2at1uqffn/UeDCKa5
VX1boyh8B236idCX76wlGEANGa/QtS5lViadof1P5XFG72IAXbOP5iNqwzAIIP0a
yMfZ5Pj785KfxLV54ZHHQ05b8D1yOJz+pXq6rB6tzj7YdD/r0JV8L3YExGePT1iS
AgL+cCNMvS00UXTtstj1Vm4YYV8LxEemsRZEYuHqoY/51iwIw5xc4YT9LRmDkp00
Oa5Jn24nP6uKukUHp9shq4ossCLXP38a3/J1+TsqHLJtLVGXG9UUzgPGsJh9PU5o
RfiuF7DCNAXCdaxHZYfhERaen1aUsSHi0GY/vzYwyBbQQiHoux/+yWsSpf3Skn3S
AamFehXXxvdG2Sl/h19ne5o/IUZq+oSrpWnpBeL+eYBo9oBR+ryl8WWprfUQcpXl
vEXcHnGh0pn4utVq1dm7P3Uo0W0rBYI5+tpbbmLR8aQgu3hPqdSXzhGCLDHoKWgZ
ZVpgQMuwmd4HskmuyikU
=ximU
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
