Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab2KFPVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:21:12 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:49806 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab2KFPVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:21:10 -0500
Date: Tue, 6 Nov 2012 10:21:01 -0500 (EST)
From: Tomas Hozza <thozza@redhat.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com
Cc: Olaf Hering <olaf@aepfle.de>, KY Srinivasan <kys@microsoft.com>
Message-ID: <165383498.7447465.1352215261695.JavaMail.root@redhat.com>
In-Reply-To: <456703059.7446523.1352215033661.JavaMail.root@redhat.com>
Subject: [PATCH] tools/hv/hv_kvp_daemon.c: Netlink source address validation
 allows DoS
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_7447463_91626241.1352215261693"
X-Originating-IP: [10.34.4.165]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_7447463_91626241.1352215261693
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi.

After discussion with KY Srinivasan and Olaf Hering I'm sending you
a patch for the HyperV KVP daemon distributed in linux kernel
"tools/hv/hv_kvp_daemon.c".

There is an issue in the current daemon source causing hyperv kvp daemon
to exit when it processes a spoofed Netlink packet which has been sent
from an untrusted local user.

This patch is fixing this, so now the Netlink messages with a non-zero
nl_pid source address are just ignored.


Regards,

Tomas Hozza
Associate Software Engineer
BaseOS - Brno, CZ

------=_Part_7447463_91626241.1352215261693
Content-Type: text/x-patch;
 name=0001-Netlink-source-address-validation-allows-DoS.patch
Content-Disposition: attachment;
 filename=0001-Netlink-source-address-validation-allows-DoS.patch
Content-Transfer-Encoding: base64

RnJvbSA2MTk5MDcyZjgxMzEwNTZlZmNlMjA4ZjA0ZTY5ODVkMWY5OTY4ZDhlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBUb21hcyBIb3p6YSA8dGhvenphQHJlZGhhdC5jb20+CkRhdGU6
IE1vbiwgNSBOb3YgMjAxMiAxMDowODoxNiArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIE5ldGxpbmsg
c291cmNlIGFkZHJlc3MgdmFsaWRhdGlvbiBhbGxvd3MgRG9TCgpUaGUgc291cmNlIGNvZGUgd2l0
aG91dCB0aGlzIHBhdGNoIGNhdXNlZCBoeXBlcnZrdnBkIHRvIGV4aXQgd2hlbiBpdCBwcm9jZXNz
ZWQKYSBzcG9vZmVkIE5ldGxpbmsgcGFja2V0IHdoaWNoIGhhcyBiZWVuIHNlbnQgZnJvbSBhbiB1
bnRydXN0ZWQgbG9jYWwgdXNlci4KTmV0bGluayBtZXNzYWdlcyB3aXRoIGEgbm9uLXplcm8gbmxf
cGlkIHNvdXJjZSBhZGRyZXNzIHNob3VsZCBqdXN0IGJlIGlnbm9yZWQuCi0tLQogdG9vbHMvaHYv
aHZfa3ZwX2RhZW1vbi5jIHwgOCArKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL3Rvb2xzL2h2L2h2X2t2cF9kYWVtb24u
YyBiL3Rvb2xzL2h2L2h2X2t2cF9kYWVtb24uYwppbmRleCAzZWEzYWYyLi43ZDc0NDk3IDEwMDc1
NQotLS0gYS90b29scy9odi9odl9rdnBfZGFlbW9uLmMKKysrIGIvdG9vbHMvaHYvaHZfa3ZwX2Rh
ZW1vbi5jCkBAIC0xNDc4LDEzICsxNDc4LDE5IEBAIGludCBtYWluKHZvaWQpCiAJCWxlbiA9IHJl
Y3Zmcm9tKGZkLCBrdnBfcmVjdl9idWZmZXIsIHNpemVvZihrdnBfcmVjdl9idWZmZXIpLCAwLAog
CQkJCWFkZHJfcCwgJmFkZHJfbCk7CiAKLQkJaWYgKGxlbiA8IDAgfHwgYWRkci5ubF9waWQpIHsK
KwkJaWYgKGxlbiA8IDApIHsKIAkJCXN5c2xvZyhMT0dfRVJSLCAicmVjdmZyb20gZmFpbGVkOyBw
aWQ6JXUgZXJyb3I6JWQgJXMiLAogCQkJCQlhZGRyLm5sX3BpZCwgZXJybm8sIHN0cmVycm9yKGVy
cm5vKSk7CiAJCQljbG9zZShmZCk7CiAJCQlyZXR1cm4gLTE7CiAJCX0KIAorCQlpZiAoYWRkci5u
bF9waWQpIHsKKwkJCXN5c2xvZyhMT0dfV0FSTklORywgIlJlY2VpdmVkIHBhY2tldCBmcm9tIHVu
dHJ1c3RlZCBwaWQ6JXUiLAorCQkJCQlhZGRyLm5sX3BpZCk7CisJCQljb250aW51ZTsKKwkJfQor
CiAJCWluY29taW5nX21zZyA9IChzdHJ1Y3Qgbmxtc2doZHIgKilrdnBfcmVjdl9idWZmZXI7CiAJ
CWluY29taW5nX2NuX21zZyA9IChzdHJ1Y3QgY25fbXNnICopTkxNU0dfREFUQShpbmNvbWluZ19t
c2cpOwogCQlodl9tc2cgPSAoc3RydWN0IGh2X2t2cF9tc2cgKilpbmNvbWluZ19jbl9tc2ctPmRh
dGE7Ci0tIAoxLjcuMTEuNwoK
------=_Part_7447463_91626241.1352215261693--
