Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab3ACNFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:05:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab3ACNFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 08:05:36 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com,
        mjg59@srcf.ucam.org, keescook@chromium.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Subject: Pull "Load keys from signed PE binaries" branch into linux-next
Date: Thu, 03 Jan 2013 13:05:19 +0000
Message-ID: <24937.1357218319@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Stephen,

Could you pull my branch to load module signing keys from signed PE binaries
into linux-next please?

Thanks,
David
---

The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:

  Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-modsign.git devel-pekey

for you to fetch changes up to cb37a0303559a414aa74f43ae3c8c60f01555b7a:

  KEYS: Add a 'trusted' flag and a 'trusted only' flag (2013-01-03 12:06:48 +0000)

----------------------------------------------------------------
(from the branch description for devel-pekey local branch)

clone of "master"
----------------------------------------------------------------
David Howells (23):
      KEYS: Rename public key parameter name arrays
      KEYS: Move the algorithm pointer array from x509 to public_key.c
      KEYS: Store public key algo ID in public_key struct
      KEYS: Split public_key_verify_signature() and make available
      KEYS: Store public key algo ID in public_key_signature struct
      X.509: struct x509_certificate needs struct tm declaring
      X.509: Add bits needed for PKCS#7
      X.509: Embed public_key_signature struct and create filler function
      X.509: Handle certificates that lack an authorityKeyIdentifier field
      X.509: Export certificate parse and free functions
      PKCS#7: Implement a parser [RFC 2315]
      PKCS#7: Digest the data in a signed-data message
      PKCS#7: Find the right key in the PKCS#7 key list and verify the signature
      PKCS#7: Verify internal certificate chain
      Provide PE binary definitions
      pefile: Parse a PE binary to find a key and a signature contained therein
      pefile: Strip the wrapper off of the cert data block
      pefile: Parse the presumed PKCS#7 content of the certificate blob
      pefile: Parse the "Microsoft individual code signing" data blob
      pefile: Digest the PE binary and compare to the PKCS#7 data
      PKCS#7: Find intersection between PKCS#7 message and known, trusted keys
      PEFILE: Load the contained key if we consider the container to be validly signed
      KEYS: Add a 'trusted' flag and a 'trusted only' flag

 crypto/asymmetric_keys/Kconfig            |  19 +-
 crypto/asymmetric_keys/Makefile           |  30 ++
 crypto/asymmetric_keys/mscode.asn1        |  28 ++
 crypto/asymmetric_keys/mscode_parser.c    | 110 +++++++
 crypto/asymmetric_keys/pefile_parser.c    | 480 ++++++++++++++++++++++++++++++
 crypto/asymmetric_keys/pefile_parser.h    |  36 +++
 crypto/asymmetric_keys/pkcs7.asn1         | 127 ++++++++
 crypto/asymmetric_keys/pkcs7_parser.c     | 326 ++++++++++++++++++++
 crypto/asymmetric_keys/pkcs7_parser.h     |  72 +++++
 crypto/asymmetric_keys/pkcs7_trust.c      | 149 ++++++++++
 crypto/asymmetric_keys/pkcs7_verify.c     | 256 ++++++++++++++++
 crypto/asymmetric_keys/public_key.c       |  58 +++-
 crypto/asymmetric_keys/public_key.h       |   6 +
 crypto/asymmetric_keys/x509.asn1          |   2 +-
 crypto/asymmetric_keys/x509_cert_parser.c |  55 +++-
 crypto/asymmetric_keys/x509_parser.h      |  28 +-
 crypto/asymmetric_keys/x509_public_key.c  | 107 +++----
 include/crypto/public_key.h               |   9 +-
 include/linux/key-type.h                  |   1 +
 include/linux/key.h                       |   3 +
 include/linux/oid_registry.h              |   7 +-
 include/linux/pe.h                        | 448 ++++++++++++++++++++++++++++
 kernel/modsign_pubkey.c                   |   5 +-
 kernel/module_signing.c                   |   4 +-
 security/keys/key.c                       |   8 +
 security/keys/keyring.c                   |   4 +
 26 files changed, 2281 insertions(+), 97 deletions(-)
 create mode 100644 crypto/asymmetric_keys/mscode.asn1
 create mode 100644 crypto/asymmetric_keys/mscode_parser.c
 create mode 100644 crypto/asymmetric_keys/pefile_parser.c
 create mode 100644 crypto/asymmetric_keys/pefile_parser.h
 create mode 100644 crypto/asymmetric_keys/pkcs7.asn1
 create mode 100644 crypto/asymmetric_keys/pkcs7_parser.c
 create mode 100644 crypto/asymmetric_keys/pkcs7_parser.h
 create mode 100644 crypto/asymmetric_keys/pkcs7_trust.c
 create mode 100644 crypto/asymmetric_keys/pkcs7_verify.c
 create mode 100644 include/linux/pe.h
