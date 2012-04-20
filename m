Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2DTCG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 22:06:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44402 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab2DTCGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 22:06:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQU7gnKiwazN_2ykbXSkcuDqWMZNt0CHiGvae2L+rTVGug@mail.gmail.com>
References: <4F6A483D.50702@fold.natur.cuni.cz>
	<4F8BEB1D.9080903@fold.natur.cuni.cz>
	<CAE9FiQXoX3J6P_9Tun_XbkK3egvSeBZxAtC13HacFDO0fwmZaA@mail.gmail.com>
	<4F8C6E4E.1000205@fold.natur.cuni.cz>
	<CAE9FiQXikqikMw_LYGqAUsWqFqL-tLiresPhpkpDhb+AxwundQ@mail.gmail.com>
	<CAE9FiQUFB=9zbP1yuBDH1RJrCCP=83kV_fH+TEtk80981-uP=w@mail.gmail.com>
	<CAE9FiQUbzM_TVu+bbXa6LWiUt01QsFiGoyYd0qV=41dXx4J31g@mail.gmail.com>
	<4F8D1B72.2000105@fold.natur.cuni.cz>
	<CAE9FiQW2MAW_WT+sq8XVtMOx=uR8FAN8O2wL2AOxkFBfEM285g@mail.gmail.com>
	<CAE9FiQWSw1h772ijZ6YL4EujwjgvZ84bbDx9VbF_cdE63D-41w@mail.gmail.com>
	<4F8D390F.9050408@fold.natur.cuni.cz>
	<CAE9FiQU-_BCCS1OKagVuj8YNrut8-6GH2_i86FsfS8UDWQ1pRA@mail.gmail.com>
	<CAE9FiQUxoHvUWFXv5LLcBT9vVGnQKp1-Tg7M3XPPULWwtX1iUw@mail.gmail.com>
	<4F8EFFA3.3050705@fold.natur.cuni.cz>
	<CAE9FiQVcJbPub1O6nwyNsiijHFpHN0jMsGO4MmKugybPL7Wnug@mail.gmail.com>
	<4F8F243B.70906@fold.natur.cuni.cz>
	<CAE9FiQXx1NcGY9cHDiM5isx7NyxWN--Exb-4Gfj0arr6vf5ghQ@mail.gmail.com>
	<4F909CEB.3060407@fold.natur.cuni.cz>
	<CAE9FiQU7gnKiwazN_2ykbXSkcuDqWMZNt0CHiGvae2L+rTVGug@mail.gmail.com>
Date: Thu, 19 Apr 2012 19:06:55 -0700
X-Google-Sender-Auth: awSu4vCoC2cAjO2RKLLkcNQbrgU
Message-ID: <CAE9FiQUk8D20mEFPE0ahwfigbEOHpbRp-X0wt4DC+293msw=4Q@mail.gmail.com>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec timeframe
From: Yinghai Lu <yinghai@kernel.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b10d1852269a904be12be45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b10d1852269a904be12be45
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Apr 19, 2012 at 2:48 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Apr 19, 2012 at 4:16 PM, Martin Mokrejs
>> I just tried something similar under linux, with all the patches I accumulated for 3.4-rc3
>> and posted in my previous emails. It seems linux flips some value so on every second card
>> removal it really does realize it was just unplugged.
> ...
>
> that is really looks like silicon problem.
>

please check attached patch. Hope link change bit is flip around...
if there is change, we could add some logic:
   check if the device is there, or will reset link to normal state.

Yinghai

--047d7b10d1852269a904be12be45
Content-Type: application/octet-stream; name="link_change_report.patch"
Content-Disposition: attachment; filename="link_change_report.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h18ljzxf0

U3ViamVjdDogW1BBVENIXSBQQ0ksIHBjaWVocDogUmVwb3J0IHBjaWUgbGluayBzdGF0ZSBjaGFu
Z2UKClRvIHNlZSBpZiB0aGVyZSBpcyBzb21lIGxpbmsgc3RhdGUgY2hhbmdlLgoKU2lnbmVkLW9m
Zi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0tCiBkcml2ZXJzL3BjaS9o
b3RwbHVnL3BjaWVocF9ocGMuYyB8ICAgMjkgKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0K
IDEgZmlsZSBjaGFuZ2VkLCAyNyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKSW5kZXg6
IGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9ob3RwbHVnL3BjaWVocF9ocGMuYwo9PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0t
LSBsaW51eC0yLjYub3JpZy9kcml2ZXJzL3BjaS9ob3RwbHVnL3BjaWVocF9ocGMuYworKysgbGlu
dXgtMi42L2RyaXZlcnMvcGNpL2hvdHBsdWcvcGNpZWhwX2hwYy5jCkBAIC02MjIsNiArNjIyLDI1
IEBAIGludCBwY2llaHBfcG93ZXJfb2ZmX3Nsb3Qoc3RydWN0IHNsb3QgKgogCXJldHVybiAwOwog
fQogCitzdGF0aWMgdTggcGNpZWhwX2hhbmRsZV9saW5rc3RhdGVfY2hhbmdlKHN0cnVjdCBzbG90
ICpzbG90KQoreworCXN0cnVjdCBjb250cm9sbGVyICpjdHJsID0gc2xvdC0+Y3RybDsKKwl1MTYg
bG5rX3N0YXR1czsKKwlpbnQgcmV0dmFsOworCisgICAgICAgIC8qIExpbmtTdGF0ZSBDaGFuZ2Ug
Ki8KKwljdHJsX2RiZyhjdHJsLCAiTGlua1N0YXRlIGNoYW5nZVxuIik7CisKKwlyZXR2YWwgPSBw
Y2llaHBfcmVhZHcoY3RybCwgUENJX0VYUF9MTktTVEEsICZsbmtfc3RhdHVzKTsKKwlpZiAocmV0
dmFsKSB7CisJCWN0cmxfZXJyKGN0cmwsICJDYW5ub3QgcmVhZCBMTktTVEFUVVMgcmVnaXN0ZXJc
biIpOworCQlyZXR1cm4gMTsKKwl9CisJY3RybF9pbmZvKGN0cmwsICJsbmtfc3RhdHVzID0gJXhc
biIsIGxua19zdGF0dXMpOworCisJcmV0dXJuIDE7Cit9CisKIHN0YXRpYyBpcnFyZXR1cm5fdCBw
Y2llX2lzcihpbnQgaXJxLCB2b2lkICpkZXZfaWQpCiB7CiAJc3RydWN0IGNvbnRyb2xsZXIgKmN0
cmwgPSAoc3RydWN0IGNvbnRyb2xsZXIgKilkZXZfaWQ7CkBAIC02NDMsNyArNjYyLDcgQEAgc3Rh
dGljIGlycXJldHVybl90IHBjaWVfaXNyKGludCBpcnEsIHZvaQogCiAJCWRldGVjdGVkICY9IChQ
Q0lfRVhQX1NMVFNUQV9BQlAgfCBQQ0lfRVhQX1NMVFNUQV9QRkQgfAogCQkJICAgICBQQ0lfRVhQ
X1NMVFNUQV9NUkxTQyB8IFBDSV9FWFBfU0xUU1RBX1BEQyB8Ci0JCQkgICAgIFBDSV9FWFBfU0xU
U1RBX0NDKTsKKwkJCSAgICAgUENJX0VYUF9TTFRTVEFfQ0MgfCBQQ0lfRVhQX1NMVFNUQV9ETExT
Qyk7CiAJCWRldGVjdGVkICY9IH5pbnRyX2xvYzsKIAkJaW50cl9sb2MgfD0gZGV0ZWN0ZWQ7CiAJ
CWlmICghaW50cl9sb2MpCkBAIC02NjcsNiArNjg2LDEwIEBAIHN0YXRpYyBpcnFyZXR1cm5fdCBw
Y2llX2lzcihpbnQgaXJxLCB2b2kKIAlpZiAoIShpbnRyX2xvYyAmIH5QQ0lfRVhQX1NMVFNUQV9D
QykpCiAJCXJldHVybiBJUlFfSEFORExFRDsKIAorCS8qIENoZWNrIExpbmsgU3RhdGUgQ2hhbmdl
ZCAqLworCWlmIChpbnRyX2xvYyAmIFBDSV9FWFBfU0xUU1RBX0RMTFNDKQorCQlwY2llaHBfaGFu
ZGxlX2xpbmtzdGF0ZV9jaGFuZ2Uoc2xvdCk7CisKIAkvKiBDaGVjayBNUkwgU2Vuc29yIENoYW5n
ZWQgKi8KIAlpZiAoaW50cl9sb2MgJiBQQ0lfRVhQX1NMVFNUQV9NUkxTQykKIAkJcGNpZWhwX2hh
bmRsZV9zd2l0Y2hfY2hhbmdlKHNsb3QpOwpAQCAtODEwLDEwICs4MzMsMTIgQEAgaW50IHBjaWVf
ZW5hYmxlX25vdGlmaWNhdGlvbihzdHJ1Y3QgY29udAogCQljbWQgfD0gUENJX0VYUF9TTFRDVExf
TVJMU0NFOwogCWlmICghcGNpZWhwX3BvbGxfbW9kZSkKIAkJY21kIHw9IFBDSV9FWFBfU0xUQ1RM
X0hQSUUgfCBQQ0lfRVhQX1NMVENUTF9DQ0lFOworCWNtZCB8PSBQQ0lfRVhQX1NMVENUTF9ETExT
Q0U7CiAKIAltYXNrID0gKFBDSV9FWFBfU0xUQ1RMX1BEQ0UgfCBQQ0lfRVhQX1NMVENUTF9BQlBF
IHwKIAkJUENJX0VYUF9TTFRDVExfTVJMU0NFIHwgUENJX0VYUF9TTFRDVExfUEZERSB8Ci0JCVBD
SV9FWFBfU0xUQ1RMX0hQSUUgfCBQQ0lfRVhQX1NMVENUTF9DQ0lFKTsKKwkJUENJX0VYUF9TTFRD
VExfSFBJRSB8IFBDSV9FWFBfU0xUQ1RMX0NDSUUgfAorCQlQQ0lfRVhQX1NMVENUTF9ETExTQ0Up
OwogCiAJaWYgKHBjaWVfd3JpdGVfY21kKGN0cmwsIGNtZCwgbWFzaykpIHsKIAkJY3RybF9lcnIo
Y3RybCwgIkNhbm5vdCBlbmFibGUgc29mdHdhcmUgbm90aWZpY2F0aW9uXG4iKTsK
--047d7b10d1852269a904be12be45--
