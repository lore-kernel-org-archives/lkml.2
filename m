Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab1D2No3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 09:44:29 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:46484 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755785Ab1D2No1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 09:44:27 -0400
X-Sasl-enc: jVYTBNXMupPmYzOt3whEBaYY4eJPYR16dNRb56VdQdAu 1304084666
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, jmorris@namei.org, zohar@linux.vnet.ibm.com,
        safford@watson.ibm.com, tyhicks@linux.vnet.ibm.com,
        kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        casey@schaufler-ca.com, eparis@redhat.com, sds@tycho.nsa.gov,
        selinux@tycho.nsa.gov, viro@zeniv.linux.org.uk,
        john.johansen@canonical.com, apparmor@lists.ubuntu.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH 0/4] eCryptfs credentials patches
Date: Fri, 29 Apr 2011 15:41:48 +0200
Message-Id: <1304084515-22132-1-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----2B99CDD6946F56D28DFD52FD6EC1B1C3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------2B99CDD6946F56D28DFD52FD6EC1B1C3

This patch set modifies the credentials presented by eCryptfs to open
inodes in the lower filesystem. These credentials are initially obtained
through the function prepare_kernel_cred() and may be overridden in order
to identify or restrict actions performed by a specific eCryptfs
filesystem.

More details about how to manage the eCryptfs credentials and how to
measure eCryptfs files with IMA can be found in the file:

'Documentation/filesystems/ecryptfs-security.txt'

Roberto Sassu


Roberto Sassu (4):
  fs: preserve S_IMA inode flag in fsstack_copy_attr_all()
  eCryptfs: introduce per-filesystem credentials
  eCryptfs: override prepared credentials
  eCryptfs: added ima_file_check() call to ecryptfs_init_lower_file()

 Documentation/filesystems/ecryptfs-security.txt |   98 +++++++++++
 fs/ecryptfs/Makefile                            |    2 +-
 fs/ecryptfs/crypto.c                            |    1 +
 fs/ecryptfs/ecryptfs_kernel.h                   |   21 +---
 fs/ecryptfs/kthread.c                           |  197 -----------------------
 fs/ecryptfs/main.c                              |   76 ++++++---
 fs/stack.c                                      |    2 +-
 7 files changed, 155 insertions(+), 242 deletions(-)
 create mode 100644 Documentation/filesystems/ecryptfs-security.txt
 delete mode 100644 fs/ecryptfs/kthread.c

-- 
1.7.4.4


------2B99CDD6946F56D28DFD52FD6EC1B1C3
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIIICQYJKoZIhvcNAQcCoIIH+jCCB/YCAQExCzAJBgUrDgMCGgUAMAsGCSqGSIb3
DQEHAaCCBWQwggVgMIIESKADAgECAgICuzANBgkqhkiG9w0BAQUFADBlMQswCQYD
VQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTYwNAYDVQQD
Ey1Qb2xpdGVjbmljbyBkaSBUb3Jpbm8gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkw
HhcNMTAxMjIwMTExOTU0WhcNMTUxMjMxMjM1OTU5WjBfMQswCQYDVQQGEwJJVDEe
MBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMRcwFQYDVQQDEw5Sb2JlcnRv
ICBTYXNzdTEXMBUGCgmSJomT8ixkAQETB2QwMjEzMDUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDS6p4SaJdmmJHJu9On9ZohhBFE2GgYiY7YtRnhhQJA
NfOtHEhSbpUMaSOfq/Pna6ipR5nAFrlM8cOGcSHZdxrPcgzeJU7F2v1fl2ThvFOc
TIkcC1aAJGQUuCaCXDlQt+KFecJWTrRZnalMHZueO+J6cgHcvR1CQz5e88dSzo3Q
XZy0w/hxGL9Ht9velqsl48ohBk2rs/svAOCp6GfqT1Yxwx1p87d3ViTrmuZB4/X+
da39nJqmo6AZ/y3Zg+r91BgNcfsHVqFT0JTcG6qRIaeqTtqVYpYl+rH1rZzYCakD
yQyys66sBvaXyaiMr0M+SpyH+LaGz5bDn5Odq16FYEq7AgMBAAGjggIeMIICGjAO
BgNVHQ8BAf8EBAMCA/gwJwYDVR0lBCAwHgYIKwYBBQUHAwIGCCsGAQUFBwMDBggr
BgEFBQcDBDAiBgNVHREEGzAZgRdyb2JlcnRvLnNhc3N1QHBvbGl0by5pdDAMBgNV
HRMBAf8EAjAAMB0GA1UdDgQWBBQgKbXSXn+j769x0tsZQ9pSOzIIdDAfBgNVHSME
GDAWgBTNm1tbnup2IcQQaOjSLTfbHy/I5DCBywYDVR0gBIHDMIHAMD4GCisGAQQB
qQcBAQIwMDAuBggrBgEFBQcCARYiaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9j
cHMvMS4yLzBEBgorBgEEAakHAgECMDYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cu
aXRhbHkuZXVyb3BraS5vcmcvY2EvY3BzLzEuMi8wOAYKKwYBBAGVYgECAjAqMCgG
CCsGAQUFBwIBFhxodHRwOi8vY2EucG9saXRvLml0L2Nwcy8yLjIvMGYGCCsGAQUF
BwEBBFowWDAhBggrBgEFBQcwAYYVaHR0cDovL29jc3AucG9saXRvLml0MDMGCCsG
AQUFBzAChidodHRwOi8vY2EucG9saXRvLml0L2NlcnRzL3BvbGl0b19jYS5jZXIw
NwYDVR0fBDAwLjAsoCqgKIYmaHR0cDovL2NhLnBvbGl0by5pdC9jcmwvcG9saXRv
X2NybC5jcmwwDQYJKoZIhvcNAQEFBQADggEBADMe0aHcBJXV6pMJPVVSt1Vazd8Y
LuTLO45Igs9Sb2LuaO6pvcDGvq9dEJnBhP1B+zBAK6WEA1PWb66xC4QXaJnlGZTX
S3XeBivHWm6BNOH2kNeU0HBeGZCV/n5r70TPxkEAcc7u8YY2i6CiMM428YhZK8Zj
oN9D3QNIRf4HZgh0FTbf8eL/XvBbK/oPC+Rew+Qql6M3DHnaS1q2SKUwwO/4VXA4
JsOdatFI68AMXH0Xx9UIcjRi+kvsyvwHlc0Z8AoAtfRMoIl4zFF4Qaowec2UunBK
YlqPpFTtU9czuoEP12A86nqSVsoNok2mZOeYa9IdIjeE2rfdKx6k3YNRg08xggJt
MIICaQIBATBrMGUxCzAJBgNVBAYTAklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBk
aSBUb3Jpbm8xNjA0BgNVBAMTLVBvbGl0ZWNuaWNvIGRpIFRvcmlubyBDZXJ0aWZp
Y2F0aW9uIEF1dGhvcml0eQICArswCQYFKw4DAhoFAKCB2DAYBgkqhkiG9w0BCQMx
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTA0MjkxMzQxNTVaMCMGCSqG
SIb3DQEJBDEWBBSiaZPHMAKNwK7nsMq7w6qBOZe2DTB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQBNLJ+MPDT+vaIVy7A0gYvOloQT
W5omqF56yl0BsVKM2pjHDg4TamgbAcAP1xGRwNXjo7Ns36LD1bOrgzWUQBsl5K/F
xzxHPi0wNoVqE9vpAhiu9T4s15AdQQEsOgBUzMUSZxY1lXEYzwmB0bjXwDyaDE6E
tz1oSdB9r10SYNv6g7n+OFvG7udg1y8SCQtHsNao0u2DgqAh3DLm5PefVb2+a7kb
7NrLPWb0br+7HbnxJOrGcH0BebIpHoGxDBK63pAiX5oAYAumTUPhtVik0TW4FcpQ
h+Ma0JB9XBNFXzE3xPSVJGEIiyGLy0gFpZxyXUlwkZf8g/mM3BYEPja1u553

------2B99CDD6946F56D28DFD52FD6EC1B1C3--


