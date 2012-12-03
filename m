Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab2LCEUE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 23:20:04 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58422 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2LCEUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 23:20:02 -0500
Date: Mon, 3 Dec 2012 15:19:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20121203151948.4210a510fcedb5fe5b2ee150@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Dec_2012_15_19_48_+1100_mAa9/aT77uI2tQMw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Dec_2012_15_19_48_+1100_mAa9/aT77uI2tQMw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
tools/perf/Makefile between commit d2709c7ce4c5 ("perf: Make perf build
for x86 with UAPI disintegration applied") from Linus' tree and commit
945aea220bb8 ("perf tests: Move test objects into 'tests' directory")
from the tip tree.

I just used the version from Linus' tree (since it seems to be a superset
of the latter - see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc tools/perf/Makefile
index 0a619af,cca5bb8..0000000
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@@ -169,36 -169,16 +169,43 @@@ endi
 =20
  ### --- END CONFIGURATION SECTION ---
 =20
 -BASIC_CFLAGS =3D -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I=
util -I. -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=3D6=
4 -D_GNU_SOURCE
 +ifeq ($(srctree),)
 +srctree :=3D $(patsubst %/,%,$(dir $(shell pwd)))
 +srctree :=3D $(patsubst %/,%,$(dir $(srctree)))
 +#$(info Determined 'srctree' to be $(srctree))
 +endif
 +
 +ifneq ($(objtree),)
 +#$(info Determined 'objtree' to be $(objtree))
 +endif
 +
 +ifneq ($(OUTPUT),)
 +#$(info Determined 'OUTPUT' to be $(OUTPUT))
 +endif
 +
 +BASIC_CFLAGS =3D \
 +	-Iutil/include \
 +	-Iarch/$(ARCH)/include \
 +	$(if $(objtree),-I$(objtree)/arch/$(ARCH)/include/generated/uapi) \
 +	-I$(srctree)/arch/$(ARCH)/include/uapi \
 +	-I$(srctree)/arch/$(ARCH)/include \
 +	$(if $(objtree),-I$(objtree)/include/generated/uapi) \
 +	-I$(srctree)/include/uapi \
 +	-I$(srctree)/include \
 +	-I$(OUTPUT)util \
 +	-Iutil \
 +	-I. \
 +	-I$(TRACE_EVENT_DIR) \
 +	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE
  BASIC_LDFLAGS =3D
 =20
+ ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
+ 	BIONIC :=3D 1
+ 	EXTLIBS :=3D $(filter-out -lrt,$(EXTLIBS))
+ 	EXTLIBS :=3D $(filter-out -lpthread,$(EXTLIBS))
+ 	BASIC_CFLAGS +=3D -I.
+ endif
+=20
  # Guard against environment variables
  BUILTIN_OBJS =3D
  LIB_H =3D

--Signature=_Mon__3_Dec_2012_15_19_48_+1100_mAa9/aT77uI2tQMw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQvChkAAoJEECxmPOUX5FEay0P/jmUejCTH/P9vwxF0MUg9pgZ
ZqE0tddeObOCoGl4omFpsPFX/dQ+VLA/hyQABENM8oMf4sheRXcKKpkaJ05ReV8C
xnaCIu1rw74L36YCtvgC1mlQnQpVkUnzDxYjDITtOJk92L9OJVR7gDRTxnaPBG+v
CE8ffDueAeHMSYLkzQPqODjUGhu7ZrQu5LvpWBSVsycbPA3dyqiCvJtuBLJyRmv4
xeK0srRMrOyUXXSr0AE1TXKXsQEc87tocVJDBad6wUxW88L3OR7Zc6wcqHI/GcNz
KXw0LjWWJLFz6uEVeJ7F0Bym1pUU8jDnTIh61LKvkm+21pdtDBMEjCpnIxUcAqrL
duYzEM/KL/Oq01x1sWCRdwhyL6ZpZGGaa7UdK7wjcldV2nmcF+CWddboCQ0hCvqp
1oSlJVVrjv2HNXKe/2z1/6YaY+6BwcYbbyvDlLn42A2EWI1rlARUmLMjWdiVxKNi
cfJ6bowE5GOxa7Fnev5INc0caF3kqjxuOdXGGvihLWMBdIlJH/RmGThnyhqgUYjm
XIl6fe5Bh9MNPKfZAMBj+PTzfGOVBJb9ewp50m6ZSHLRrHdSOjj07g1G8x+erua1
bMKJ2zJAsiP5Ahf/8nbks37jgJkrjIZNT/0UnUxCKevszTsFRCPhzWFU474HRtom
sZSWvZ4Bg0rVt3lq2CoN
=XPeO
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Dec_2012_15_19_48_+1100_mAa9/aT77uI2tQMw--
