Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab0FARG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 13:06:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35059 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab0FARGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 13:06:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=ulEJKLgjyI7tMJjacygUt/mOmTV4hiBQn0ukeMi56+FcA2wytTJYWjopGw08sQ/7M+
         U+eWQRQRq13DAceEKrHmTTEw6zxZlT0lbwoHAndTJIy2F2hyw+JQ4Wiig10dstZAP0E6
         oTAgXWgN74bRysd10r0SachxzZ1ocYuyavJW0=
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-fsdevel@vger.kernel.org, linux-ima-user@lists.sourceforge.net
Subject: [PATCH][1/1] fs: wrong type for 'magic' argument in 'simple_fill_super()', fs/libfs.c
Date: Tue, 1 Jun 2010 19:05:56 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.32.12-115.fc12.x86_64; KDE/4.4.3; x86_64; ; )
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2590680.sFqRDMBMql";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201006011906.00880.roberto.sassu@polito.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2590680.sFqRDMBMql
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Description of the issue:

The function 'simple_fill_super()' in the path 'fs/libfs.c' takes the 'magi=
c' argument as int.=20
In the include file 'include/linux/fs.h' the 's_magic' field of the 'super_=
block' structure is
declared as unsigned long.
This causes a misbehaviour in the 'Integrity Measurement Architecture' secu=
rity module,=20
since the 's_magic' field is used as criteria to determine if the inode mus=
t be measured.

This patch applies to the mainline kernel repository.


=46rom a9f6d9bc7b2259ac025977f4b28a8b90784caf62 Mon Sep 17 00:00:00 2001
=46rom: Roberto Sassu <roberto.sassu@polito.it>
Date: Tue, 1 Jun 2010 18:28:13 +0200
Subject: [PATCH] BUG: wrong type for magic argument in simple_fill_super(),=
 fs/libfs.c


Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
=2D--
 fs/libfs.c         |    2 +-
 include/linux/fs.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 09e1016..7d966e8 100644
=2D-- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -489,7 +489,7 @@ int simple_write_end(struct file *file, struct address_=
space *mapping,
  * unique inode values later for this filesystem, then you must take care
  * to pass it an appropriate max_reserved value to avoid collisions.
  */
=2Dint simple_fill_super(struct super_block *s, int magic, struct tree_desc=
r *files)
+int simple_fill_super(struct super_block *s, unsigned long magic, struct t=
ree_descr *files)
 {
  	struct inode *inode;
        struct dentry *root;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3428393..471e1ff 100644
=2D-- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2388,7 +2388,7 @@ extern const struct file_operations simple_dir_operat=
ions;
 extern const struct inode_operations simple_dir_inode_operations;
 struct tree_descr { char *name; const struct file_operations *ops; int mod=
e; };
 struct dentry *d_alloc_name(struct dentry *, const char *);
=2Dextern int simple_fill_super(struct super_block *, int, struct tree_desc=
r *);
+extern int simple_fill_super(struct super_block *, unsigned long, struct t=
ree_descr *);
 extern int simple_pin_fs(struct file_system_type *, struct vfsmount **moun=
t, int *count);
 extern void simple_release_fs(struct vfsmount **mount, int *count);

=2D-
1.6.6.1

--nextPart2590680.sFqRDMBMql
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGDzCCBgsw
ggTzoAMCAQICAgPBMA0GCSqGSIb3DQEBBQUAMGUxCzAJBgNVBAYTAklUMR4wHAYDVQQKExVQb2xp
dGVjbmljbyBkaSBUb3Jpbm8xNjA0BgNVBAMTLVBvbGl0ZWNuaWNvIGRpIFRvcmlubyBDZXJ0aWZp
Y2F0aW9uIEF1dGhvcml0eTAeFw0wODEyMDUxNjAwMDBaFw0xMDEyMzAxMjAwMDBaMHkxCzAJBgNV
BAYTAklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBkaSBUb3Jpbm8xMTAvBgNVBAsTKERpcGFydGlt
ZW50byBkaSBBdXRvbWF0aWNhIGUgSW5mb3JtYXRpY2ExFzAVBgNVBAMTDlJvYmVydG8gIFNhc3N1
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5L+V4w3Mbm/sUbvfK2Fa00852rwwQWnO
DuaPLgztSxL36xxvtATxM5ffrmr/6YHDFnupb46E0p+C/XgDfL+q6O7k/uaNOZM28pYOmxQGML60
Kz5alayAg9zbHFY+tHtuvThT9Jhg2zHKeHVO07aCxCsciP1L/A2I1E/wYY8ICK5hGVovYJ5JWfgk
QpxPTM54sgip8OncB3dh4GGP5xHdOuY71PIZM8IBvWjKr3C4DVPHTjiupJA1unR7RG86vAAikP/a
Y08/dF5N4HndpKCrSkIegfWzYBxj+NYnWOhgUL2GH/YOplG8w0iwztRx7kiLPayCXUjrUhQPjrnw
djMKYwIDAQABo4ICrzCCAqswgZUGCWCGSAGG+EIBDQSBhxaBhElzc3VlZCB1bmRlciBwb2xpY2ll
czoKIGh0dHA6Ly93d3cuZXVyb3BraS5vcmcvY2Evcm9vdC9jcHMvMS4xLwogaHR0cDovL3d3dy5l
dXJvcGtpLm9yZy9jYS9pdC9jcHMvMS4xLwogaHR0cDovL2NhLnBvbGl0by5pdC9jcHMvMi4xLzAR
BglghkgBhvhCAQEEBAMCALAwYwYIKwYBBQUHAQEEVzBVMCgGCCsGAQUFBzABhhxodHRwOi8vb2Nz
cC5ldXJvcGtpLm9yZzo4MDI2MCkGCCsGAQUFBzAChh1odHRwOi8vd3d3LmV1cm9wa2kub3JnL2Nh
L2l0LzAyBgNVHR8EKzApMCegJaAjhiFodHRwOi8vY2EucG9saXRvLml0L2NybDAzL2NybC5kZXIw
DAYDVR0TAQH/BAIwADA6BgNVHREEMzAxgRdyb2JlcnRvLnNhc3N1QHBvbGl0by5pdKAWBgorBgEE
AZViAgEBoAgWBjAyMTMwNTCBzQYDVR0gBIHFMIHCMEMGCisGAQQBqQcBAQEwNTAzBggrBgEFBQcC
ARYnaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9yb290L2Nwcy8xLjEvMEEGCisGAQQBqQcCAQEw
MzAxBggrBgEFBQcCARYlaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9pdC9jcHMvMS4xLzA4Bgor
BgEEAZViAQIBMCowKAYIKwYBBQUHAgEWHGh0dHA6Ly9jYS5wb2xpdG8uaXQvY3BzLzIuMS8wCwYD
VR0PBAQDAgTwMB0GA1UdDgQWBBQ/7fsOlEvqvkE2OCyAWMjwwe8ZNzAfBgNVHSMEGDAWgBQJ/SUZ
b+NofIJrNXO8KAC+LDw6ODANBgkqhkiG9w0BAQUFAAOCAQEANGPQ5YyCXMtdM+4o0P2AxMd3WJE/
NE0jVOJgU39YjK5reY16/rnAqfflXFtsxXqTvO7HF0Luj6JhEt6lU6enD3QB/9KIlFz1AjiuTy3N
KvnEgju8jR8+9yWuNIzKZcK/AqttjCsp7QWEGdJnwCh7BegcNDx/riF4shTyYta7CjX5uurSklQf
lD7r1YAYPTeWf6UWGTYqq9W/zIAPbU/J2tLtSTZksTuXv/4FNAFjxmOk1FnjgLr6juWi7bM3qWRa
1UcHBQ1V1+7fCRJN20Kb/LFHxdSUXJmQsd+FjX1VbiW7FvspngaI8oMRF1DAFvSSNrh6pI4GQA9Z
n1jzOm/hsDGCAhwwggIYAgEBMGswZTELMAkGA1UEBhMCSVQxHjAcBgNVBAoTFVBvbGl0ZWNuaWNv
IGRpIFRvcmlubzE2MDQGA1UEAxMtUG9saXRlY25pY28gZGkgVG9yaW5vIENlcnRpZmljYXRpb24g
QXV0aG9yaXR5AgIDwTAJBgUrDgMCGgUAoIGHMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTEwMDYwMTE3MDU1N1owIwYJKoZIhvcNAQkEMRYEFA+no9dJcm3aXLAGPen9
WpKWw5OsMCgGCSqGSIb3DQEJDzEbMBkwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA0GCSqGSIb3
DQEBAQUABIIBACOqbQUo8R3zuXETFJa2R63Y5V3+yvKNJbxT5qRLzfLmMDumT/ptRx3cszhxy4lG
/G+pAl69EAaoa8uLq9Mo209Gwc0rhLpPGimPfO2dA1pS0v8ksT1cCGWs2eXslKYie2//K3WUuw6b
dqsTwQ6awutQu5V6BjjPg0M5HGwyDl0kO0qNO5TBi4pgKgOpHNKI2iClwjR96PJfh+ivVkwP+9+V
A1tsEEHKe1Eus+/ZYnsh+eUWFUI/F3iWTF4qrTUQdIvIxipdN8W/1OqKhd+BfjZx2cFXtPM78egP
KSosLHxUmBVU43M3Q+AE3iUR8ZmcCSrdDgIcRxpKkLJ75ydKPcEAAAAAAAA=

--nextPart2590680.sFqRDMBMql--
