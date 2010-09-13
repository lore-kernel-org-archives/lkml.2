Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0IMQFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:05:18 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:38163 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab0IMQFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:05:17 -0400
Message-ID: <4C8E4BBA.3080806@xs4all.nl>
Date: Mon, 13 Sep 2010 18:05:14 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: hpet timers gone?
References: <4BFA52C3.4080006@xs4all.nl>	<20100526120236.4a849b5b.randy.dunlap@oracle.com>	<4C021507.6020703@xs4all.nl>	<4C02B3AB.3040405@gmail.com>	<4C0324B8.8070304@xs4all.nl> <AANLkTikuaPxA9Xnzc1bCJ5YHRlPZ1AcBSrYJ5lqryaMY@mail.gmail.com> <4C8E3ABF.90309@xs4all.nl> <4C8E437B.1060103@xs4all.nl>
In-Reply-To: <4C8E437B.1060103@xs4all.nl>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------060907020100030703060007"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060907020100030703060007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 2010-09-13 17:30, Udo van den Heuvel wrote:
> Or should blindly enabling HPET (as in VT8237) help?

The attached patch does indeed enable HPEt on VIA Epia LT.

Kind regards,
Udo

--------------060907020100030703060007
Content-Type: text/plain;
 name="hpet-c700.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hpet-c700.patch"

--- a/arch/x86/kernel/quirks.c	2010-09-13 18:02:14.639710309 +0200
+++ b/arch/x86/kernel/quirks.c	2010-09-13 18:02:06.095280815 +0200
@@ -344,6 +344,8 @@
 			 vt8237_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8237,
 			 vt8237_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_CX700,
+			 vt8237_force_enable_hpet);
 
 static void ati_force_hpet_resume(void)
 {

--------------060907020100030703060007--
