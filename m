Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab0INFPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 01:15:17 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:57145 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab0INFPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 01:15:14 -0400
Message-ID: <4C8F04DC.5060303@xs4all.nl>
Date: Tue, 14 Sep 2010 07:15:08 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: patch: HPET force enable for CX700 / VIA Epia LT  was: Re: hpet timers
 gone?
References: <4BFA52C3.4080006@xs4all.nl>	<20100526120236.4a849b5b.randy.dunlap@oracle.com>	<4C021507.6020703@xs4all.nl>	<4C02B3AB.3040405@gmail.com>	<4C0324B8.8070304@xs4all.nl>	<AANLkTikuaPxA9Xnzc1bCJ5YHRlPZ1AcBSrYJ5lqryaMY@mail.gmail.com>	<4C8E3ABF.90309@xs4all.nl> <AANLkTintq=gXvFC9BW_cv=MSqBWHCx7SD9o1CWHOYTsj@mail.gmail.com>
In-Reply-To: <AANLkTintq=gXvFC9BW_cv=MSqBWHCx7SD9o1CWHOYTsj@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------010401030007070906090905"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010401030007070906090905
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 2010-09-14 01:16, Robert Hancock wrote:
> On Mon, Sep 13, 2010 at 8:52 AM, Udo van den Heuvel <udovdh@xs4all.nl> wrote:
>> So what else can I do to enable HPET?
> 
> At this point, not much, unless you can track down the chipset
> information that would allow us to implement force enabling HPET on
> that chipset..

Signed-off-by: Udo van den Heuvel <udovdh@xs4all.nl>

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

Patch does make hpet appear on VIA Epia LT (CX700M2 chipset) with
hpet=force on kernel commandline.


Udo

--------------010401030007070906090905
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

--------------010401030007070906090905--
