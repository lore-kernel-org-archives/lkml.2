Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030325Ab2AFOmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 09:42:03 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53854 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab2AFOmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 09:42:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAD2nsn0PJU+ZuZfuVOzsvN0yq76JdgYpwkoeS8yfvKQSiO8VfA@mail.gmail.com>
References: <NEXT-4f06ee5c00c505.33406970@nextmail.ru>
	<CAD2nsn0PJU+ZuZfuVOzsvN0yq76JdgYpwkoeS8yfvKQSiO8VfA@mail.gmail.com>
Date: Fri, 6 Jan 2012 20:11:59 +0530
Message-ID: <CAD2nsn3+AWwz1=h9mXR1S5S5ioydHTBzeoWd7wrgh9jnp_hQTA@mail.gmail.com>
Subject: Re: ath9k crash 3.2-rc7
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: MR <g7af0ec1e3ea1e7b1@nextmail.ru>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary=bcaec54ee96423d71004b5dd0ded
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec54ee96423d71004b5dd0ded
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 6, 2012 at 8:05 PM, Mohammed Shafi <shafi.wireless@gmail.com> w=
rote:
> 2012/1/6 MR <g7af0ec1e3ea1e7b1@nextmail.ru>:
>> =A0>:( =A0i had put those warnings to prevent the crash itself and what'=
s causing
>> =A0>it.
>> =A0> may be i had missed that pos can be < 0 in addition to (pos > 37).
>> =A0> i am just looking at those areas of code for some other issue. hope=
 i
>> =A0> can a find a fix
>> =A0> for both of them
>>
>> I am building kernel with pos<0 check added...
>
> thanks! =A0if it does not works, i have only one more idea(a patch
> which removes some suspicious code which abuses a pointer any way that
> has to be fixed properly ). otherwise i need to recreate the issue and
> capture the stack trace completely, put debug prints. i ran an
> overnight test but was unable to recreate the issue. later today AN =A0i
> got a crash accidentally but only once, after that never.

attaching the patch for your reference, but this is not the fix. it
has to be fixed properly.
if it does not helps, then the issue itself is something else i had assumed=
.

>
>>
>> I hoped for some ad-hoc stress-test recommendation, but I guess this wil=
l have
>> to wait.

any test if we can recreate the panic ASAP will be highly helpful. it
will help us narrow down the issue quickly and put more debug
prints/ideas

>>
>>
>
>
>
> --
> shafi



--=20
shafi

--bcaec54ee96423d71004b5dd0ded
Content-Type: text/x-diff; charset=US-ASCII; name="remove-suspicious-code.patch"
Content-Disposition: attachment; filename="remove-suspicious-code.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gx3bcews0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9tYWluLmMgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvbWFpbi5jCmluZGV4IGUyNjdjOTIuLmEzOWNiZGMg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9tYWluLmMKKysrIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL21haW4uYwpAQCAtMTYyOSw3ICsxNjI5LDYg
QEAgc3RhdGljIGludCBhdGg5a19jb25maWcoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHUzMiBj
aGFuZ2VkKQogCiAJaWYgKGNoYW5nZWQgJiBJRUVFODAyMTFfQ09ORl9DSEFOR0VfQ0hBTk5FTCkg
ewogCQlzdHJ1Y3QgaWVlZTgwMjExX2NoYW5uZWwgKmN1cmNoYW4gPSBody0+Y29uZi5jaGFubmVs
OwotCQlzdHJ1Y3QgYXRoOWtfY2hhbm5lbCBvbGRfY2hhbjsKIAkJaW50IHBvcyA9IGN1cmNoYW4t
Pmh3X3ZhbHVlOwogCQlpbnQgb2xkX3BvcyA9IC0xOwogCQl1bnNpZ25lZCBsb25nIGZsYWdzOwpA
QCAtMTY0NSwyNSArMTY0NCwxNSBAQCBzdGF0aWMgaW50IGF0aDlrX2NvbmZpZyhzdHJ1Y3QgaWVl
ZTgwMjExX2h3ICpodywgdTMyIGNoYW5nZWQpCiAJCWF0aF9kYmcoY29tbW9uLCBDT05GSUcsICJT
ZXQgY2hhbm5lbDogJWQgTUh6IHR5cGU6ICVkXG4iLAogCQkJY3VyY2hhbi0+Y2VudGVyX2ZyZXEs
IGNvbmYtPmNoYW5uZWxfdHlwZSk7CiAKKwkJYXRoOWtfY21uX3VwZGF0ZV9pY2hhbm5lbCgmc2Mt
PnNjX2FoLT5jaGFubmVsc1twb3NdLAorCQkJCQkgIGN1cmNoYW4sIGNvbmYtPmNoYW5uZWxfdHlw
ZSk7CisKIAkJLyogdXBkYXRlIHN1cnZleSBzdGF0cyBmb3IgdGhlIG9sZCBjaGFubmVsIGJlZm9y
ZSBzd2l0Y2hpbmcgKi8KIAkJc3Bpbl9sb2NrX2lycXNhdmUoJmNvbW1vbi0+Y2NfbG9jaywgZmxh
Z3MpOwogCQlhdGhfdXBkYXRlX3N1cnZleV9zdGF0cyhzYyk7CiAJCXNwaW5fdW5sb2NrX2lycXJl
c3RvcmUoJmNvbW1vbi0+Y2NfbG9jaywgZmxhZ3MpOwogCiAJCS8qCi0JCSAqIFByZXNlcnZlIHRo
ZSBjdXJyZW50IGNoYW5uZWwgdmFsdWVzLCBiZWZvcmUgdXBkYXRpbmcKLQkJICogdGhlIHNhbWUg
Y2hhbm5lbAotCQkgKi8KLQkJaWYgKG9sZF9wb3MgPT0gcG9zKSB7Ci0JCQltZW1jcHkoJm9sZF9j
aGFuLCAmc2MtPnNjX2FoLT5jaGFubmVsc1twb3NdLAotCQkJCXNpemVvZihzdHJ1Y3QgYXRoOWtf
Y2hhbm5lbCkpOwotCQkJYWgtPmN1cmNoYW4gPSAmb2xkX2NoYW47Ci0JCX0KLQotCQlhdGg5a19j
bW5fdXBkYXRlX2ljaGFubmVsKCZzYy0+c2NfYWgtPmNoYW5uZWxzW3Bvc10sCi0JCQkJCSAgY3Vy
Y2hhbiwgY29uZi0+Y2hhbm5lbF90eXBlKTsKLQotCQkvKgogCQkgKiBJZiB0aGUgb3BlcmF0aW5n
IGNoYW5uZWwgY2hhbmdlcywgY2hhbmdlIHRoZSBzdXJ2ZXkgaW4tdXNlIGZsYWdzCiAJCSAqIGFs
b25nIHdpdGggaXQuCiAJCSAqIFJlc2V0IHRoZSBzdXJ2ZXkgZGF0YSBmb3IgdGhlIG5ldyBjaGFu
bmVsLCB1bmxlc3Mgd2UncmUgc3dpdGNoaW5nCg==
--bcaec54ee96423d71004b5dd0ded--
