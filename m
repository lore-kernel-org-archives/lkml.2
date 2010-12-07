Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0LGHnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 02:43:50 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4866 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab0LGHnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 02:43:49 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Jian Peng" <jipeng@broadcom.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: "jgarzik@pobox.com" <jgarzik@pobox.com>
Date: Mon, 6 Dec 2010 23:43:43 -0800
Subject: questions regarding possible violation of AHCI spec in AHCI
 driver
Thread-Topic: questions regarding possible violation of AHCI spec in
 AHCI driver
Thread-Index: AcuV4neL55u3vo0mTRmA18bedb+1gQ==
Message-ID: <E18F441196CA634DB8E1F1C56A50A874319F70C1F2@IRVEXCHCCR01.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 60E33A453P036371173-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, while bringing up a new AHCI host controller, I found out that current AHCI driver (in 2.6.37-rc3) may violate AHCI spec in function libahci.c: ahci_start_engine().

>From end of section 10.1.2 in AHCI 1.3 spec, it claims

Software shall not set PxCMD.ST to '1' until it is determined that a functional device is present on the port
as determined by PxTFD.STS.BSY = '0', PxTFD.STS.DRQ = '0', and PxSSTS.DET = 3h.

It seems working well on most controller without this extra checking, but does cause problem in our new core. Since toggling PxCMD.SUD already initiated reset process at early time, and by the time of ahci_start_engine() got called, BSY bit may not be cleared yet, and forcing PxCMD.ST bit to 1 will cause problem for HW in this case.

Since I do not know all history about AHCI driver, I really hope that AHCI driver and libata maintainer can comment on this.

Thanks,
Jian

