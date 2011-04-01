Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab1DAVYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 17:24:55 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43101 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab1DAVYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 17:24:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=dmxyP3z2nXXYGTb/5TaR/Fvwpzsb0y9UppYxV2xwUMzwEJr2RbuKg4+9mAGMHWPLaF
         3JcrHAzKwRJ8zMs7sQyM7J2gBdDFxt1/M2PV9DcMhsYfeqoCVnka071ET5lHD+D/LAXu
         9tB4yzV3N5GEW81Q1Oca3DOPGICtvO4J3SfVk=
MIME-Version: 1.0
In-Reply-To: <4D9633E7.1010707@zytor.com>
References: <20110330203215.0a1a41a7@xenia.leun.net>
	<20110331090524.07ad0069@xenia.leun.net>
	<alpine.DEB.2.00.1103311546480.16492@kaball-desktop>
	<201103312348.53678.rjw@sisk.pl>
	<4D94FE37.8070109@kernel.org>
	<alpine.DEB.2.00.1104011230550.16492@kaball-desktop>
	<4D95F80D.7070201@kernel.org>
	<4D95FBDD.9050901@zytor.com>
	<alpine.DEB.2.00.1104011729000.16492@kaball-desktop>
	<4D961FBC.2030105@zytor.com>
	<4D962837.2070300@kernel.org>
	<4D96294B.5050909@zytor.com>
	<4D962D72.2010501@kernel.org>
	<4D9633E7.1010707@zytor.com>
Date: Fri, 1 Apr 2011 14:24:53 -0700
X-Google-Sender-Auth: Sfz8hKSlCfG-_w8A94vgYBfoyes
Message-ID: <AANLkTi=VzMh84szSBNujVU8oLZfzQd_z2bg+O3K_8GMd@mail.gmail.com>
Subject: Re: 2.6.38.2 breaks suspend to disk
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Michael Leun <lkml20101129@newton.leun.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mike Pagano <mpagano@gentoo.org>
Content-Type: multipart/mixed; boundary=90e6ba6e8a0c6e47bf049fe20ab0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba6e8a0c6e47bf049fe20ab0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 1, 2011 at 1:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/01/2011 12:54 PM, Yinghai Lu wrote:
>>
>> ok, please check if you are happy with this one.
>>
>
> The best would simply be:
>
> =A0 =A0 =A0 =A0mmu_cr4_features =3D read_cr4_safe();
>
> If this has to run before we can handle exceptions, one can verify the
> existence by testing for the CPUID instruction (a CPU has CR4 if and
> only if it has CPUID):
>
> =A0 =A0 =A0 =A0if (boot_cpu_data.cpuid_level >=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mmu_cr4_features =3D read_cr4_safe();
>
> ... since we set cpuid_level to -1 if there is no CPUID instruction.

in that case could use read_cr4 directly.

please check attached -v4

Thanks

--90e6ba6e8a0c6e47bf049fe20ab0
Content-Type: text/x-patch; charset=US-ASCII; name="fix_store.patch"
Content-Disposition: attachment; filename="fix_store.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_glzmevhn0

RnJvbTogU3RlZmFubyBTdGFiZWxsaW5pIDxzdGVmYW5vLnN0YWJlbGxpbmlAZXUuY2l0cml4LmNv
bT4KCltQQVRDSCAtdjRdIHg4NjogU2F2ZSBjcjQgdG8gbW11X2NyNF9mZWF0dXJlcyBhdCBib290
IHRpbWUKClNhdmUgY3I0IHRvIG1tdV9jcjRfZmVhdHVyZXMgYXQgYm9vdCB0aW1lCgpNaWNoYWVs
IHJlcG9ydGVkIDIuNi4zOC4yIGhpYmVybmF0aW9uIGlzIGJyb2tlbiBieSBvbmUgYmFja3BvcnRl
ZCBwYXRjaC4KaXQgY2F1c2UgYSBmcmVlemUgd2hlbiByZXN1bWluZyBmcm9tIGhpYmVybmF0aW9u
Cgp8ICJ4ODY6IENsZWFudXAgaGlnaG1hcCBhZnRlciBicmsgaXMgY29uY2x1ZGVkIgp8IGNvbW1p
dCBpZCBlNWYxNWI0NWRkZjNhZmEyYmJiYjEwYzdlYTM0ZmIzMmI2ZGUwYTBlLgoKaXQgdHVybnMg
b3V0IHRoZSBtbXVfY3I0IHNhdmUgaXQgbG9zdCBzb21laG93LgoKLXYzOiByZWFkIGJhY2sgY3I0
IGZvciAzMmJpdCB0b28gYWNjb3JkaW5nIHRvIEhQQQotdjQ6IHVzZSBjcHVpZF9sZXZlbCB0byBj
aGVjayBpZiB3ZSBjYW4gcmVhZCBjcjQgYWNjb3JkaW5nIHRvIEhQQQogICAgIGRvbid0IHRvdWNo
IG1tdV9jcjRfZmVhdHVyZXMgaWYgQ09ORklHX0hJQkVSTkFUSU9OIGlzIGRlZmluZWQgZnJvbSBZ
aW5naGFpCgpCaXNlY3RlZC1hbmQtdGVzdGVkLWJ5OiBNaWNoYWVsIExldW4gPGxrbWwyMDEwMTEy
OUBuZXd0b24ubGV1bi5uZXQ+ClNpZ25lZC1vZmYtYnk6IFN0ZWZhbm8gU3RhYmVsbGluaSA8c3Rl
ZmFuby5zdGFiZWxsaW5pQGV1LmNpdHJpeC5jb20+ClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUg
PHlpbmdoYWlAa2VybmVsLm9yZz4KCi0tLQogYXJjaC94ODYvaW5jbHVkZS9hc20vcHJvY2Vzc29y
LmggfCAgICA0ICsrKysKIGFyY2gveDg2L2tlcm5lbC9zZXR1cC5jICAgICAgICAgIHwgICAxMSAr
KysrKysrKysrLQogMiBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9u
KC0pCgpJbmRleDogbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9zZXR1cC5jCj09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0K
LS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2tlcm5lbC9zZXR1cC5jCisrKyBsaW51eC0yLjYv
YXJjaC94ODYva2VybmVsL3NldHVwLmMKQEAgLTIxMiw3ICsyMTIsMTEgQEAgc3RydWN0IGNwdWlu
Zm9feDg2IGJvb3RfY3B1X2RhdGEgX19yZWFkXwogRVhQT1JUX1NZTUJPTChib290X2NwdV9kYXRh
KTsKICNlbmRpZgogCi0KKy8qCisgKiBtbXVfY3I0X2ZlYXR1cmVzIHR3byBwdXJwb3NlOgorICog
IGEuIGhlYWRfMzIuUyB3aWxsIGFjY2VzcyBjcjQgYWNjb3JkaW5nIGlmIFg4Nl9DUjRfUEFFIGlz
IHNldCBpbiBpdC4KKyAqICBiLiBzdG9yZSByZWFkIGJhY2sgY3I0IGZvciBoaWJlcm5hdGlvbgor
ICovCiAjaWYgIWRlZmluZWQoQ09ORklHX1g4Nl9QQUUpIHx8IGRlZmluZWQoQ09ORklHX1g4Nl82
NCkKIHVuc2lnbmVkIGxvbmcgbW11X2NyNF9mZWF0dXJlczsKICNlbHNlCkBAIC04OTIsNiArODk2
LDExIEBAIHZvaWQgX19pbml0IHNldHVwX2FyY2goY2hhciAqKmNtZGxpbmVfcCkKIAogCWhpZ2hf
bWVtb3J5ID0gKHZvaWQgKilfX3ZhKG1heF9wZm4gKiBQQUdFX1NJWkUgLSAxKSArIDE7CiAjZW5k
aWYKKyNpZmRlZiBDT05GSUdfSElCRVJOQVRJT04KKwkvKiBhIENQVSBoYXMgQ1I0IGlmZiBpdCBo
YXMgQ1BVSUQgLS0tIGhwYSAqLworCWlmIChib290X2NwdV9kYXRhLmNwdWlkX2xldmVsID49IDAp
CisJCW1tdV9jcjRfZmVhdHVyZXMgPSByZWFkX2NyNCgpOworI2VuZGlmCiAKIAkvKgogCSAqIEZp
bmQgYW5kIHJlc2VydmUgcG9zc2libGUgYm9vdC10aW1lIFNNUCBjb25maWd1cmF0aW9uOgpJbmRl
eDogbGludXgtMi42L2FyY2gveDg2L2luY2x1ZGUvYXNtL3Byb2Nlc3Nvci5oCj09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0K
LS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Byb2Nlc3Nvci5oCisrKyBs
aW51eC0yLjYvYXJjaC94ODYvaW5jbHVkZS9hc20vcHJvY2Vzc29yLmgKQEAgLTYwMSw3ICs2MDEs
OSBAQCBzdGF0aWMgaW5saW5lIHZvaWQgc2V0X2luX2NyNCh1bnNpZ25lZCBsCiB7CiAJdW5zaWdu
ZWQgbG9uZyBjcjQ7CiAKKyNpZmRlZiBDT05GSUdfSElCRVJOQVRJT04KIAltbXVfY3I0X2ZlYXR1
cmVzIHw9IG1hc2s7CisjZW5kaWYKIAljcjQgPSByZWFkX2NyNCgpOwogCWNyNCB8PSBtYXNrOwog
CXdyaXRlX2NyNChjcjQpOwpAQCAtNjExLDcgKzYxMyw5IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBj
bGVhcl9pbl9jcjQodW5zaWduZWQKIHsKIAl1bnNpZ25lZCBsb25nIGNyNDsKIAorI2lmZGVmIENP
TkZJR19ISUJFUk5BVElPTgogCW1tdV9jcjRfZmVhdHVyZXMgJj0gfm1hc2s7CisjZW5kaWYKIAlj
cjQgPSByZWFkX2NyNCgpOwogCWNyNCAmPSB+bWFzazsKIAl3cml0ZV9jcjQoY3I0KTsK
--90e6ba6e8a0c6e47bf049fe20ab0--
