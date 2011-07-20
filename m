Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab1GTT2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:28:32 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54179 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1GTT2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:28:30 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUVbeLU+zCAC+8wduizn6h5FUE2qzNr0bg9t3yWNbv_6Ng@mail.gmail.com>
References: <CA+icZUVbeLU+zCAC+8wduizn6h5FUE2qzNr0bg9t3yWNbv_6Ng@mail.gmail.com>
Date: Wed, 20 Jul 2011 21:28:29 +0200
Message-ID: <CA+icZUXf1_qWF8GdQyCVxzAp-CYgQbH8iod0oBTjhWsSZLi1_g@mail.gmail.com>
Subject: Re: linux-next: Tree for July 20 (overlayfs)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Randy Dunlap <rdunlap@xenotime.net>
Content-Type: multipart/mixed; boundary=0016364ee534b64c0a04a8853c19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364ee534b64c0a04a8853c19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 20, 2011 at 8:48 PM, Sedat Dilek <sedat.dilek@googlemail.com> w=
rote:
> Hi,
>
> I have here a problem with linux-next (next-20110720) and
> overlayfs-v10 (not the latest from GIT).
>
> ### OVERLAYFS
> # Patches from mszeredi/vfs.git#overlayfs.v10 (up to commit
> 00b27467b181a27c808cef0d66860eba5f450b24)
> # "overlay: overlay filesystem documentation"
> # See also <http://lkml.org/lkml/2011/6/1/456>
> # "[PATCH 0/7] overlay filesystem: request for inclusion"
> + overlayfs-v10/overlayfs-v10.patch
>
> Documentation/filesystems/porting says:
>
> [mandatory]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0->permission(), generic_permission() and ->che=
ck_acl() have lost flags
> argument; instead of passing IPERM_FLAG_RCU we add MAY_NOT_BLOCK into mas=
k.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0generic_permission() has also lost the check_a=
cl argument; if you want
> non-NULL to be used for that inode, put it into ->i_op->check_acl.
>
> I checked with other files below fs/ and changed accordingly.
> So, I hope the attached patch is OK (untested, uncompiled)?
>
> What's the status of OverlayFS anyway, will it be merged into v3.1?
>
> Regards,
> - Sedat -
>

I checked again and adapted ovl_permission().

[ fs/namei.c ]
static int acl_permission_check(struct inode *inode, int mask)

Here is a v2, which compiles.

- Sedat -

--0016364ee534b64c0a04a8853c19
Content-Type: plain/text; name="fs-overlayfs-inode.c-v2.diff"
Content-Disposition: attachment; filename="fs-overlayfs-inode.c-v2.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqcoogq81

ZGlmZiAtdXByTiBsaW51eC1uZXh0LTIwMTEwNzIwLm9yaWcvZnMvb3ZlcmxheWZzL2lub2RlLmMg
bGludXgtbmV4dC0yMDExMDcyMC9mcy9vdmVybGF5ZnMvaW5vZGUuYwotLS0gbGludXgtbmV4dC0y
MDExMDcyMC5vcmlnL2ZzL292ZXJsYXlmcy9pbm9kZS5jCTIwMTEtMDctMjAgMjE6MTU6NDMuNzY4
OTI3NzM3ICswMjAwCisrKyBsaW51eC1uZXh0LTIwMTEwNzIwL2ZzL292ZXJsYXlmcy9pbm9kZS5j
CTIwMTEtMDctMjAgMjE6MDM6MzIuMDc4MTI2MzM2ICswMjAwCkBAIC00NSw3ICs0NSw3IEBAIHN0
YXRpYyBpbnQgb3ZsX2dldGF0dHIoc3RydWN0IHZmc21vdW50ICoKIAlyZXR1cm4gdmZzX2dldGF0
dHIocmVhbHBhdGgubW50LCByZWFscGF0aC5kZW50cnksIHN0YXQpOwogfQogCi1pbnQgb3ZsX3Bl
cm1pc3Npb24oc3RydWN0IGlub2RlICppbm9kZSwgaW50IG1hc2ssIHVuc2lnbmVkIGludCBmbGFn
cykKK2ludCBvdmxfcGVybWlzc2lvbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBpbnQgbWFzaykKIHsK
IAlzdHJ1Y3Qgb3ZsX2VudHJ5ICpvZTsKIAlzdHJ1Y3QgZGVudHJ5ICphbGlhcyA9IE5VTEw7CkBA
IC01Niw3ICs1Niw3IEBAIGludCBvdmxfcGVybWlzc2lvbihzdHJ1Y3QgaW5vZGUgKmlub2RlLAog
CiAJaWYgKFNfSVNESVIoaW5vZGUtPmlfbW9kZSkpIHsKIAkJb2UgPSBpbm9kZS0+aV9wcml2YXRl
OwotCX0gZWxzZSBpZiAoZmxhZ3MgJiBJUEVSTV9GTEFHX1JDVSkgeworCX0gZWxzZSBpZiAobWFz
ayAmIE1BWV9OT1RfQkxPQ0spIHsKIAkJcmV0dXJuIC1FQ0hJTEQ7CiAJfSBlbHNlIHsKIAkJLyoK
QEAgLTc5LDcgKzc5LDcgQEAgaW50IG92bF9wZXJtaXNzaW9uKHN0cnVjdCBpbm9kZSAqaW5vZGUs
CiAJLyogQ2FyZWZ1bCBpbiBSQ1Ugd2FsayBtb2RlICovCiAJcmVhbGlub2RlID0gQUNDRVNTX09O
Q0UocmVhbGRlbnRyeS0+ZF9pbm9kZSk7CiAJaWYgKCFyZWFsaW5vZGUpIHsKLQkJV0FSTl9PTigh
KGZsYWdzICYgSVBFUk1fRkxBR19SQ1UpKTsKKwkJV0FSTl9PTighKG1hc2sgJiBNQVlfTk9UX0JM
T0NLKSk7CiAJCWVyciA9IC1FTk9FTlQ7CiAJCWdvdG8gb3V0X2RwdXQ7CiAJfQpAQCAtMTA1LDEw
ICsxMDUsOSBAQCBpbnQgb3ZsX3Blcm1pc3Npb24oc3RydWN0IGlub2RlICppbm9kZSwKIAl9CiAK
IAlpZiAocmVhbGlub2RlLT5pX29wLT5wZXJtaXNzaW9uKQotCQllcnIgPSByZWFsaW5vZGUtPmlf
b3AtPnBlcm1pc3Npb24ocmVhbGlub2RlLCBtYXNrLCBmbGFncyk7CisJCWVyciA9IHJlYWxpbm9k
ZS0+aV9vcC0+cGVybWlzc2lvbihyZWFsaW5vZGUsIG1hc2spOwogCWVsc2UKLQkJZXJyID0gZ2Vu
ZXJpY19wZXJtaXNzaW9uKHJlYWxpbm9kZSwgbWFzaywgZmxhZ3MsCi0JCQkJCSByZWFsaW5vZGUt
Pmlfb3AtPmNoZWNrX2FjbCk7CisJCWVyciA9IGdlbmVyaWNfcGVybWlzc2lvbihyZWFsaW5vZGUs
IG1hc2spOwogb3V0X2RwdXQ6CiAJZHB1dChhbGlhcyk7CiAJcmV0dXJuIGVycjsKZGlmZiAtdXBy
TiBsaW51eC1uZXh0LTIwMTEwNzIwLm9yaWcvZnMvb3ZlcmxheWZzL292ZXJsYXlmcy5oIGxpbnV4
LW5leHQtMjAxMTA3MjAvZnMvb3ZlcmxheWZzL292ZXJsYXlmcy5oCi0tLSBsaW51eC1uZXh0LTIw
MTEwNzIwLm9yaWcvZnMvb3ZlcmxheWZzL292ZXJsYXlmcy5oCTIwMTEtMDctMjAgMjE6MTU6NDMu
NzcyOTI3Njg3ICswMjAwCisrKyBsaW51eC1uZXh0LTIwMTEwNzIwL2ZzL292ZXJsYXlmcy9vdmVy
bGF5ZnMuaAkyMDExLTA3LTIwIDIxOjA0OjIyLjM5MzQ5Mzc4NSArMDIwMApAQCAtNDQsNyArNDQs
NyBAQCBpbnQgb3ZsX2NoZWNrX2VtcHR5X2FuZF9jbGVhcihzdHJ1Y3QgZGVuCiAKIC8qIGlub2Rl
LmMgKi8KIGludCBvdmxfc2V0YXR0cihzdHJ1Y3QgZGVudHJ5ICpkZW50cnksIHN0cnVjdCBpYXR0
ciAqYXR0cik7Ci1pbnQgb3ZsX3Blcm1pc3Npb24oc3RydWN0IGlub2RlICppbm9kZSwgaW50IG1h
c2ssIHVuc2lnbmVkIGludCBmbGFncyk7CitpbnQgb3ZsX3Blcm1pc3Npb24oc3RydWN0IGlub2Rl
ICppbm9kZSwgaW50IG1hc2spOwogaW50IG92bF9zZXR4YXR0cihzdHJ1Y3QgZGVudHJ5ICpkZW50
cnksIGNvbnN0IGNoYXIgKm5hbWUsCiAJCSBjb25zdCB2b2lkICp2YWx1ZSwgc2l6ZV90IHNpemUs
IGludCBmbGFncyk7CiBzc2l6ZV90IG92bF9nZXR4YXR0cihzdHJ1Y3QgZGVudHJ5ICpkZW50cnks
IGNvbnN0IGNoYXIgKm5hbWUsCg==
--0016364ee534b64c0a04a8853c19--
