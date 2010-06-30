Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab0F3QEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:04:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42562 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab0F3QEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:04:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ts16BHskd2cdduHlZZwurhntYRouNFmPUKgO/gXoizxRyoxmVEODT24BMc9QiP4Cna
         ciztb5dND+k5NCxvVmviWQxfsWxuWOxc0OQ/5sHgmTaZMvmCvPUEn4fi5Vu31iUeGIPd
         EIXVGuAA3nlsZRlLL+Hp4+TIRqouXlxthtU+g=
MIME-Version: 1.0
In-Reply-To: <20100630155007.GA1696@arch.tripp.de>
References: <alpine.DEB.2.00.1006300202190.30052@skynet.skynet.ie>
	<20100630065440.GA1736@arch.tripp.de>
	<20100630073145.GA1722@arch.tripp.de>
	<AANLkTimr33Bar73xO9IjDWhPWidZr0HB663oRU8fDCyt@mail.gmail.com>
	<20100630145859.GC1722@arch.tripp.de>
	<AANLkTil58kym4SgjMDv8RCXWkoUHKVYfTpT775uufoDJ@mail.gmail.com>
	<20100630151449.GA1748@arch.tripp.de>
	<AANLkTikHDUSpYrx4yCLFPNuTw4FFyLcf2kvJ2gVWicZA@mail.gmail.com>
	<20100630155007.GA1696@arch.tripp.de>
Date: Wed, 30 Jun 2010 12:04:35 -0400
Message-ID: <AANLkTilHe-eWT02LnFqr4C83d123aEtnRA18S1jxwIJC@mail.gmail.com>
Subject: Re: [git pull] drm fixes + agp + one fb patch (bisected)
From: Alex Deucher <alexdeucher@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: multipart/mixed; boundary=0015174c178c963939048a41824b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174c178c963939048a41824b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 30, 2010 at 11:50 AM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On Wed, Jun 30, 2010 at 11:34:53AM -0400, Alex Deucher wrote:
>> On Wed, Jun 30, 2010 at 11:14 AM, Markus Trippelsdorf
>> <markus@trippelsdorf.de> wrote:
>> > On Wed, Jun 30, 2010 at 11:03:33AM -0400, Alex Deucher wrote:
>> >> On Wed, Jun 30, 2010 at 10:58 AM, Markus Trippelsdorf
>> >> <markus@trippelsdorf.de> wrote:
>> >> > On Wed, Jun 30, 2010 at 10:49:41AM -0400, Alex Deucher wrote:
>> >> >> On Wed, Jun 30, 2010 at 3:31 AM, Markus Trippelsdorf
>> >> >> <markus@trippelsdorf.de> wrote:
>> >> >> > On Wed, Jun 30, 2010 at 08:54:40AM +0200, Markus Trippelsdorf wr=
ote:
>> >> >> >> On Wed, Jun 30, 2010 at 02:03:04AM +0100, Dave Airlie wrote:
>> >> >> >> >
>> >> >> >> > one fb layer fix in a flag I introduced,
>> >> >> >> >
>> >> >> >> > the rest are drm fixes:
>> >> >> >> > radeon fixes: the larger ones in the command stream checker f=
or older cards,
>> >> >> >> > which was causing a lot of userspace apps to fail. Also some =
powerpc server fixes.
>> >> >> >> > along with some updates to the evergreen command stream check=
er introduced in -rc1.
>> >> >> >> >
>> >> >> >> > agp: fix issue with warning on memory allocation + fallback t=
o vmalloc.
>> >> >> >> > ttm: fix regression introduced in -rc1 in memory allocation p=
aths.
>> >> >> >> >
>> >> >> >> > The following changes since commit 7e27d6e778cd87b6f2415515d7=
127eba53fe5d02:
>> >> >> >> >
>> >> >> >> > =A0 Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)
>> >> >> >> >
>> >> >> >>
>> >> >> >> I've tested these patches and they break my setup (RS780). On r=
eboot, the
>> >> >> >> monitor goes straight to powersaving mode and no framebuffer is=
 shown.
>> >> >> >
>> >> >> > This is the result of the bisection:
>> >> >> >
>> >> >> > 07d4190327b02ab3aaad25a2d168f79d92e8f8c2 is the first bad commit
>> >> >> > commit 07d4190327b02ab3aaad25a2d168f79d92e8f8c2
>> >> >> > Author: Alex Deucher <alexdeucher@gmail.com>
>> >> >> > Date: =A0 Sat Jun 12 11:50:13 2010 -0400
>> >> >> >
>> >> >> > =A0 =A0drm/radeon/kms: fix bandwidth calculation when sideport i=
s present
>> >> >> >
>> >> >> > =A0 =A0Fixes fdo bug 27529:
>> >> >> > =A0 =A0https://bugs.freedesktop.org/show_bug.cgi?id=3D27529
>> >> >> >
>> >> >> > =A0 =A0Reported-by: steckdenis@yahoo.fr
>> >> >> > =A0 =A0Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
>> >> >> > =A0 =A0Cc: stable <stable@kernel.org>
>> >> >> > =A0 =A0Signed-off-by: Dave Airlie <airlied@redhat.com>
>> >> >>
>> >> >> Markus, can you send me a copy of your vbios? as root:
>> >> >> cd /sys/bus/pci/devices/<pci bus id of video card>
>> >> >> echo 1 > rom
>> >> >> cat rom ? /tmp/vbio.rom
>> >> >> echo 0 > rom
>> >> >
>> >> > Attached.
>> >> >
>> >> >>
>> >> >> Also, when you say "on reboot" do you mean the card comes up ok
>> >> >> initially with the new kernel and then fails after a reboot, or fa=
ils
>> >> >> directly after booting the new kernel? =A0Also, is there an oops o=
r
>> >> >> anything like that in dmesg?
>> >> >
>> >> > It fails directly after booting the new kernel. There is no oops or
>> >> > anything like it in dmesg, because the kernel fails so early that i=
t
>> >> > could not log anything.
>> >>
>> >> Is the machine still pingable? =A0Can you ssh in? or is it completely=
 dead?
>> >
>> > I don't think so. There is no disk activivy after the hang, but maybe
>> > the kernel displays an oops, which I just can't see.
>>
>> The attached patch should fix the issue.
>
> Sorry, but it does not. I've still the same issue with your patch
> applied.

New patch attached.  The rs690_pm_info function wasn't getting called
at all on rs780/rs880 and it needs to be.

Alex

--0015174c178c963939048a41824b
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-igp-fix-possible-divide-by-0-in-bandw.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-igp-fix-possible-divide-by-0-in-bandw.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gb2cwl7n0

RnJvbSBiNzljODI5OWZlYzU3Mjk1M2VmNmQ4NzA5OTAyOTNjMGVlNGNhNjc4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdtYWlsLmNvbT4K
RGF0ZTogV2VkLCAzMCBKdW4gMjAxMCAxMjowMjowMyAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIGRy
bS9yYWRlb24va21zL2lncDogZml4IHBvc3NpYmxlIGRpdmlkZSBieSAwIGluIGJhbmR3aWR0aCBj
b2RlICh2MikKClNvbWUgSUdQIHN5c3RlbXMgc3BlY2lmeSB0aGUgc3lzdGVtIG1lbW9yeSBjbG9j
ayBpbiB0aGUgRmlybXdhcmUKdGFibGUgcmF0aGVyIHRoYW4gdGhlIElHUCBpbmZvIHRhYmxlLiAg
Q2hlY2sgYm90aCBhbmQgbWFrZSBzdXJlCndlIGhhdmUgYSB2YWx1ZSBzeXN0ZW0gbWVtb3J5IGNs
b2NrIHZhbHVlLgoKdjI6IG1ha2Ugc3VyZSByczY5MF9wbV9pbmZvIGlzIGNhbGxlZCBvbiByczc4
MC9yczg4MCBhcyB3ZWxsLgoKU2lnbmVkLW9mZi1ieTogQWxleCBEZXVjaGVyIDxhbGV4ZGV1Y2hl
ckBnbWFpbC5jb20+Ci0tLQogZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yNjAwLmMgICB8ICAgIDQg
KysrLQogZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb24uaCB8ICAgIDEgKwogZHJpdmVycy9n
cHUvZHJtL3JhZGVvbi9yczY5MC5jICB8ICAgMzUgKysrKysrKysrKysrKysrKysrKy0tLS0tLS0t
LS0tLS0tLS0KIDMgZmlsZXMgY2hhbmdlZCwgMjMgaW5zZXJ0aW9ucygrKSwgMTcgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yNjAwLmMgYi9kcml2ZXJz
L2dwdS9kcm0vcmFkZW9uL3I2MDAuYwppbmRleCA3ZjQ4NTkzLi4xZDUwNTdiIDEwMDY0NAotLS0g
YS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I2MDAuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFk
ZW9uL3I2MDAuYwpAQCAtMTIyNCw4ICsxMjI0LDEwIEBAIGludCByNjAwX21jX2luaXQoc3RydWN0
IHJhZGVvbl9kZXZpY2UgKnJkZXYpCiAJcmRldi0+bWMudmlzaWJsZV92cmFtX3NpemUgPSByZGV2
LT5tYy5hcGVyX3NpemU7CiAJcjYwMF92cmFtX2d0dF9sb2NhdGlvbihyZGV2LCAmcmRldi0+bWMp
OwogCi0JaWYgKHJkZXYtPmZsYWdzICYgUkFERU9OX0lTX0lHUCkKKwlpZiAocmRldi0+ZmxhZ3Mg
JiBSQURFT05fSVNfSUdQKSB7CisJCXJzNjkwX3BtX2luZm8ocmRldik7CiAJCXJkZXYtPm1jLmln
cF9zaWRlcG9ydF9lbmFibGVkID0gcmFkZW9uX2F0b21iaW9zX3NpZGVwb3J0X3ByZXNlbnQocmRl
dik7CisJfQogCXJhZGVvbl91cGRhdGVfYmFuZHdpZHRoX2luZm8ocmRldik7CiAJcmV0dXJuIDA7
CiB9CmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbi5oIGIvZHJpdmVy
cy9ncHUvZHJtL3JhZGVvbi9yYWRlb24uaAppbmRleCAzNWYwODAwLi45ZmNkYmE3IDEwMDY0NAot
LS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbi5oCisrKyBiL2RyaXZlcnMvZ3B1L2Ry
bS9yYWRlb24vcmFkZW9uLmgKQEAgLTE3Nyw2ICsxNzcsNyBAQCB2b2lkIHJhZGVvbl9wbV9yZXN1
bWUoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYpOwogdm9pZCByYWRlb25fY29tYmlvc19nZXRf
cG93ZXJfbW9kZXMoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYpOwogdm9pZCByYWRlb25fYXRv
bWJpb3NfZ2V0X3Bvd2VyX21vZGVzKHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2KTsKIHZvaWQg
cmFkZW9uX2F0b21fc2V0X3ZvbHRhZ2Uoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYsIHUxNiBs
ZXZlbCk7Cit2b2lkIHJzNjkwX3BtX2luZm8oc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYpOwog
CiAvKgogICogRmVuY2VzLgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yczY5
MC5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yczY5MC5jCmluZGV4IDY0Yjk0YTguLmY0ZjBh
NjEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcnM2OTAuYworKysgYi9kcml2
ZXJzL2dwdS9kcm0vcmFkZW9uL3JzNjkwLmMKQEAgLTc5LDcgKzc5LDEzIEBAIHZvaWQgcnM2OTBf
cG1faW5mbyhzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikKIAkJCXRtcC5mdWxsID0gZGZpeGVk
X2NvbnN0KDEwMCk7CiAJCQlyZGV2LT5wbS5pZ3Bfc2lkZXBvcnRfbWNsay5mdWxsID0gZGZpeGVk
X2NvbnN0KGluZm8tPmluZm8udWxCb290VXBNZW1vcnlDbG9jayk7CiAJCQlyZGV2LT5wbS5pZ3Bf
c2lkZXBvcnRfbWNsay5mdWxsID0gZGZpeGVkX2RpdihyZGV2LT5wbS5pZ3Bfc2lkZXBvcnRfbWNs
aywgdG1wKTsKLQkJCXJkZXYtPnBtLmlncF9zeXN0ZW1fbWNsay5mdWxsID0gZGZpeGVkX2NvbnN0
KGxlMTZfdG9fY3B1KGluZm8tPmluZm8udXNLOE1lbW9yeUNsb2NrKSk7CisJCQlpZiAoaW5mby0+
aW5mby51c0s4TWVtb3J5Q2xvY2spCisJCQkJcmRldi0+cG0uaWdwX3N5c3RlbV9tY2xrLmZ1bGwg
PSBkZml4ZWRfY29uc3QobGUxNl90b19jcHUoaW5mby0+aW5mby51c0s4TWVtb3J5Q2xvY2spKTsK
KwkJCWVsc2UgaWYgKHJkZXYtPmNsb2NrLmRlZmF1bHRfbWNsaykgeworCQkJCXJkZXYtPnBtLmln
cF9zeXN0ZW1fbWNsay5mdWxsID0gZGZpeGVkX2NvbnN0KHJkZXYtPmNsb2NrLmRlZmF1bHRfbWNs
ayk7CisJCQkJcmRldi0+cG0uaWdwX3N5c3RlbV9tY2xrLmZ1bGwgPSBkZml4ZWRfZGl2KHJkZXYt
PnBtLmlncF9zeXN0ZW1fbWNsaywgdG1wKTsKKwkJCX0gZWxzZQorCQkJCXJkZXYtPnBtLmlncF9z
eXN0ZW1fbWNsay5mdWxsID0gZGZpeGVkX2NvbnN0KDQwMCk7CiAJCQlyZGV2LT5wbS5pZ3BfaHRf
bGlua19jbGsuZnVsbCA9IGRmaXhlZF9jb25zdChsZTE2X3RvX2NwdShpbmZvLT5pbmZvLnVzRlNC
Q2xvY2spKTsKIAkJCXJkZXYtPnBtLmlncF9odF9saW5rX3dpZHRoLmZ1bGwgPSBkZml4ZWRfY29u
c3QoaW5mby0+aW5mby51Y0hUTGlua1dpZHRoKTsKIAkJCWJyZWFrOwpAQCAtODcsMzQgKzkzLDMx
IEBAIHZvaWQgcnM2OTBfcG1faW5mbyhzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikKIAkJCXRt
cC5mdWxsID0gZGZpeGVkX2NvbnN0KDEwMCk7CiAJCQlyZGV2LT5wbS5pZ3Bfc2lkZXBvcnRfbWNs
ay5mdWxsID0gZGZpeGVkX2NvbnN0KGluZm8tPmluZm9fdjIudWxCb290VXBTaWRlUG9ydENsb2Nr
KTsKIAkJCXJkZXYtPnBtLmlncF9zaWRlcG9ydF9tY2xrLmZ1bGwgPSBkZml4ZWRfZGl2KHJkZXYt
PnBtLmlncF9zaWRlcG9ydF9tY2xrLCB0bXApOwotCQkJcmRldi0+cG0uaWdwX3N5c3RlbV9tY2xr
LmZ1bGwgPSBkZml4ZWRfY29uc3QoaW5mby0+aW5mb192Mi51bEJvb3RVcFVNQUNsb2NrKTsKKwkJ
CWlmIChpbmZvLT5pbmZvX3YyLnVsQm9vdFVwVU1BQ2xvY2spCisJCQkJcmRldi0+cG0uaWdwX3N5
c3RlbV9tY2xrLmZ1bGwgPSBkZml4ZWRfY29uc3QoaW5mby0+aW5mb192Mi51bEJvb3RVcFVNQUNs
b2NrKTsKKwkJCWVsc2UgaWYgKHJkZXYtPmNsb2NrLmRlZmF1bHRfbWNsaykKKwkJCQlyZGV2LT5w
bS5pZ3Bfc3lzdGVtX21jbGsuZnVsbCA9IGRmaXhlZF9jb25zdChyZGV2LT5jbG9jay5kZWZhdWx0
X21jbGspOworCQkJZWxzZQorCQkJCXJkZXYtPnBtLmlncF9zeXN0ZW1fbWNsay5mdWxsID0gZGZp
eGVkX2NvbnN0KDY2NzAwKTsKIAkJCXJkZXYtPnBtLmlncF9zeXN0ZW1fbWNsay5mdWxsID0gZGZp
eGVkX2RpdihyZGV2LT5wbS5pZ3Bfc3lzdGVtX21jbGssIHRtcCk7CiAJCQlyZGV2LT5wbS5pZ3Bf
aHRfbGlua19jbGsuZnVsbCA9IGRmaXhlZF9jb25zdChpbmZvLT5pbmZvX3YyLnVsSFRMaW5rRnJl
cSk7CiAJCQlyZGV2LT5wbS5pZ3BfaHRfbGlua19jbGsuZnVsbCA9IGRmaXhlZF9kaXYocmRldi0+
cG0uaWdwX2h0X2xpbmtfY2xrLCB0bXApOwogCQkJcmRldi0+cG0uaWdwX2h0X2xpbmtfd2lkdGgu
ZnVsbCA9IGRmaXhlZF9jb25zdChsZTE2X3RvX2NwdShpbmZvLT5pbmZvX3YyLnVzTWluSFRMaW5r
V2lkdGgpKTsKIAkJCWJyZWFrOwogCQlkZWZhdWx0OgotCQkJdG1wLmZ1bGwgPSBkZml4ZWRfY29u
c3QoMTAwKTsKIAkJCS8qIFdlIGFzc3VtZSB0aGUgc2xvd2VyIHBvc3NpYmxlIGNsb2NrIGllIHdv
cnN0IGNhc2UgKi8KLQkJCS8qIEREUiAzMzNNaHogKi8KLQkJCXJkZXYtPnBtLmlncF9zaWRlcG9y
dF9tY2xrLmZ1bGwgPSBkZml4ZWRfY29uc3QoMzMzKTsKLQkJCS8qIEZJWE1FOiBzeXN0ZW0gY2xv
Y2sgPyAqLwotCQkJcmRldi0+cG0uaWdwX3N5c3RlbV9tY2xrLmZ1bGwgPSBkZml4ZWRfY29uc3Qo
MTAwKTsKLQkJCXJkZXYtPnBtLmlncF9zeXN0ZW1fbWNsay5mdWxsID0gZGZpeGVkX2RpdihyZGV2
LT5wbS5pZ3Bfc3lzdGVtX21jbGssIHRtcCk7Ci0JCQlyZGV2LT5wbS5pZ3BfaHRfbGlua19jbGsu
ZnVsbCA9IGRmaXhlZF9jb25zdCgyMDApOworCQkJcmRldi0+cG0uaWdwX3NpZGVwb3J0X21jbGsu
ZnVsbCA9IGRmaXhlZF9jb25zdCgyMDApOworCQkJcmRldi0+cG0uaWdwX3N5c3RlbV9tY2xrLmZ1
bGwgPSBkZml4ZWRfY29uc3QoMjAwKTsKKwkJCXJkZXYtPnBtLmlncF9odF9saW5rX2Nsay5mdWxs
ID0gZGZpeGVkX2NvbnN0KDEwMDApOwogCQkJcmRldi0+cG0uaWdwX2h0X2xpbmtfd2lkdGguZnVs
bCA9IGRmaXhlZF9jb25zdCg4KTsKIAkJCURSTV9FUlJPUigiTm8gaW50ZWdyYXRlZCBzeXN0ZW0g
aW5mbyBmb3IgeW91ciBHUFUsIHVzaW5nIHNhZmUgZGVmYXVsdFxuIik7CiAJCQlicmVhazsKIAkJ
fQogCX0gZWxzZSB7Ci0JCXRtcC5mdWxsID0gZGZpeGVkX2NvbnN0KDEwMCk7CiAJCS8qIFdlIGFz
c3VtZSB0aGUgc2xvd2VyIHBvc3NpYmxlIGNsb2NrIGllIHdvcnN0IGNhc2UgKi8KLQkJLyogRERS
IDMzM01oeiAqLwotCQlyZGV2LT5wbS5pZ3Bfc2lkZXBvcnRfbWNsay5mdWxsID0gZGZpeGVkX2Nv
bnN0KDMzMyk7Ci0JCS8qIEZJWE1FOiBzeXN0ZW0gY2xvY2sgPyAqLwotCQlyZGV2LT5wbS5pZ3Bf
c3lzdGVtX21jbGsuZnVsbCA9IGRmaXhlZF9jb25zdCgxMDApOwotCQlyZGV2LT5wbS5pZ3Bfc3lz
dGVtX21jbGsuZnVsbCA9IGRmaXhlZF9kaXYocmRldi0+cG0uaWdwX3N5c3RlbV9tY2xrLCB0bXAp
OwotCQlyZGV2LT5wbS5pZ3BfaHRfbGlua19jbGsuZnVsbCA9IGRmaXhlZF9jb25zdCgyMDApOwor
CQlyZGV2LT5wbS5pZ3Bfc2lkZXBvcnRfbWNsay5mdWxsID0gZGZpeGVkX2NvbnN0KDIwMCk7CisJ
CXJkZXYtPnBtLmlncF9zeXN0ZW1fbWNsay5mdWxsID0gZGZpeGVkX2NvbnN0KDIwMCk7CisJCXJk
ZXYtPnBtLmlncF9odF9saW5rX2Nsay5mdWxsID0gZGZpeGVkX2NvbnN0KDEwMDApOwogCQlyZGV2
LT5wbS5pZ3BfaHRfbGlua193aWR0aC5mdWxsID0gZGZpeGVkX2NvbnN0KDgpOwogCQlEUk1fRVJS
T1IoIk5vIGludGVncmF0ZWQgc3lzdGVtIGluZm8gZm9yIHlvdXIgR1BVLCB1c2luZyBzYWZlIGRl
ZmF1bHRcbiIpOwogCX0KLS0gCjEuNy4wLjEKCg==
--0015174c178c963939048a41824b--
