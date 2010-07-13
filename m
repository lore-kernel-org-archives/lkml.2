Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab0GMRvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 13:51:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996Ab0GMRvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 13:51:23 -0400
MIME-Version: 1.0
In-Reply-To: <20100713172526.GE15122@anguilla.noreply.org>
References: <20100707124731.GJ15122@anguilla.noreply.org>
	<4C359D5A.1050906@redhat.com>
	<20100713102350.GW15122@anguilla.noreply.org>
	<4C3C68C8.4060409@redhat.com>
	<20100713141902.GB15122@anguilla.noreply.org>
	<4C3C8CE5.1080705@redhat.com>
	<20100713162207.GC15122@anguilla.noreply.org>
	<4C3C9589.4090602@redhat.com>
	<4C3C96EC.8060901@redhat.com>
	<4C3C9839.4090404@redhat.com>
	<20100713172526.GE15122@anguilla.noreply.org>
Date: Tue, 13 Jul 2010 10:50:46 -0700
Message-ID: <AANLkTini61PZO1_icO2jRcBmMvWm24splgjZA1lUgab2@mail.gmail.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point 
	for pvclock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Palfrader <peter@palfrader.org>, Avi Kivity <avi@redhat.com>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: multipart/mixed; boundary=000e0cd6a80e4457be048b488285
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd6a80e4457be048b488285
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 13, 2010 at 10:25 AM, Peter Palfrader <peter@palfrader.org> wro=
te:
>
> Linus's patch touches __xchg() whereas we're using __cmpxchg() in this
> particular case I think.
>
> At least, applying it to my 2.6.32.16 tree didn't help, last_value was
> still read-only. =A0Or I backported it wrong.

No, you didn't back-port it wrong. I just didn't fix the right part. I
thought the PV code used xchg, not cmpxchg, so I only patched that.
But cmpxchg has the exact same issue.

Does this fix it?

Again: UNTESTED.

                   Linus

--000e0cd6a80e4457be048b488285
Content-Type: application/octet-stream; name=diff
Content-Disposition: attachment; filename=diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gbl1fe5v0

IGFyY2gveDg2L2luY2x1ZGUvYXNtL2NtcHhjaGdfNjQuaCB8ICAgMjggKysrKysrKysrKysrLS0t
LS0tLS0tLS0tLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCAxNiBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9jbXB4Y2hnXzY0Lmgg
Yi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9jbXB4Y2hnXzY0LmgKaW5kZXggNDg1YWU0MS4uZjZmYWNl
NyAxMDA2NDQKLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vY21weGNoZ182NC5oCisrKyBiL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL2NtcHhjaGdfNjQuaApAQCAtNzEsMjggKzcxLDI0IEBAIGV4dGVy
biB2b2lkIF9fY21weGNoZ193cm9uZ19zaXplKHZvaWQpOwogCV9fdHlwZW9mX18oKihwdHIpKSBf
X25ldyA9IChuZXcpOwkJCQlcCiAJc3dpdGNoIChzaXplKSB7CQkJCQkJCVwKIAljYXNlIDE6CQkJ
CQkJCQlcCi0JCWFzbSB2b2xhdGlsZShsb2NrICJjbXB4Y2hnYiAlYjEsJTIiCQkJXAotCQkJICAg
ICA6ICI9YSIoX19yZXQpCQkJCVwKLQkJCSAgICAgOiAicSIoX19uZXcpLCAibSIoKl9feGcocHRy
KSksICIwIihfX29sZCkJXAotCQkJICAgICA6ICJtZW1vcnkiKTsJCQkJXAorCQlhc20gdm9sYXRp
bGUobG9jayAiY21weGNoZ2IgJWIyLCUxIgkJCVwKKwkJCSAgICAgOiAiPWEiKF9fcmV0KSwgIitt
IiAoKnB0cikJCQlcCisJCQkgICAgIDogInEiKF9fbmV3KSwgIjAiKF9fb2xkKSk7CQkJXAogCQli
cmVhazsJCQkJCQkJXAogCWNhc2UgMjoJCQkJCQkJCVwKLQkJYXNtIHZvbGF0aWxlKGxvY2sgImNt
cHhjaGd3ICV3MSwlMiIJCQlcCi0JCQkgICAgIDogIj1hIihfX3JldCkJCQkJXAotCQkJICAgICA6
ICJyIihfX25ldyksICJtIigqX194ZyhwdHIpKSwgIjAiKF9fb2xkKQlcCi0JCQkgICAgIDogIm1l
bW9yeSIpOwkJCQlcCisJCWFzbSB2b2xhdGlsZShsb2NrICJjbXB4Y2hndyAldzIsJTEiCQkJXAor
CQkJICAgICA6ICI9YSIoX19yZXQpLCAiK20iICgqcHRyKQkJCVwKKwkJCSAgICAgOiAiciIoX19u
ZXcpLCAiMCIoX19vbGQpKTsJCQlcCiAJCWJyZWFrOwkJCQkJCQlcCiAJY2FzZSA0OgkJCQkJCQkJ
XAotCQlhc20gdm9sYXRpbGUobG9jayAiY21weGNoZ2wgJWsxLCUyIgkJCVwKLQkJCSAgICAgOiAi
PWEiKF9fcmV0KQkJCQlcCi0JCQkgICAgIDogInIiKF9fbmV3KSwgIm0iKCpfX3hnKHB0cikpLCAi
MCIoX19vbGQpCVwKLQkJCSAgICAgOiAibWVtb3J5Iik7CQkJCVwKKwkJYXNtIHZvbGF0aWxlKGxv
Y2sgImNtcHhjaGdsICVrMiwlMSIJCQlcCisJCQkgICAgIDogIj1hIihfX3JldCksICIrbSIgKCpw
dHIpCQkJXAorCQkJICAgICA6ICJyIihfX25ldyksICIwIihfX29sZCkpOwkJCVwKIAkJYnJlYWs7
CQkJCQkJCVwKIAljYXNlIDg6CQkJCQkJCQlcCi0JCWFzbSB2b2xhdGlsZShsb2NrICJjbXB4Y2hn
cSAlMSwlMiIJCQlcCi0JCQkgICAgIDogIj1hIihfX3JldCkJCQkJXAotCQkJICAgICA6ICJyIihf
X25ldyksICJtIigqX194ZyhwdHIpKSwgIjAiKF9fb2xkKQlcCi0JCQkgICAgIDogIm1lbW9yeSIp
OwkJCQlcCisJCWFzbSB2b2xhdGlsZShsb2NrICJjbXB4Y2hncSAlMiwlMSIJCQlcCisJCQkgICAg
IDogIj1hIihfX3JldCksICIrbSIgKCpwdHIpCQkJXAorCQkJICAgICA6ICJyIihfX25ldyksICIw
IihfX29sZCkpOwkJCVwKIAkJYnJlYWs7CQkJCQkJCVwKIAlkZWZhdWx0OgkJCQkJCQlcCiAJCV9f
Y21weGNoZ193cm9uZ19zaXplKCk7CQkJCQlcCg==
--000e0cd6a80e4457be048b488285--
