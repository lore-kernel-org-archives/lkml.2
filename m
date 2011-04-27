Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269Ab1D0Ppz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:45:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50180 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab1D0Ppx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:45:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qCadueXwZKsFax0aUpQF1hBhDMk7DGmQTFbieBqJ2Dz8rZssGl5aG20N99K6XIDm4V
         N3RnBlSGkNzljhhvMO927A1ppnEcSrTbDhOzZ+nJKU6oatGX3aC8OBDbV4KXKVrVHk/I
         m1qYdvrB4waQqJFxM6Viu/pJwFujr7ThAUWL8=
MIME-Version: 1.0
In-Reply-To: <4DB72726.6050506@lwfinger.net>
References: <BANLkTi=fFg6+3DcBNwEOex0jASf1WiBRDQ@mail.gmail.com>
	<4DB4E94C.2060505@lwfinger.net>
	<BANLkTinA6GTTjP=MsVcCqmCA1Tgh-6bHjA@mail.gmail.com>
	<4DB5C8FA.2030700@lwfinger.net>
	<BANLkTi=syavY0Tw-Ny9-QhU=_Ryrbmkhfw@mail.gmail.com>
	<4DB61645.8010001@lwfinger.net>
	<BANLkTikWHxEnzZ+H1OgFv7AdmpmmcwVuzA@mail.gmail.com>
	<4DB6E584.9040504@lwfinger.net>
	<BANLkTin7F21PVKqtbohE6EucdinZ60x5=A@mail.gmail.com>
	<BANLkTi=MO6u_DOaL8DMvuB5uJybQO_hqWA@mail.gmail.com>
	<4DB72726.6050506@lwfinger.net>
Date: Wed, 27 Apr 2011 23:45:52 +0800
Message-ID: <BANLkTi=ekLFAon29qC6WU+oO-tNVi9NFHQ@mail.gmail.com>
Subject: Re: r8712u cannot set essid
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: lkml <linux-kernel@vger.kernel.org>, wlanfae@realtek.com
Content-Type: multipart/mixed; boundary=0015174c104ce9b5b604a1e85534
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174c104ce9b5b604a1e85534
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 27, 2011 at 4:12 AM, Larry Finger <Larry.Finger@lwfinger.net> w=
rote:
>> On Wed, Apr 27, 2011 at 12:24 AM, Jeff Chua<jeff.chua.linux@gmail.com>
>> =A0wrote:
>>>
>>> I hacked it a bit more, and now, it's all working. I'll send you the
>>> patch shortly. Adhoc mode works now, and I've confirmed that my iPhone
>>> can connect to it, get an IP and surf the net! The device is so tiny
>>> and was contemplating on trying another brand.
>>
>> Larry,
>>
>> Here's the patch for adhoc mode. This should work. Just remember to
>> set wpa_supplicant's ap_scan to either 1 or 2 (faster association). 0
>> does not seem to work.
>
> Thanks. Is this in addition to my previous patch, or is this one enough b=
y
> itself?

I just re-verify it, applying your patch alone does not solve the problem.

The issue is with adhoc mode and when it first starts, there is
 no SSID to associate with if the SSID is an unique one. The patch
basically bypass the "sitesurvey" as it could never find another site
with the wanted SSID, so that's why adhoc didn't work before. It
worked if the module has some associations before starting adhoc mode
because now it won't do another sitesurvey. ... this is how I
interpreted the logic. I've been testing it for the past few hours and
wpa2, adhoc all works well with the r7812u driver now.

Thanks for your help. Will you send this to patch to Linus?


Jeff

--0015174c104ce9b5b604a1e85534
Content-Type: application/octet-stream; name=patch-adhoc
Content-Disposition: attachment; filename=patch-adhoc
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gn0fs5ni0

LS0tIGxpbnV4LTIuNi9kcml2ZXJzL3N0YWdpbmcvcnRsODcxMi9ydGw4NzF4X2lvY3RsX3NldC5j
CTIwMTAtMTItMjkgMTM6MzY6MDMuMDAwMDAwMDAwICswODAwCisrKyBsaW51eC0yLjYvZHJpdmVy
cy9zdGFnaW5nL3J0bDg3MTIvcnRsODcxeF9pb2N0bF9zZXQuYwkyMDExLTA0LTI3IDAzOjEzOjM5
LjAwMDAwMDAwMCArMDgwMApAQCAtNjgsNyArNjgsMTEgQEAKIAlwbWxtZXByaXYtPmZ3X3N0YXRl
IHw9IF9GV19VTkRFUl9MSU5LSU5HOwogCXBtbG1lcHJpdi0+cHNjYW5uZWQgPSBwbGlzdDsKIAlw
bWxtZXByaXYtPnRvX2pvaW4gPSB0cnVlOwotCWlmIChfcXVldWVfZW1wdHkocXVldWUpID09IHRy
dWUpIHsKKworCS8vIGFkaG9jIG1vZGUgd2lsbCBzdGFydCB3aXRoIGFuIGVtcHR5IHF1ZXVlLCBi
dXQgc2tpcCBjaGVja2luZworCWlmKCFjaGVja19md3N0YXRlKHBtbG1lcHJpdiwgV0lGSV9BREhP
Q19TVEFURSkgJiYKKwkJIWNoZWNrX2Z3c3RhdGUocG1sbWVwcml2LCBXSUZJX0FESE9DX01BU1RF
Ul9TVEFURSkgJiYKKwkJX3F1ZXVlX2VtcHR5KHF1ZXVlKSA9PSB0cnVlKSB7CiAJCWlmIChwbWxt
ZXByaXYtPmZ3X3N0YXRlICYgX0ZXX1VOREVSX0xJTktJTkcpCiAJCQlwbWxtZXByaXYtPmZ3X3N0
YXRlIF49IF9GV19VTkRFUl9MSU5LSU5HOwogCQkvKiB3aGVuIHNldF9zc2lkL3NldF9ic3NpZCBm
b3IgZG9fam9pbigpLCBidXQgc2Nhbm5pbmcgcXVldWUK
--0015174c104ce9b5b604a1e85534--
