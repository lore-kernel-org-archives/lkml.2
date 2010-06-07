Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab0FGPuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 11:50:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57186 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0FGPuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 11:50:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TZKg3TGYMXCr7PIj05sptudG/LpnlAYLMoJaSzvcNBW6QajcYgisGzoKlRA9a67HZ/
         M+GXoyAWEqagwFCt1MNkX4DsJzh42T40TJ/i4Ju4sULfMDobu/4HtbC9izybl0D31Amd
         xwLxeIwpQcavPxDaU9w66H/FLvh8URiAM3oNs=
MIME-Version: 1.0
In-Reply-To: <AANLkTinx-5-jjtnYnUAsl-DvFtbL6wtyPnALdri0d-d2@mail.gmail.com>
References: <201006071129.32159.rjw@sisk.pl>
	<AANLkTinx-5-jjtnYnUAsl-DvFtbL6wtyPnALdri0d-d2@mail.gmail.com>
Date: Mon, 7 Jun 2010 11:50:21 -0400
Message-ID: <AANLkTilerIhYtHlX0vNAg_pfG_1100OymKV4aaGv-VSE@mail.gmail.com>
Subject: Re: [Regression, post-rc1] Multiple issues after enabling SetVoltage 
	on rs780m
From: Alex Deucher <alexdeucher@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Dave Airlie <airlied@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Content-Type: multipart/mixed; boundary=0015174c0f5e5d1309048872a149
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174c0f5e5d1309048872a149
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 7, 2010 at 6:15 AM, Dave Airlie <airlied@gmail.com> wrote:
> On Mon, Jun 7, 2010 at 7:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> Hi Alex,
>>
>> Your commit 9349d5cc920c10845693f906ebd67f394f1d0d04
>> (drm/radeon/kms/pm: enable SetVoltage on r7xx/evergreen) has caused my t=
est-bed
>> Acer Ferrari One to behave quite unreliably. =A0The symptoms are:
>>
>> - the system hangs hard (~ 50% of the time) when starting Xorg
>> - the system hangs hard (~ 50% of the time) when stopping Xorg during sy=
stem
>> =A0reboot
>> - the system sometimes hangs hard during suspend to RAM
>>
>> These problems are not reproducible with the commit above reverted.
>>
>> Below is the information about the graphics adapter from lspci.
>
> Reverting that commit on master fixes it?
>
> that commit touches code paths in rv770 and evergreen that in no way
> should affect that chipset which is an rs780, so takes the r600 paths.
>
> are you sure its not 7ac9aa5a1f1b87adb69bcbec2b89e228f074103a?

It should be that commit if it is indeed the voltage adjust.  That
said, I just took a closer look at the voltage adjust on newer IGPs
and unfortunately, it doesn't work the same as the discrete cards, so
for now we should disable it.  The attached patch should do the trick.
 There weren't any problems on my IGP chips, but they don't have a
SetVoltage table, so nothing is touching the hw.

Alex

--0015174c0f5e5d1309048872a149
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-pm-Disable-voltage-adjust-on-RS780-RS.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-pm-Disable-voltage-adjust-on-RS780-RS.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ga5h4yrb0

RnJvbSA4YzA1NWEyYTVjMGJkMDYzZmUyYmY0Nzk3YzU4NWZkMWNkNTlhNjczIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdtYWlsLmNvbT4K
RGF0ZTogTW9uLCA3IEp1biAyMDEwIDExOjM1OjUzIC0wNDAwClN1YmplY3Q6IFtQQVRDSF0gZHJt
L3JhZGVvbi9rbXMvcG06IERpc2FibGUgdm9sdGFnZSBhZGp1c3Qgb24gUlM3ODAvUlM4ODAKClRo
ZSB2ZGRjIHZhbHVlIGluIHRoZSBwb3dlciB0YWJsZXMgaXMgbm90IGFuIGFjdHVhbCB2b2x0YWdl
Cmxpa2Ugb24gZGlzY3JldGUgcjZ4eC9yN3h4L2V2ZXJncmVlbiBzeXN0ZW1zLCBidXQgaW5zdGVh
ZCBoYXMKYSBzeW1ib2xpYyBtZWFuaW5nIChlLmcuLCBOT05FLCBMT1csIEhJR0gsIGV0Yy4pLiAg
U2VlIGF0b21iaW9zLmgKCk1vc3QgUlM3ODAvUlM4ODAgdmJpb3NlcyBkb24ndCBoYXZlIGEgU2V0
Vm9sdGFnZSB0YWJsZSBhbnl3YXksCnNvIGl0IHNob3VsZG4ndCBiZSBkb2luZyBhbnl0aGluZyB0
byB0aGUgaGFyZHdhcmUgYXQgdGhlIG1vbWVudC4KCkkgbmVlZCB0byBmaWd1cmUgb3V0IGhvdyB2
b2x0YWdlIGlzIHN1cHBvc2VkIHRvIHdvcmsgb24gdGhlIG5ld2VyCklHUHM7IHVudGlsIHRoZW4s
IGRpc2FibGUgaXQuCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdt
YWlsLmNvbT4KLS0tCiBkcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9hdG9tYmlvcy5jIHwg
ICAgNSArLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fYXRvbWJpb3Mu
YyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2F0b21iaW9zLmMKaW5kZXggMDYxNmUz
OS4uNWRkODZiOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fYXRv
bWJpb3MuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9hdG9tYmlvcy5jCkBA
IC0xODQxLDEwICsxODQxLDcgQEAgdm9pZCByYWRlb25fYXRvbWJpb3NfZ2V0X3Bvd2VyX21vZGVz
KHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2KQogCQkJCQkJLyogc2tpcCBpbnZhbGlkIG1vZGVz
ICovCiAJCQkJCQlpZiAocmRldi0+cG0ucG93ZXJfc3RhdGVbc3RhdGVfaW5kZXhdLmNsb2NrX2lu
Zm9bbW9kZV9pbmRleF0uc2NsayA9PSAwKQogCQkJCQkJCWNvbnRpbnVlOwotCQkJCQkJcmRldi0+
cG0ucG93ZXJfc3RhdGVbc3RhdGVfaW5kZXhdLmNsb2NrX2luZm9bbW9kZV9pbmRleF0udm9sdGFn
ZS50eXBlID0KLQkJCQkJCQlWT0xUQUdFX1NXOwotCQkJCQkJcmRldi0+cG0ucG93ZXJfc3RhdGVb
c3RhdGVfaW5kZXhdLmNsb2NrX2luZm9bbW9kZV9pbmRleF0udm9sdGFnZS52b2x0YWdlID0KLQkJ
CQkJCQljbG9ja19pbmZvLT51c1ZEREM7CisJCQkJCQkvKiB2b2x0YWdlIHdvcmtzIGRpZmZlcmVu
dGx5IG9uIElHUHMgKi8KIAkJCQkJCW1vZGVfaW5kZXgrKzsKIAkJCQkJfSBlbHNlIGlmIChBU0lD
X0lTX0RDRTQocmRldikpIHsKIAkJCQkJCXN0cnVjdCBfQVRPTV9QUExJQl9FVkVSR1JFRU5fQ0xP
Q0tfSU5GTyAqY2xvY2tfaW5mbyA9Ci0tIAoxLjcuMC4xCgo=
--0015174c0f5e5d1309048872a149--
