Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab0JVJN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 05:13:27 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65051 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab0JVJN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 05:13:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=Vf/h5Pv6dUvLKxUxlLcRfN9apwZ89ZdCqJMHLeu6yZjigB6/3bkFsx3vmn0Zu0kmWs
         KORdhmo9FnLE6Xl5Pxzi+/BLNkBhaf8cJBJH88TFfAOLbIt1S3vPmXRJG/vfrDyAnZvf
         m2W3XDze714SzsujYJ75Ffa3NPKi6WqCe8j3Q=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 22 Oct 2010 11:13:23 +0200
Message-ID: <AANLkTi=vUA-u20egbpH1Wu4ek-craz7aZUxWmobL8OhD@mail.gmail.com>
Subject: linux-next: next-20101022 broken with unset CONFIG_BKL
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, sfr@canb.auug.org.au
Content-Type: multipart/mixed; boundary=20cf3054ac0ff1a9820493310ded
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3054ac0ff1a9820493310ded
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I am trying to compile latest linux-next with unset CONFIG_BKL.
Yes, one patch is missing from [1] to be able to compile a BKL-free kernel.
(BTW, the patch needs a trivial fix, see v2 attached to this email.)

With next-20101022 the build breaks (sorry for the output in German):

[ build.log ]
...
  LD [M]  fs/ceph/ceph.o
  LD      fs/coda/built-in.o
  CC [M]  fs/coda/psdev.o
  CC [M]  fs/cifs/misc.o
/home/sd/src/linux-2.6/linux-2.6.36/debian/build/source_i386_none/fs/coda/p=
sdev.c:
In function =E2=80=98coda_psdev_write=E2=80=99:
/home/sd/src/linux-2.6/linux-2.6.36/debian/build/source_i386_none/fs/coda/p=
sdev.c:140:
error: implicit declaration of function =E2=80=98lock_kernel=E2=80=99
/home/sd/src/linux-2.6/linux-2.6.36/debian/build/source_i386_none/fs/coda/p=
sdev.c:142:
error: implicit declaration of function =E2=80=98unlock_kernel=E2=80=99
  CC      block/blk-settings.o
make[6]: *** [fs/coda/psdev.o] Fehler 1
make[5]: *** [fs/coda] Fehler 2
make[5]: *** Warte auf noch nicht beendete Prozesse...
...

Just FYI.

Kind Regards,
- Sedat -

[1] https://patchwork.kernel.org/patch/262561/

--20cf3054ac0ff1a9820493310ded
Content-Type: text/plain; charset=US-ASCII; name="fs-remove-BKL-from-FILE_LOCKING-v2.patch"
Content-Disposition: attachment; 
	filename="fs-remove-BKL-from-FILE_LOCKING-v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gfkudr7z0

RnJvbSBwYXRjaHdvcmsgTW9uIE9jdCAxOCAxNzozODoyNiAyMDEwCkNvbnRlbnQtVHlwZTogdGV4
dC9wbGFpbjsgY2hhcnNldD0idXRmLTgiCk1JTUUtVmVyc2lvbjogMS4wCkNvbnRlbnQtVHJhbnNm
ZXItRW5jb2Rpbmc6IDdiaXQKU3ViamVjdDogW3YyXSBSZW1haW5pbmcgQktMIHVzZXJzLCB3aGF0
IHRvIGRvCkRhdGU6IE1vbiwgMTggT2N0IDIwMTAgMTc6Mzg6MjYgLTAwMDAKRnJvbTogQXJuZCBC
ZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4KWC1QYXRjaHdvcmstSWQ6IDI2MjU2MQpNZXNzYWdlLUlk
OiA8MjAxMDEwMTgxOTM4LjI3MDc2LmFybmRAYXJuZGIuZGU+ClRvOiBDaHJpc3RvcGggSGVsbHdp
ZyA8aGNoQGluZnJhZGVhZC5vcmc+CkNjOiBjb2RhbGlzdEBURUxFTUFOTi5jb2RhLmNzLmNtdS5l
ZHUsCglrc3VtbWl0LTIwMTAtZGlzY3Vzc0BsaXN0cy5saW51eC1mb3VuZGF0aW9uLm9yZywKCWF1
dG9mc0BsaW51eC5rZXJuZWwub3JnLCBsaW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5vcmcsCglkcmkt
ZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnLAoJTWlrdWxhcyBQYXRvY2thIDxtaWt1bGFzQGFy
dGF4Lmthcmxpbi5tZmYuY3VuaS5jej4sCglUcm9uZCBNeWtsZWJ1c3QgPFRyb25kLk15a2xlYnVz
dEBuZXRhcHAuY29tPiwKCVBldHIgVmFuZHJvdmVjIDx2YW5kcm92ZUB2Yy5jdnV0LmN6PiwgQW5k
ZXJzIExhcnNlbiA8YWxAYWxhcnNlbi5uZXQ+LCAKCUphbiBLYXJhIDxqYWNrQHN1c2UuY3o+LCBF
dmdlbml5IER1c2hpc3RvdiA8ZHVzaGlzdG92QG1haWwucnU+LAoJSW5nbyBNb2xuYXIgPG1pbmdv
QGVsdGUuaHU+LCBuZXRkZXZAdmdlci5rZXJuZWwub3JnLAoJU2FtdWVsIE9ydGl6IDxzYW11ZWxA
c29ydGl6Lm9yZz4sCglBcm5hbGRvIENhcnZhbGhvIGRlIE1lbG8gPGFjbWVAZ2hvc3Rwcm90b2Nv
bHMubmV0PiwKCWxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcsIGxpbnV4LWZzZGV2ZWxAdmdl
ci5rZXJuZWwub3JnLAoJQW5kcmV3IEhlbmRyeSA8YW5kcmV3LmhlbmRyeUBnbWFpbC5jb20+LAoJ
RGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PiwgSmFuIEhhcmtlcyA8amFoYXJrZXNA
Y3MuY211LmVkdT4sIAoJQnJ5YW4gU2NodW1ha2VyIDxianNjaHVtYUBuZXRhcHAuY29tPgoKCmRp
ZmYgLS1naXQgYS9mcy9LY29uZmlnIGIvZnMvS2NvbmZpZwppbmRleCBjMzg2YTlmLi4yNWNlMmRj
IDEwMDY0NAotLS0gYS9mcy9LY29uZmlnCisrKyBiL2ZzL0tjb25maWcKQEAgLTUwLDcgKzUwLDYg
QEAgZW5kaWYgIyBCTE9DSwogY29uZmlnIEZJTEVfTE9DS0lORwogCWJvb2wgIkVuYWJsZSBQT1NJ
WCBmaWxlIGxvY2tpbmcgQVBJIiBpZiBFTUJFRERFRAogCWRlZmF1bHQgeQotCXNlbGVjdCBCS0wg
IyB3aGlsZSBsb2NrZCBzdGlsbCB1c2VzIGl0LgogCWhlbHAKIAkgIFRoaXMgb3B0aW9uIGVuYWJs
ZXMgc3RhbmRhcmQgZmlsZSBsb2NraW5nIHN1cHBvcnQsIHJlcXVpcmVkCiAgICAgICAgICAgZm9y
IGZpbGVzeXN0ZW1zIGxpa2UgTkZTIGFuZCBmb3IgdGhlIGZsb2NrKCkgc3lzdGVtCmRpZmYgLS1n
aXQgYS9mcy9sb2Nrcy5jIGIvZnMvbG9ja3MuYwppbmRleCA4YjJiNmFkLi4wMmI2ZTBlIDEwMDY0
NAotLS0gYS9mcy9sb2Nrcy5jCisrKyBiL2ZzL2xvY2tzLmMKQEAgLTE0Miw2ICsxNDIsNyBAQCBp
bnQgbGVhc2VfYnJlYWtfdGltZSA9IDQ1OwogCiBzdGF0aWMgTElTVF9IRUFEKGZpbGVfbG9ja19s
aXN0KTsKIHN0YXRpYyBMSVNUX0hFQUQoYmxvY2tlZF9saXN0KTsKK3N0YXRpYyBERUZJTkVfU1BJ
TkxPQ0soZmlsZV9sb2NrX2xvY2spOwogCiAvKgogICogUHJvdGVjdHMgdGhlIHR3byBsaXN0IGhl
YWRzIGFib3ZlLCBwbHVzIHRoZSBpbm9kZS0+aV9mbG9jayBsaXN0CkBAIC0xNDksMTMgKzE1MCwx
MyBAQCBzdGF0aWMgTElTVF9IRUFEKGJsb2NrZWRfbGlzdCk7CiAgKi8KIHZvaWQgbG9ja19mbG9j
a3Modm9pZCkKIHsKLQlsb2NrX2tlcm5lbCgpOworCXNwaW5fbG9jaygmZmlsZV9sb2NrX2xvY2sp
OwogfQogRVhQT1JUX1NZTUJPTF9HUEwobG9ja19mbG9ja3MpOwogCiB2b2lkIHVubG9ja19mbG9j
a3Modm9pZCkKIHsKLQl1bmxvY2tfa2VybmVsKCk7CisJc3Bpbl91bmxvY2soJmZpbGVfbG9ja19s
b2NrKTsKIH0KIEVYUE9SVF9TWU1CT0xfR1BMKHVubG9ja19mbG9ja3MpOwogCg==
--20cf3054ac0ff1a9820493310ded--
