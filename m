Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab0F3Pe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:34:56 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41585 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab0F3Pez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:34:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=S/ySCaWIqZyMzwKUzKkmQPrqfYrIQ9LPvPL7pcwHkI5jK/E4vZk1spQJ43RNTcZ0t0
         DNmMtht9yljkueYepC5cJF5CZ36+6WedD1nhhQXe5PtJB8sSdVnTbUhKTljEsPKA1UeN
         1p4plLwul/+ZbMkZSeoHDJY2W6h6ar0u1+n3U=
MIME-Version: 1.0
In-Reply-To: <20100630151449.GA1748@arch.tripp.de>
References: <alpine.DEB.2.00.1006300202190.30052@skynet.skynet.ie>
	<20100630065440.GA1736@arch.tripp.de>
	<20100630073145.GA1722@arch.tripp.de>
	<AANLkTimr33Bar73xO9IjDWhPWidZr0HB663oRU8fDCyt@mail.gmail.com>
	<20100630145859.GC1722@arch.tripp.de>
	<AANLkTil58kym4SgjMDv8RCXWkoUHKVYfTpT775uufoDJ@mail.gmail.com>
	<20100630151449.GA1748@arch.tripp.de>
Date: Wed, 30 Jun 2010 11:34:53 -0400
Message-ID: <AANLkTikHDUSpYrx4yCLFPNuTw4FFyLcf2kvJ2gVWicZA@mail.gmail.com>
Subject: Re: [git pull] drm fixes + agp + one fb patch (bisected)
From: Alex Deucher <alexdeucher@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: multipart/mixed; boundary=000e0cdfc5be67ffbb048a41185f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cdfc5be67ffbb048a41185f
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 30, 2010 at 11:14 AM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On Wed, Jun 30, 2010 at 11:03:33AM -0400, Alex Deucher wrote:
>> On Wed, Jun 30, 2010 at 10:58 AM, Markus Trippelsdorf
>> <markus@trippelsdorf.de> wrote:
>> > On Wed, Jun 30, 2010 at 10:49:41AM -0400, Alex Deucher wrote:
>> >> On Wed, Jun 30, 2010 at 3:31 AM, Markus Trippelsdorf
>> >> <markus@trippelsdorf.de> wrote:
>> >> > On Wed, Jun 30, 2010 at 08:54:40AM +0200, Markus Trippelsdorf wrote=
:
>> >> >> On Wed, Jun 30, 2010 at 02:03:04AM +0100, Dave Airlie wrote:
>> >> >> >
>> >> >> > one fb layer fix in a flag I introduced,
>> >> >> >
>> >> >> > the rest are drm fixes:
>> >> >> > radeon fixes: the larger ones in the command stream checker for =
older cards,
>> >> >> > which was causing a lot of userspace apps to fail. Also some pow=
erpc server fixes.
>> >> >> > along with some updates to the evergreen command stream checker =
introduced in -rc1.
>> >> >> >
>> >> >> > agp: fix issue with warning on memory allocation + fallback to v=
malloc.
>> >> >> > ttm: fix regression introduced in -rc1 in memory allocation path=
s.
>> >> >> >
>> >> >> > The following changes since commit 7e27d6e778cd87b6f2415515d7127=
eba53fe5d02:
>> >> >> >
>> >> >> > =A0 Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)
>> >> >> >
>> >> >>
>> >> >> I've tested these patches and they break my setup (RS780). On rebo=
ot, the
>> >> >> monitor goes straight to powersaving mode and no framebuffer is sh=
own.
>> >> >
>> >> > This is the result of the bisection:
>> >> >
>> >> > 07d4190327b02ab3aaad25a2d168f79d92e8f8c2 is the first bad commit
>> >> > commit 07d4190327b02ab3aaad25a2d168f79d92e8f8c2
>> >> > Author: Alex Deucher <alexdeucher@gmail.com>
>> >> > Date: =A0 Sat Jun 12 11:50:13 2010 -0400
>> >> >
>> >> > =A0 =A0drm/radeon/kms: fix bandwidth calculation when sideport is p=
resent
>> >> >
>> >> > =A0 =A0Fixes fdo bug 27529:
>> >> > =A0 =A0https://bugs.freedesktop.org/show_bug.cgi?id=3D27529
>> >> >
>> >> > =A0 =A0Reported-by: steckdenis@yahoo.fr
>> >> > =A0 =A0Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
>> >> > =A0 =A0Cc: stable <stable@kernel.org>
>> >> > =A0 =A0Signed-off-by: Dave Airlie <airlied@redhat.com>
>> >>
>> >> Markus, can you send me a copy of your vbios? as root:
>> >> cd /sys/bus/pci/devices/<pci bus id of video card>
>> >> echo 1 > rom
>> >> cat rom ? /tmp/vbio.rom
>> >> echo 0 > rom
>> >
>> > Attached.
>> >
>> >>
>> >> Also, when you say "on reboot" do you mean the card comes up ok
>> >> initially with the new kernel and then fails after a reboot, or fails
>> >> directly after booting the new kernel? =A0Also, is there an oops or
>> >> anything like that in dmesg?
>> >
>> > It fails directly after booting the new kernel. There is no oops or
>> > anything like it in dmesg, because the kernel fails so early that it
>> > could not log anything.
>>
>> Is the machine still pingable? =A0Can you ssh in? or is it completely de=
ad?
>
> I don't think so. There is no disk activivy after the hang, but maybe
> the kernel displays an oops, which I just can't see.

The attached patch should fix the issue.

Alex

--000e0cdfc5be67ffbb048a41185f
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-igp-fix-possible-divide-by-0-in-bandw.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-igp-fix-possible-divide-by-0-in-bandw.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gb2buc6u0

RnJvbSAzYjJmZWYzOWUwMTcyMDk5YTc2NmNlNTM2NDg5ZDAwOGI0NDRjNDhiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdtYWlsLmNvbT4K
RGF0ZTogV2VkLCAzMCBKdW4gMjAxMCAxMTozMToxMyAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIGRy
bS9yYWRlb24va21zL2lncDogZml4IHBvc3NpYmxlIGRpdmlkZSBieSAwIGluIGJhbmR3aWR0aCBj
b2RlCgpTb21lIElHUCBzeXN0ZW1zIHNwZWNpZnkgdGhlIHN5c3RlbSBtZW1vcnkgY2xvY2sgaW4g
dGhlIEZpcm13YXJlCnRhYmxlIHJhdGhlciB0aGFuIHRoZSBJR1AgaW5mbyB0YWJsZS4gIENoZWNr
IGJvdGggYW5kIG1ha2Ugc3VyZQp3ZSBoYXZlIGEgdmFsdWUgc3lzdGVtIG1lbW9yeSBjbG9jayB2
YWx1ZS4KClNpZ25lZC1vZmYtYnk6IEFsZXggRGV1Y2hlciA8YWxleGRldWNoZXJAZ21haWwuY29t
PgotLS0KIGRyaXZlcnMvZ3B1L2RybS9yYWRlb24vcnM2OTAuYyB8ICAgMzUgKysrKysrKysrKysr
KysrKysrKy0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygr
KSwgMTYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9y
czY5MC5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yczY5MC5jCmluZGV4IDY0Yjk0YTguLmY0
ZjBhNjEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcnM2OTAuYworKysgYi9k
cml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JzNjkwLmMKQEAgLTc5LDcgKzc5LDEzIEBAIHZvaWQgcnM2
OTBfcG1faW5mbyhzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikKIAkJCXRtcC5mdWxsID0gZGZp
eGVkX2NvbnN0KDEwMCk7CiAJCQlyZGV2LT5wbS5pZ3Bfc2lkZXBvcnRfbWNsay5mdWxsID0gZGZp
eGVkX2NvbnN0KGluZm8tPmluZm8udWxCb290VXBNZW1vcnlDbG9jayk7CiAJCQlyZGV2LT5wbS5p
Z3Bfc2lkZXBvcnRfbWNsay5mdWxsID0gZGZpeGVkX2RpdihyZGV2LT5wbS5pZ3Bfc2lkZXBvcnRf
bWNsaywgdG1wKTsKLQkJCXJkZXYtPnBtLmlncF9zeXN0ZW1fbWNsay5mdWxsID0gZGZpeGVkX2Nv
bnN0KGxlMTZfdG9fY3B1KGluZm8tPmluZm8udXNLOE1lbW9yeUNsb2NrKSk7CisJCQlpZiAoaW5m
by0+aW5mby51c0s4TWVtb3J5Q2xvY2spCisJCQkJcmRldi0+cG0uaWdwX3N5c3RlbV9tY2xrLmZ1
bGwgPSBkZml4ZWRfY29uc3QobGUxNl90b19jcHUoaW5mby0+aW5mby51c0s4TWVtb3J5Q2xvY2sp
KTsKKwkJCWVsc2UgaWYgKHJkZXYtPmNsb2NrLmRlZmF1bHRfbWNsaykgeworCQkJCXJkZXYtPnBt
LmlncF9zeXN0ZW1fbWNsay5mdWxsID0gZGZpeGVkX2NvbnN0KHJkZXYtPmNsb2NrLmRlZmF1bHRf
bWNsayk7CisJCQkJcmRldi0+cG0uaWdwX3N5c3RlbV9tY2xrLmZ1bGwgPSBkZml4ZWRfZGl2KHJk
ZXYtPnBtLmlncF9zeXN0ZW1fbWNsaywgdG1wKTsKKwkJCX0gZWxzZQorCQkJCXJkZXYtPnBtLmln
cF9zeXN0ZW1fbWNsay5mdWxsID0gZGZpeGVkX2NvbnN0KDQwMCk7CiAJCQlyZGV2LT5wbS5pZ3Bf
aHRfbGlua19jbGsuZnVsbCA9IGRmaXhlZF9jb25zdChsZTE2X3RvX2NwdShpbmZvLT5pbmZvLnVz
RlNCQ2xvY2spKTsKIAkJCXJkZXYtPnBtLmlncF9odF9saW5rX3dpZHRoLmZ1bGwgPSBkZml4ZWRf
Y29uc3QoaW5mby0+aW5mby51Y0hUTGlua1dpZHRoKTsKIAkJCWJyZWFrOwpAQCAtODcsMzQgKzkz
LDMxIEBAIHZvaWQgcnM2OTBfcG1faW5mbyhzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikKIAkJ
CXRtcC5mdWxsID0gZGZpeGVkX2NvbnN0KDEwMCk7CiAJCQlyZGV2LT5wbS5pZ3Bfc2lkZXBvcnRf
bWNsay5mdWxsID0gZGZpeGVkX2NvbnN0KGluZm8tPmluZm9fdjIudWxCb290VXBTaWRlUG9ydENs
b2NrKTsKIAkJCXJkZXYtPnBtLmlncF9zaWRlcG9ydF9tY2xrLmZ1bGwgPSBkZml4ZWRfZGl2KHJk
ZXYtPnBtLmlncF9zaWRlcG9ydF9tY2xrLCB0bXApOwotCQkJcmRldi0+cG0uaWdwX3N5c3RlbV9t
Y2xrLmZ1bGwgPSBkZml4ZWRfY29uc3QoaW5mby0+aW5mb192Mi51bEJvb3RVcFVNQUNsb2NrKTsK
KwkJCWlmIChpbmZvLT5pbmZvX3YyLnVsQm9vdFVwVU1BQ2xvY2spCisJCQkJcmRldi0+cG0uaWdw
X3N5c3RlbV9tY2xrLmZ1bGwgPSBkZml4ZWRfY29uc3QoaW5mby0+aW5mb192Mi51bEJvb3RVcFVN
QUNsb2NrKTsKKwkJCWVsc2UgaWYgKHJkZXYtPmNsb2NrLmRlZmF1bHRfbWNsaykKKwkJCQlyZGV2
LT5wbS5pZ3Bfc3lzdGVtX21jbGsuZnVsbCA9IGRmaXhlZF9jb25zdChyZGV2LT5jbG9jay5kZWZh
dWx0X21jbGspOworCQkJZWxzZQorCQkJCXJkZXYtPnBtLmlncF9zeXN0ZW1fbWNsay5mdWxsID0g
ZGZpeGVkX2NvbnN0KDY2NzAwKTsKIAkJCXJkZXYtPnBtLmlncF9zeXN0ZW1fbWNsay5mdWxsID0g
ZGZpeGVkX2RpdihyZGV2LT5wbS5pZ3Bfc3lzdGVtX21jbGssIHRtcCk7CiAJCQlyZGV2LT5wbS5p
Z3BfaHRfbGlua19jbGsuZnVsbCA9IGRmaXhlZF9jb25zdChpbmZvLT5pbmZvX3YyLnVsSFRMaW5r
RnJlcSk7CiAJCQlyZGV2LT5wbS5pZ3BfaHRfbGlua19jbGsuZnVsbCA9IGRmaXhlZF9kaXYocmRl
di0+cG0uaWdwX2h0X2xpbmtfY2xrLCB0bXApOwogCQkJcmRldi0+cG0uaWdwX2h0X2xpbmtfd2lk
dGguZnVsbCA9IGRmaXhlZF9jb25zdChsZTE2X3RvX2NwdShpbmZvLT5pbmZvX3YyLnVzTWluSFRM
aW5rV2lkdGgpKTsKIAkJCWJyZWFrOwogCQlkZWZhdWx0OgotCQkJdG1wLmZ1bGwgPSBkZml4ZWRf
Y29uc3QoMTAwKTsKIAkJCS8qIFdlIGFzc3VtZSB0aGUgc2xvd2VyIHBvc3NpYmxlIGNsb2NrIGll
IHdvcnN0IGNhc2UgKi8KLQkJCS8qIEREUiAzMzNNaHogKi8KLQkJCXJkZXYtPnBtLmlncF9zaWRl
cG9ydF9tY2xrLmZ1bGwgPSBkZml4ZWRfY29uc3QoMzMzKTsKLQkJCS8qIEZJWE1FOiBzeXN0ZW0g
Y2xvY2sgPyAqLwotCQkJcmRldi0+cG0uaWdwX3N5c3RlbV9tY2xrLmZ1bGwgPSBkZml4ZWRfY29u
c3QoMTAwKTsKLQkJCXJkZXYtPnBtLmlncF9zeXN0ZW1fbWNsay5mdWxsID0gZGZpeGVkX2Rpdihy
ZGV2LT5wbS5pZ3Bfc3lzdGVtX21jbGssIHRtcCk7Ci0JCQlyZGV2LT5wbS5pZ3BfaHRfbGlua19j
bGsuZnVsbCA9IGRmaXhlZF9jb25zdCgyMDApOworCQkJcmRldi0+cG0uaWdwX3NpZGVwb3J0X21j
bGsuZnVsbCA9IGRmaXhlZF9jb25zdCgyMDApOworCQkJcmRldi0+cG0uaWdwX3N5c3RlbV9tY2xr
LmZ1bGwgPSBkZml4ZWRfY29uc3QoMjAwKTsKKwkJCXJkZXYtPnBtLmlncF9odF9saW5rX2Nsay5m
dWxsID0gZGZpeGVkX2NvbnN0KDEwMDApOwogCQkJcmRldi0+cG0uaWdwX2h0X2xpbmtfd2lkdGgu
ZnVsbCA9IGRmaXhlZF9jb25zdCg4KTsKIAkJCURSTV9FUlJPUigiTm8gaW50ZWdyYXRlZCBzeXN0
ZW0gaW5mbyBmb3IgeW91ciBHUFUsIHVzaW5nIHNhZmUgZGVmYXVsdFxuIik7CiAJCQlicmVhazsK
IAkJfQogCX0gZWxzZSB7Ci0JCXRtcC5mdWxsID0gZGZpeGVkX2NvbnN0KDEwMCk7CiAJCS8qIFdl
IGFzc3VtZSB0aGUgc2xvd2VyIHBvc3NpYmxlIGNsb2NrIGllIHdvcnN0IGNhc2UgKi8KLQkJLyog
RERSIDMzM01oeiAqLwotCQlyZGV2LT5wbS5pZ3Bfc2lkZXBvcnRfbWNsay5mdWxsID0gZGZpeGVk
X2NvbnN0KDMzMyk7Ci0JCS8qIEZJWE1FOiBzeXN0ZW0gY2xvY2sgPyAqLwotCQlyZGV2LT5wbS5p
Z3Bfc3lzdGVtX21jbGsuZnVsbCA9IGRmaXhlZF9jb25zdCgxMDApOwotCQlyZGV2LT5wbS5pZ3Bf
c3lzdGVtX21jbGsuZnVsbCA9IGRmaXhlZF9kaXYocmRldi0+cG0uaWdwX3N5c3RlbV9tY2xrLCB0
bXApOwotCQlyZGV2LT5wbS5pZ3BfaHRfbGlua19jbGsuZnVsbCA9IGRmaXhlZF9jb25zdCgyMDAp
OworCQlyZGV2LT5wbS5pZ3Bfc2lkZXBvcnRfbWNsay5mdWxsID0gZGZpeGVkX2NvbnN0KDIwMCk7
CisJCXJkZXYtPnBtLmlncF9zeXN0ZW1fbWNsay5mdWxsID0gZGZpeGVkX2NvbnN0KDIwMCk7CisJ
CXJkZXYtPnBtLmlncF9odF9saW5rX2Nsay5mdWxsID0gZGZpeGVkX2NvbnN0KDEwMDApOwogCQly
ZGV2LT5wbS5pZ3BfaHRfbGlua193aWR0aC5mdWxsID0gZGZpeGVkX2NvbnN0KDgpOwogCQlEUk1f
RVJST1IoIk5vIGludGVncmF0ZWQgc3lzdGVtIGluZm8gZm9yIHlvdXIgR1BVLCB1c2luZyBzYWZl
IGRlZmF1bHRcbiIpOwogCX0KLS0gCjEuNy4wLjEKCg==
--000e0cdfc5be67ffbb048a41185f--
