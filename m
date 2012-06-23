Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab2FWQOu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 12:14:50 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:39754 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab2FWQOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 12:14:49 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jun 2012 12:14:49 EDT
MIME-Version: 1.0
Date: Sat, 23 Jun 2012 09:06:38 -0700
Message-ID: <CAMe9rOqPfy3JcZRLaUeCjBe9BVY-P6e0uaSbMi5hvS-6WwQueg@mail.gmail.com>
Subject: PATCH] Use -mpreferred-stack-boundary=3 on x86-64 if supported
From: "H.J. Lu" <hjl.tools@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: multipart/mixed; boundary=00248c768dc604985a04c325eff9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00248c768dc604985a04c325eff9
Content-Type: text/plain; charset=ISO-8859-1

Hi,

-mpreferred-stack-boundary=3 can be used on x86-64 with GCC 4.8.0:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=53383

I backported it to hjl/x32/gcc-4_7-branch branch at

http://gcc.gnu.org/git/?p=gcc.git;a=summary

http://gcc.gnu.org/git/?p=gcc.git;a=commit;h=96828b1f869a31e3a1227afa420b8f28e71
e006c

This patch uses -mpreferred-stack-boundary=3 on x86-64 if it is supported.
I have been running 3.4 kernel compiled with this option for weeks.


H.J.

--00248c768dc604985a04c325eff9
Content-Type: application/octet-stream; 
	name="0001-Use-mpreferred-stack-boundary-3-if-supported.patch"
Content-Disposition: attachment; 
	filename="0001-Use-mpreferred-stack-boundary-3-if-supported.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h3svse7i0

RnJvbSA1ZTA2NzM3NmU3M2ZlM2JmODZiNzFjMjU2MGUwM2M1ZDM1YTdiNTM3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiAiSC5KLiBMdSIgPGhqbC50b29sc0BnbWFpbC5jb20+CkRhdGU6
IFR1ZSwgMjkgTWF5IDIwMTIgMTQ6MzE6MjMgLTA3MDAKU3ViamVjdDogW1BBVENIXSBVc2UgLW1w
cmVmZXJyZWQtc3RhY2stYm91bmRhcnk9MyBpZiBzdXBwb3J0ZWQKCgpTaWduZWQtb2ZmLWJ5OiBI
LkouIEx1IDxoamwudG9vbHNAZ21haWwuY29tPgotLS0KIGFyY2gveDg2L01ha2VmaWxlIHwgICAg
MyArKysKIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9NYWtlZmlsZSBiL2FyY2gveDg2L01ha2VmaWxlCmluZGV4IDk0ZTkxZTQuLmNkNGE0Zjcg
MTAwNjQ0Ci0tLSBhL2FyY2gveDg2L01ha2VmaWxlCisrKyBiL2FyY2gveDg2L01ha2VmaWxlCkBA
IC00OSw2ICs0OSw5IEBAIGVsc2UKICAgICAgICAgS0JVSUxEX0FGTEFHUyArPSAtbTY0CiAgICAg
ICAgIEtCVUlMRF9DRkxBR1MgKz0gLW02NAogCisJIyBVc2UgLW1wcmVmZXJyZWQtc3RhY2stYm91
bmRhcnk9MyBpZiBzdXBwb3J0ZWQuCisJS0JVSUxEX0NGTEFHUyArPSAkKGNhbGwgY2Mtb3B0aW9u
LC1tbm8tc3NlIC1tcHJlZmVycmVkLXN0YWNrLWJvdW5kYXJ5PTMpCisKICAgICAgICAgIyBGSVhN
RSAtIHNob3VsZCBiZSBpbnRlZ3JhdGVkIGluIE1ha2VmaWxlLmNwdSAoTWFrZWZpbGVfMzIuY3B1
KQogICAgICAgICBjZmxhZ3MtJChDT05GSUdfTUs4KSArPSAkKGNhbGwgY2Mtb3B0aW9uLC1tYXJj
aD1rOCkKICAgICAgICAgY2ZsYWdzLSQoQ09ORklHX01QU0MpICs9ICQoY2FsbCBjYy1vcHRpb24s
LW1hcmNoPW5vY29uYSkKLS0gCjEuNy4xMC4yCgo=
--00248c768dc604985a04c325eff9--
