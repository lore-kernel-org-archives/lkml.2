Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1LGOsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 09:48:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072Ab1LGOsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 09:48:02 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org, linux-security-module@vger.kernel.org
cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan@linux.intel.com, alan@lxorguk.ukuu.org.uk
Subject: [GIT PULL] Crypto keys and module signing
Date: Wed, 07 Dec 2011 14:47:42 +0000
Message-ID: <28442.1323269262@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi James,

Could you pull my module signing code into the security tree?  The patches can
be viewed here:

http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/devel

The only significant difference between the version #3 patch posting I made
and the current code is that I've discarded the DSA algorithm and the
references to it.

I haven't included the MPI lib commits from Dmitry as they should be the same
as reside in your tree already.

David
---
The following changes since commit 7e8dec918ef8e0f68b4937c3c50fa57002077a4d:

  crypto: GnuPG based MPI lib - additional sources (part 4) (2011-11-09 11:47:26 +0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-modsign.git devel

David Howells (20):
      MPILIB: Export some more symbols
      MPILIB: Add a missing ENOMEM check
      KEYS: Permit key_serial() to be called with a const key pointer
      KEYS: Move the key config into security/keys/Kconfig
      KEYS: Announce key type (un)registration
      KEYS: Reorganise keys Makefile
      KEYS: Create a key type that can be used for general cryptographic operations
      KEYS: Add signature verification facility
      KEYS: Asymmetric public-key algorithm crypto key subtype
      KEYS: RSA signature verification algorithm
      PGPLIB: PGP definitions (RFC 4880)
      PGPLIB: Basic packet parser
      PGPLIB: Signature parser
      KEYS: PGP data parser
      KEYS: PGP-based public key signature verification
      KEYS: PGP format signature parser
      KEYS: Provide a function to load keys from a PGP keyring blob
      MODSIGN: Add indications of module ELF types
      MODSIGN: Module ELF verifier
      MODSIGN: Apply signature checking to modules on module load

 .gitignore                             |   15 +
 Documentation/module-signing.txt       |  186 +++++++
 Documentation/security/keys-crypto.txt |  302 +++++++++++
 Makefile                               |    1 +
 arch/alpha/include/asm/module.h        |    3 +
 arch/arm/include/asm/module.h          |    5 +
 arch/cris/include/asm/module.h         |    5 +
 arch/h8300/include/asm/module.h        |    5 +
 arch/ia64/include/asm/module.h         |    5 +
 arch/m32r/include/asm/module.h         |    5 +
 arch/m68k/include/asm/module.h         |    5 +
 arch/mips/include/asm/module.h         |   12 +-
 arch/parisc/include/asm/module.h       |    8 +
 arch/powerpc/include/asm/module.h      |   10 +
 arch/s390/include/asm/module.h         |    3 +
 include/asm-generic/module.h           |   10 +
 include/keys/crypto-subtype.h          |   77 +++
 include/keys/crypto-type.h             |   37 ++
 include/linux/elfnote.h                |    4 +
 include/linux/key.h                    |    2 +-
 include/linux/modsign.h                |   27 +
 include/linux/module.h                 |    3 +
 include/linux/pgp.h                    |  255 +++++++++
 init/Kconfig                           |   65 +++
 kernel/Makefile                        |    4 +
 kernel/modsign-pubkey.c                |   44 ++
 kernel/module-verify-elf.c             |  344 ++++++++++++
 kernel/module-verify-sig.c             |  526 ++++++++++++++++++
 kernel/module-verify.c                 |   44 ++
 kernel/module-verify.h                 |   68 +++
 kernel/module.c                        |   25 +-
 lib/mpi/mpi-cmp.c                      |    2 +
 lib/mpi/mpi-div.c                      |    1 +
 lib/mpi/mpi-inv.c                      |    1 +
 lib/mpi/mpi-mpow.c                     |    1 +
 lib/mpi/mpi-mul.c                      |    1 +
 lib/mpi/mpicoder.c                     |    2 +
 net/dns_resolver/dns_key.c             |    5 -
 scripts/Makefile.modpost               |   85 +++-
 scripts/mod/.gitignore                 |    1 +
 scripts/mod/Makefile                   |    2 +-
 scripts/mod/mod-extract.c              |  913 ++++++++++++++++++++++++++++++++
 scripts/mod/modsign-note.sh            |   16 +
 security/Kconfig                       |   68 +---
 security/keys/Kconfig                  |  121 +++++
 security/keys/Makefile                 |   25 +-
 security/keys/crypto_keys.h            |   28 +
 security/keys/crypto_rsa.c             |  282 ++++++++++
 security/keys/crypto_type.c            |  228 ++++++++
 security/keys/crypto_verify.c          |  111 ++++
 security/keys/key.c                    |    3 +
 security/keys/pgp_key_parser.c         |  344 ++++++++++++
 security/keys/pgp_library.c            |  531 +++++++++++++++++++
 security/keys/pgp_parser.h             |   35 ++
 security/keys/pgp_preload.c            |   90 ++++
 security/keys/pgp_pubkey_sig.c         |  323 +++++++++++
 security/keys/pgp_sig_parser.c         |  104 ++++
 security/keys/public_key.c             |   55 ++
 security/keys/public_key.h             |  108 ++++
 59 files changed, 5506 insertions(+), 85 deletions(-)
 create mode 100644 Documentation/module-signing.txt
 create mode 100644 Documentation/security/keys-crypto.txt
 create mode 100644 include/keys/crypto-subtype.h
 create mode 100644 include/keys/crypto-type.h
 create mode 100644 include/linux/modsign.h
 create mode 100644 include/linux/pgp.h
 create mode 100644 kernel/modsign-pubkey.c
 create mode 100644 kernel/module-verify-elf.c
 create mode 100644 kernel/module-verify-sig.c
 create mode 100644 kernel/module-verify.c
 create mode 100644 kernel/module-verify.h
 create mode 100644 scripts/mod/mod-extract.c
 create mode 100644 scripts/mod/modsign-note.sh
 create mode 100644 security/keys/Kconfig
 create mode 100644 security/keys/crypto_keys.h
 create mode 100644 security/keys/crypto_rsa.c
 create mode 100644 security/keys/crypto_type.c
 create mode 100644 security/keys/crypto_verify.c
 create mode 100644 security/keys/pgp_key_parser.c
 create mode 100644 security/keys/pgp_library.c
 create mode 100644 security/keys/pgp_parser.h
 create mode 100644 security/keys/pgp_preload.c
 create mode 100644 security/keys/pgp_pubkey_sig.c
 create mode 100644 security/keys/pgp_sig_parser.c
 create mode 100644 security/keys/public_key.c
 create mode 100644 security/keys/public_key.h
