Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab2I0JIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 05:08:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2I0JIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 05:08:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87bogs492s.fsf@rustcorp.com.au>
References: <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au, pjones@redhat.com,
        jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Date: Thu, 27 Sep 2012 10:08:25 +0100
Message-ID: <16088.1348736905@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Rusty,

Could you pull my tree?

David
---

The following changes since commit eeea3ac912207dcf759b95b2b4c36f96bce583bf:

  Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2012-09-06 10:23:58 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-modsign.git modsign-post-KS

for you to fetch changes up to 15765081423824e1ccc329264ae13f5ea87f3a85:

  MODSIGN: Sign modules during the build process (2012-09-26 10:11:06 +0100)

----------------------------------------------------------------
(from the branch description for modsign-post-KS local branch)

post Kernel-Summit module signing
----------------------------------------------------------------
David Howells (24):
      KEYS: Add payload preparsing opportunity prior to key instantiate or update
      MPILIB: Provide count_leading/trailing_zeros() based on arch functions
      KEYS: Document asymmetric key type
      KEYS: Implement asymmetric key type
      KEYS: Asymmetric key pluggable data parsers
      KEYS: Asymmetric public-key algorithm crypto key subtype
      KEYS: Provide signature verification with an asymmetric key
      MPILIB: Reinstate mpi_cmp[_ui]() and export for RSA signature verification
      RSA: Implement signature verification algorithm [PKCS#1 / RFC3447]
      RSA: Fix signature verification for shorter signatures
      X.509: Implement simple static OID registry
      X.509: Add utility functions to render OIDs as strings
      X.509: Add simple ASN.1 grammar compiler
      X.509: Add an ASN.1 decoder
      MPILIB: Provide a function to read raw data into an MPI
      X.509: Add a crypto key parser for binary (DER) X.509 certificates
      MODSIGN: Add FIPS policy
      MODSIGN: Provide gitignore and make clean rules for extra files
      MODSIGN: Provide Kconfig options
      MODSIGN: Automatically generate module signing keys if missing
      MODSIGN: Provide module signing public keys to the kernel
      MODSIGN: Implement module signature checking
      MODSIGN: Provide a script for generating a key ID from an X.509 cert
      MODSIGN: Sign modules during the build process

Rusty Russell (1):
      module: signature checking hook

 .gitignore                                |   14 +
 Documentation/crypto/asymmetric-keys.txt  |  312 ++++++
 Documentation/kernel-parameters.txt       |    6 +
 Documentation/security/keys.txt           |   50 +-
 Makefile                                  |    1 +
 crypto/Kconfig                            |    1 +
 crypto/Makefile                           |    1 +
 crypto/asymmetric_keys/.gitignore         |    1 +
 crypto/asymmetric_keys/Kconfig            |   38 +
 crypto/asymmetric_keys/Makefile           |   27 +
 crypto/asymmetric_keys/asymmetric_keys.h  |   15 +
 crypto/asymmetric_keys/asymmetric_type.c  |  274 +++++
 crypto/asymmetric_keys/public_key.c       |  108 ++
 crypto/asymmetric_keys/public_key.h       |   30 +
 crypto/asymmetric_keys/rsa.c              |  277 ++++++
 crypto/asymmetric_keys/signature.c        |   49 +
 crypto/asymmetric_keys/x509.asn1          |   60 ++
 crypto/asymmetric_keys/x509_cert_parser.c |  497 ++++++++++
 crypto/asymmetric_keys/x509_parser.h      |   36 +
 crypto/asymmetric_keys/x509_public_key.c  |  207 ++++
 crypto/asymmetric_keys/x509_rsakey.asn1   |    4 +
 fs/cifs/cifs_spnego.c                     |    6 +-
 fs/cifs/cifsacl.c                         |    8 +-
 include/asm-generic/bitops/count_zeros.h  |   57 ++
 include/crypto/public_key.h               |  108 ++
 include/keys/asymmetric-parser.h          |   37 +
 include/keys/asymmetric-subtype.h         |   55 +
 include/keys/asymmetric-type.h            |   25 +
 include/keys/user-type.h                  |    6 +-
 include/linux/asn1.h                      |   67 ++
 include/linux/asn1_ber_bytecode.h         |   87 ++
 include/linux/asn1_decoder.h              |   24 +
 include/linux/key-type.h                  |   35 +-
 include/linux/module.h                    |    8 +
 include/linux/mpi.h                       |    1 +
 include/linux/oid_registry.h              |   92 ++
 init/Kconfig                              |   68 ++
 kernel/Makefile                           |   57 ++
 kernel/modsign_pubkey.c                   |  112 +++
 kernel/module-internal.h                  |   15 +
 kernel/module.c                           |   97 +-
 kernel/module_signing.c                   |  243 +++++
 lib/.gitignore                            |    2 +-
 lib/Kconfig                               |    5 +
 lib/Makefile                              |   18 +
 lib/asn1_decoder.c                        |  477 +++++++++
 lib/build_OID_registry                    |  209 ++++
 lib/mpi/Makefile                          |    1 +
 lib/mpi/longlong.h                        |  138 +--
 lib/mpi/mpi-bit.c                         |    2 +-
 lib/mpi/mpi-cmp.c                         |   70 ++
 lib/mpi/mpi-pow.c                         |    4 +-
 lib/mpi/mpicoder.c                        |   55 +
 lib/oid_registry.c                        |  170 ++++
 net/ceph/crypto.c                         |    9 +-
 net/dns_resolver/dns_key.c                |    6 +-
 net/rxrpc/ar-key.c                        |   40 +-
 scripts/.gitignore                        |    1 +
 scripts/Makefile                          |    2 +
 scripts/Makefile.build                    |   11 +
 scripts/Makefile.modpost                  |   75 +-
 scripts/asn1_compiler.c                   | 1545 +++++++++++++++++++++++++++++
 scripts/sign-file                         |  115 +++
 scripts/x509keyid                         |  268 +++++
 security/keys/encrypted-keys/encrypted.c  |   16 +-
 security/keys/key.c                       |  114 ++-
 security/keys/keyctl.c                    |   18 +-
 security/keys/keyring.c                   |    6 +-
 security/keys/request_key_auth.c          |    8 +-
 security/keys/trusted.c                   |   16 +-
 security/keys/user_defined.c              |   14 +-
 71 files changed, 6387 insertions(+), 244 deletions(-)
 create mode 100644 Documentation/crypto/asymmetric-keys.txt
 create mode 100644 crypto/asymmetric_keys/.gitignore
 create mode 100644 crypto/asymmetric_keys/Kconfig
 create mode 100644 crypto/asymmetric_keys/Makefile
 create mode 100644 crypto/asymmetric_keys/asymmetric_keys.h
 create mode 100644 crypto/asymmetric_keys/asymmetric_type.c
 create mode 100644 crypto/asymmetric_keys/public_key.c
 create mode 100644 crypto/asymmetric_keys/public_key.h
 create mode 100644 crypto/asymmetric_keys/rsa.c
 create mode 100644 crypto/asymmetric_keys/signature.c
 create mode 100644 crypto/asymmetric_keys/x509.asn1
 create mode 100644 crypto/asymmetric_keys/x509_cert_parser.c
 create mode 100644 crypto/asymmetric_keys/x509_parser.h
 create mode 100644 crypto/asymmetric_keys/x509_public_key.c
 create mode 100644 crypto/asymmetric_keys/x509_rsakey.asn1
 create mode 100644 include/asm-generic/bitops/count_zeros.h
 create mode 100644 include/crypto/public_key.h
 create mode 100644 include/keys/asymmetric-parser.h
 create mode 100644 include/keys/asymmetric-subtype.h
 create mode 100644 include/keys/asymmetric-type.h
 create mode 100644 include/linux/asn1.h
 create mode 100644 include/linux/asn1_ber_bytecode.h
 create mode 100644 include/linux/asn1_decoder.h
 create mode 100644 include/linux/oid_registry.h
 create mode 100644 kernel/modsign_pubkey.c
 create mode 100644 kernel/module-internal.h
 create mode 100644 kernel/module_signing.c
 create mode 100644 lib/asn1_decoder.c
 create mode 100755 lib/build_OID_registry
 create mode 100644 lib/mpi/mpi-cmp.c
 create mode 100644 lib/oid_registry.c
 create mode 100644 scripts/asn1_compiler.c
 create mode 100644 scripts/sign-file
 create mode 100755 scripts/x509keyid
