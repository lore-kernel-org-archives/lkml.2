Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab1CXLGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:06:31 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45105 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab1CXLG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:06:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QAS6vaXalLTvrsvjCv8/DGsbywB/7GuCpSSk3swQMKIQyqFgzawFH/kOvRIx6qBI25
         LgOSOtbfoOqRydMIzhCbFJRYtjc7nFGAxsaqR825KddOl/XSfqZUUsxBTu60+afZNz9P
         QLI3X0wBCZRNhowhZLKY0vmU78KQUDILKBrNE=
MIME-Version: 1.0
In-Reply-To: <1300880747.16522.13.camel@thor.local>
References: <alpine.DEB.2.00.1103230417270.29019@skynet.skynet.ie>
	<1300864998.3522.71.camel@thor.local>
	<AANLkTimg4n3Bb=XQYCPLGcCrC5NEQWjfzn-RHu2ZfW=h@mail.gmail.com>
	<1300868532.3522.81.camel@thor.local>
	<AANLkTi=mFKBqF48DwGsQL278grJChCVzw==D7vr49n09@mail.gmail.com>
	<Pine.GSO.4.62.1103230633160.12612@umail>
	<1300880747.16522.13.camel@thor.local>
Date: Thu, 24 Mar 2011 21:06:28 +1000
Message-ID: <AANLkTik=GH8tGMjeKVfsmvX5WeX+4avnYan_nkGcCx20@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>
Cc: Ilija Hadzic <ihadzic@research.bell-labs.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: multipart/mixed; boundary=20cf30549e87132cfe049f387815
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf30549e87132cfe049f387815
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2011/3/23 Michel D=E4nzer <michel@daenzer.net>:
> On Mit, 2011-03-23 at 06:40 -0500, Ilija Hadzic wrote:
>> On Wed, 23 Mar 2011, Dave Airlie wrote:
>>
>> > 2011/3/23 Michel D=E4nzer <michel@daenzer.net>:
>> >> On Mit, 2011-03-23 at 18:16 +1000, Dave Airlie wrote:
>> >>> 2011/3/23 Michel D=E4nzer <michel@daenzer.net>:
>> >>>> On Mit, 2011-03-23 at 04:18 +0000, Dave Airlie wrote:
>> >>>>>
>> >>>>> One radeon, 2 core fixes, and an interface update to allow for > 2=
 crtcs
>> >>>>> in vblank.
>> >>>>
>> >>>> [...]
>> >>>>
>> >>>>> Ilija Hadzic (1):
>> >>>>> =A0 =A0 =A0 drm/kernel: vblank wait on crtc > 1
>> >>>>
>> >>>> This patch was still being debated yesterday, are you deliberately
>> >>>> pushing it regardless? Once it hits mainline, it'll be pretty much =
set
>> >>>> in stone.
>> >>>
>> >>> From what I can see it was the userspace patches being debated, this
>> >>> one seemed fine and the interface looked okay to me.
>> >>
>> >> The author ignored my suggestions to make the patch smaller and simpl=
er,
>> >> more maintainable and more future-proof all at once.
>> >
>> > It was already small and I'm not sure merging the flags made it more
>> > maintainable. Its always
>> > being a slightly painful ioctl, and hopefully any future changes add a
>> > new ioctl esp if we want 64-bit values.
>> >
>> > The only comment I really thought was necessary was changing the CAP
>> > name, but since that isn't
>> > part of the ABI (just the number) we can quickly fix it with a follow-=
up.
>> >
>> > Dave.
>>
>> All of the issues debated yesterday, except one, boil down to renaming a
>> handful on #defines without changing the values nor interface nor behavi=
or
>> of the kernel.
>
> No, one central point is not to leave two holes between
> _DRM_VBLANK_FLAGS_MASK, _DRM_VBLANK_HIGH_CRTC_MASK and
> _DRM_VBLANK_TYPES_MASK .

Okay I've pushed this to my tree before this discussion got on my
radar and I'm just catching up now.

I'll push the following patch to Linus to keep the biggest gap in the
32-bit word for future use, then
we can fixup the userspace patches.

Kernel interfaces aren't considered unchangeable usually on the kernel
is released.

Dave.

--20cf30549e87132cfe049f387815
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-vblank-update-recently-added-vbl-interface-to-be.patch"
Content-Disposition: attachment; 
	filename="0001-drm-vblank-update-recently-added-vbl-interface-to-be.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_glnkjx4k0

RnJvbSAyZmJkNzEzNTRiMTNmMzFjNmE0MDhiNmVlZGNlZmQ0ZWU4ZDFkM2ZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIEFpcmxpZSA8YWlybGllZEByZWRoYXQuY29tPgpEYXRl
OiBUaHUsIDI0IE1hciAyMDExIDIwOjU0OjM1ICsxMDAwClN1YmplY3Q6IFtQQVRDSF0gZHJtL3Zi
bGFuazogdXBkYXRlIHJlY2VudGx5IGFkZGVkIHZibCBpbnRlcmZhY2UgdG8gYmUgbW9yZSBmdXR1
cmUgcHJvb2YuCgpUaGlzIG1ha2VzIHRoZSBpbnRlcmZhY2UgYSBiaXQgY2xlYW5lciBieSBsZWF2
aW5nIGEgc2luZ2xlIGdhcCBpbiB0aGUKdmJsYW5rIGJpdCBzcGFjZSBpbnN0ZWFkIG9mIGNyZWF0
aW5nIHR3byBnYXBzLgoKU3VnZ2VzdGlvbnMgZnJvbSBNaWNoZWwgb24gbWFpbGluZyBsaXN0L2ly
Yy4KClNpZ25lZC1vZmYtYnk6IERhdmUgQWlybGllIDxhaXJsaWVkQHJlZGhhdC5jb20+Ci0tLQog
ZHJpdmVycy9ncHUvZHJtL2RybV9pb2N0bC5jIHwgICAgMiArLQogaW5jbHVkZS9kcm0vZHJtLmgg
ICAgICAgICAgIHwgICAgNyArKysrLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygr
KSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vZHJtX2lvY3Rs
LmMgYi9kcml2ZXJzL2dwdS9kcm0vZHJtX2lvY3RsLmMKaW5kZXggMzYxN2I0Yy4uOTA0ZDdlOSAx
MDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL2RybV9pb2N0bC5jCisrKyBiL2RyaXZlcnMvZ3B1
L2RybS9kcm1faW9jdGwuYwpAQCAtMjgwLDcgKzI4MCw3IEBAIGludCBkcm1fZ2V0Y2FwKHN0cnVj
dCBkcm1fZGV2aWNlICpkZXYsIHZvaWQgKmRhdGEsIHN0cnVjdCBkcm1fZmlsZSAqZmlsZV9wcml2
KQogCQlpZiAoZGV2LT5kcml2ZXItPmR1bWJfY3JlYXRlKQogCQkJcmVxLT52YWx1ZSA9IDE7CiAJ
CWJyZWFrOwotCWNhc2UgRFJNX0NBUF9ISUdIX0NSVEM6CisJY2FzZSBEUk1fQ0FQX1ZCTEFOS19I
SUdIX0NSVEM6CiAJCXJlcS0+dmFsdWUgPSAxOwogCQlicmVhazsKIAlkZWZhdWx0OgpkaWZmIC0t
Z2l0IGEvaW5jbHVkZS9kcm0vZHJtLmggYi9pbmNsdWRlL2RybS9kcm0uaAppbmRleCA5OWNkMDc0
Li40YmUzM2I0IDEwMDY0NAotLS0gYS9pbmNsdWRlL2RybS9kcm0uaAorKysgYi9pbmNsdWRlL2Ry
bS9kcm0uaApAQCAtNDYzLDE0ICs0NjMsMTUgQEAgc3RydWN0IGRybV9pcnFfYnVzaWQgewogZW51
bSBkcm1fdmJsYW5rX3NlcV90eXBlIHsKIAlfRFJNX1ZCTEFOS19BQlNPTFVURSA9IDB4MCwJLyoq
PCBXYWl0IGZvciBzcGVjaWZpYyB2Ymxhbmsgc2VxdWVuY2UgbnVtYmVyICovCiAJX0RSTV9WQkxB
TktfUkVMQVRJVkUgPSAweDEsCS8qKjwgV2FpdCBmb3IgZ2l2ZW4gbnVtYmVyIG9mIHZibGFua3Mg
Ki8KKwkvKiBiaXRzIDEtNiBhcmUgcmVzZXJ2ZWQgZm9yIGhpZ2ggY3J0Y3MgKi8KKwlfRFJNX1ZC
TEFOS19ISUdIX0NSVENfTUFTSyA9IDB4MDAwMDAwM2UsCiAJX0RSTV9WQkxBTktfRVZFTlQgPSAw
eDQwMDAwMDAsICAgLyoqPCBTZW5kIGV2ZW50IGluc3RlYWQgb2YgYmxvY2tpbmcgKi8KIAlfRFJN
X1ZCTEFOS19GTElQID0gMHg4MDAwMDAwLCAgIC8qKjwgU2NoZWR1bGVkIGJ1ZmZlciBzd2FwIHNo
b3VsZCBmbGlwICovCiAJX0RSTV9WQkxBTktfTkVYVE9OTUlTUyA9IDB4MTAwMDAwMDAsCS8qKjwg
SWYgbWlzc2VkLCB3YWl0IGZvciBuZXh0IHZibGFuayAqLwogCV9EUk1fVkJMQU5LX1NFQ09OREFS
WSA9IDB4MjAwMDAwMDAsCS8qKjwgU2Vjb25kYXJ5IGRpc3BsYXkgY29udHJvbGxlciAqLwogCV9E
Uk1fVkJMQU5LX1NJR05BTCA9IDB4NDAwMDAwMDAJLyoqPCBTZW5kIHNpZ25hbCBpbnN0ZWFkIG9m
IGJsb2NraW5nLCB1bnN1cHBvcnRlZCAqLwogfTsKLSNkZWZpbmUgX0RSTV9WQkxBTktfSElHSF9D
UlRDX1NISUZUIDE2Ci0jZGVmaW5lIF9EUk1fVkJMQU5LX0hJR0hfQ1JUQ19NQVNLIDB4MDAxRjAw
MDAKKyNkZWZpbmUgX0RSTV9WQkxBTktfSElHSF9DUlRDX1NISUZUIDEKIAogI2RlZmluZSBfRFJN
X1ZCTEFOS19UWVBFU19NQVNLIChfRFJNX1ZCTEFOS19BQlNPTFVURSB8IF9EUk1fVkJMQU5LX1JF
TEFUSVZFKQogI2RlZmluZSBfRFJNX1ZCTEFOS19GTEFHU19NQVNLIChfRFJNX1ZCTEFOS19FVkVO
VCB8IF9EUk1fVkJMQU5LX1NJR05BTCB8IFwKQEAgLTc1NSw3ICs3NTYsNyBAQCBzdHJ1Y3QgZHJt
X2V2ZW50X3ZibGFuayB7CiB9OwogCiAjZGVmaW5lIERSTV9DQVBfRFVNQl9CVUZGRVIgMHgxCi0j
ZGVmaW5lIERSTV9DQVBfSElHSF9DUlRDIDB4MgorI2RlZmluZSBEUk1fQ0FQX1ZCTEFOS19ISUdI
X0NSVEMgMHgyCiAKIC8qIHR5cGVkZWYgYXJlYSAqLwogI2lmbmRlZiBfX0tFUk5FTF9fCi0tIAox
LjcuMQoK
--20cf30549e87132cfe049f387815--
