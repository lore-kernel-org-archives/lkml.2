Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1ARSUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 13:20:55 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:42969 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab1ARSUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 13:20:54 -0500
X-Loopcount0: from 10.175.216.250
From: <Stuart_Hayes@Dell.com>
To: <Douglas_Warzecha@Dell.com>, <linux-kernel@vger.kernel.org>
Date: Tue, 18 Jan 2011 12:20:50 -0600
Subject: [PATCH] dcdbas: force SMI to happen when expected
Thread-Topic: [PATCH] dcdbas: force SMI to happen when expected
Thread-Index: Acu3PG98MXpHU3c3RgShh8YfRATX4w==
Message-ID: <07E32F241046DA418A0381C1225BFC011A453F262B@AUSX7MCPS301.AMER.DELL.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_07E32F241046DA418A0381C1225BFC011A453F262BAUSX7MCPS301A_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_07E32F241046DA418A0381C1225BFC011A453F262BAUSX7MCPS301A_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

The dcdbas driver can do an I/O write to cause a SMI to occur.  On some sys=
tems I/O writes are posted in the chipset and don't complete immediately.  =
This can result in the SMI happening at a later time.  This can result in r=
andom failures since the SMI handler expects the EBX register to contain a =
pointer, and the handler can write to memory.

Performing an I/O read to the same address as the I/O write will force the =
I/O write to complete.  The patch is against the 2.6.37 kernel and has been=
 tested.

Signed-off-by: Stuart Hayes <stuart_hayes@dell.com>



--_002_07E32F241046DA418A0381C1225BFC011A453F262BAUSX7MCPS301A_
Content-Type: application/octet-stream; name="dcdbas_37_smiread.patch"
Content-Description: dcdbas_37_smiread.patch
Content-Disposition: attachment; filename="dcdbas_37_smiread.patch"; size=520;
	creation-date="Tue, 18 Jan 2011 11:58:11 GMT";
	modification-date="Tue, 18 Jan 2011 11:58:11 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcHVyTiBsaW51eC0yLjYuMzcvZHJpdmVycy9maXJtd2FyZS9kY2RiYXMuYyBsaW51eC0y
LjYuMzdfdGVzdC9kcml2ZXJzL2Zpcm13YXJlL2RjZGJhcy5jCi0tLSBsaW51eC0yLjYuMzcvZHJp
dmVycy9maXJtd2FyZS9kY2RiYXMuYwkyMDExLTAxLTE4IDEwOjQ0OjQ0Ljg2OTg4MjQ2MSAtMDUw
MAorKysgbGludXgtMi42LjM3X3Rlc3QvZHJpdmVycy9maXJtd2FyZS9kY2RiYXMuYwkyMDExLTAx
LTE4IDEwOjQxOjE1LjQwNDYxMjE1NCAtMDUwMApAQCAtMjc4LDYgKzI3OCw5IEBAIGludCBkY2Ri
YXNfc21pX3JlcXVlc3Qoc3RydWN0IHNtaV9jbWQgKnMKIAkJOiAibWVtb3J5IgogCSk7CiAKKwkv
KiByZWFkIHRvIGZvcmNlIHBvc3RlZCB3cml0ZSB0aHJvdWdoIGFuZCBtYWtlIFNNSSBoYXBwZW4g
bm93ICovCisJaW5iKHNtaV9jbWQtPmNvbW1hbmRfYWRkcmVzcyk7CisKIG91dDoKIAlzZXRfY3B1
c19hbGxvd2VkX3B0cihjdXJyZW50LCBvbGRfbWFzayk7CiAJZnJlZV9jcHVtYXNrX3ZhcihvbGRf
bWFzayk7Cg==

--_002_07E32F241046DA418A0381C1225BFC011A453F262BAUSX7MCPS301A_--
