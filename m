Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab2FDSOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 14:14:43 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:46161 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2FDSOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 14:14:42 -0400
Date: Mon, 04 Jun 2012 14:14:41 -0400 (EDT)
From: Jaromir Capik <jcapik@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] EHCI controller timeouts experienced on the SoC Vortex86XD board during the bootup
Message-ID: <dc1f38b6-0fcb-4d05-98ed-9821c89f41fe@zmail15.collab.prod.int.phx2.redhat.com>
In-Reply-To: <ae01bacf-42f2-4036-92c9-fb5622537ca0@zmail15.collab.prod.int.phx2.redhat.com>
Content-Type: multipart/mixed;
 boundary="=_a310ea60-762a-45f8-9ebd-a19101849a0e"
MIME-Version: 1.0
X-Originating-IP: [10.34.0.105]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=_a310ea60-762a-45f8-9ebd-a19101849a0e
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello guys.

As ehci-pci.c was previously maintained by David Brownell,
I'm searching for anyone who could merge the attached patch
I received from a friend of mine, who experienced
EHCI timeouts (error -110) on the SoC Vortex86XD board
during the bootup.
The problem doesn't appear on a regular basis (just sometimes
during the boot). He was trying almost everything in order
to make it work (including playing with kernel parameters),
but without success.
Jan Barinka (author of the patch) says, that the EHCI controller
is asked to be halted during the startup and should confirm that
by setting a corresponding flag, but sometimes that doesn't
happen and the operation times out. The controller then doesn't
work at all. Jan tried to set the timeout to 10 minutes,
but that didn't help either.
His patch resets the controller right before issuing
the halt command even if the device reset is not recommended
when the device might be running, but the issue disappeared
completely in his case.

Please, let me know if anyone could take care of the issue
and check the patch. Any questions are welcome.

Thank you.

Regards,
Jaromir.

--
Jaromir Capik
Red Hat Czech, s.r.o.
Software Engineer / BaseOS

Email: jcapik@redhat.com
Web: www.cz.redhat.com
Red Hat Czech s.r.o., Purkynova 99/71, 612 45, Brno, Czech Republic
IC: 27690016 



--=_a310ea60-762a-45f8-9ebd-a19101849a0e
Content-Type: text/x-patch; name=kernel-3.2.9-rdc-usb-ehci.patch
Content-Disposition: attachment; filename=kernel-3.2.9-rdc-usb-ehci.patch
Content-Transfer-Encoding: base64

LS0tIGxpbnV4LTMuMi45L2RyaXZlcnMvdXNiL2hvc3QvZWhjaS1wY2kuYwkyMDEyLTAzLTAxIDAx
OjMyOjQ5LjAwMDAwMDAwMCArMDEwMAorKysgbGludXgtMy4yLjktdXNiLXBhdGNoL2RyaXZlcnMv
dXNiL2hvc3QvZWhjaS1wY2kuYwkyMDEyLTAzLTA1IDAzOjA0OjQ2LjAwMDAwMDAwMCArMDEwMApA
QCAtOTcsNiArOTcsMjQgQEAKIAkJCWJyZWFrOwogCQl9CiAJCWJyZWFrOworCisJLyogUkRDIFVT
QiAyLjAgZGV2aWNlIDB4NjA2MSBvbiBWb3J0ZXggU29jIERYIGJvYXJkIHNvbWV0aW1lcworCSAq
IHRpbWVkIG91dCBvbiBoYWx0IGNvbW1hbmQuIFJlc2V0aW5nIGNvbnRyb2xsZXIgYmVmb3JlIGhh
bHQgY29tbWFuZAorCSAqIGhlbHBlZC4KKyAgICAgICAgICoKKyAgICAgICAgICogVHJhZGUgRmlk
ZXMgKEptSikgNy4zLjIwMTIKKyAgICAgICAgICovCisJY2FzZSBQQ0lfVkVORE9SX0lEX1JEQzoK
KwkJZWhjaV9pbmZvKGVoY2ksCisJCQkiUkRDIFNlbWljb25kdWN0b3Igd29ya2Fyb3VuZCAtIGNh
bGxpbmcgcmVzZXQgYmVmb3JlIGhhbHRpbmdcbiIpOworICAgICAgICAgICAgICAgIHJldHZhbCA9
IGVoY2lfcmVzZXQoZWhjaSk7CisgICAgICAgICAgICAgICAgaWYgKHJldHZhbCkKKwkJeworCQkJ
ZWhjaV93YXJuKGVoY2ksICJSREMgcmVzZXQgd29ya2Fyb3VuZCBmYWlsZWRcbiIpOworCQkJcmV0
dXJuIHJldHZhbDsKKwkJfQorCQlicmVhazsKKwogCX0KIAogCS8qIGNhY2hlIHRoaXMgcmVhZG9u
bHkgZGF0YTsgbWluaW1pemUgY2hpcCByZWFkcyAqLwpAQCAtMTA0LDcgKzEyMiwxMCBAQAogCiAJ
cmV0dmFsID0gZWhjaV9oYWx0KGVoY2kpOwogCWlmIChyZXR2YWwpCisJeworCQllaGNpX3dhcm4o
ZWhjaSwgIlVTQiBjb250cm9sbGVyIGhhbHQgZmFpbGVkXG4iKTsKIAkJcmV0dXJuIHJldHZhbDsK
Kwl9CiAKIAlpZiAoKHBkZXYtPnZlbmRvciA9PSBQQ0lfVkVORE9SX0lEX0FNRCAmJiBwZGV2LT5k
ZXZpY2UgPT0gMHg3ODA4KSB8fAogCSAgICAocGRldi0+dmVuZG9yID09IFBDSV9WRU5ET1JfSURf
QVRJICYmIHBkZXYtPmRldmljZSA9PSAweDQzOTYpKSB7Cg==

--=_a310ea60-762a-45f8-9ebd-a19101849a0e--
