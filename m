Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab0KHG3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 01:29:49 -0500
Received: from nm19.bullet.mail.ukl.yahoo.com ([217.146.183.193]:47708 "HELO
	nm19.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751633Ab0KHG3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 01:29:47 -0500
X-Yahoo-Newman-Id: 740093.69906.bm@omp1020.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=DKIM-Signature:Message-ID:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Cc:Subject;
  b=gNJyVcPzN108xAQmrff7HEkzMrsauN8YY1eRGVfxSxJuD2EqBtKgbJsjrPsZMHoWcOeYy7e/dKqLbjavgYfHQy/fxlPDvg/wKTQ1ylalEtjzhLdm6zH/Z3xTCSVHZ+2i9Npt5yefShqiaheXMeWxFtA58HjS1OxVILaYiwi+mog=  ;
Message-ID: <684104.78681.qm@smtp127.mail.ukl.yahoo.com>
X-Yahoo-SMTP: zgdcvJ6swBBcTOk5fgveL37ak9AQxYCP7GdO
X-YMail-OSG: UnzweHIVM1lTXBIXMQz2luieVcuqKBLhw.NiOO1Y27STBIR
 WeffYLcWcORuf5KP7D_NjsQJtEZvD7NHlm6FB1fGlJTXLjOh8zzj6h5CBF70
 3vtXwtDuytpYp5lDPmJy_XcIuECz_ed6cfOPAiIAPMn62G0VBfEucmLubfAi
 C1U_7PLTqsjv6QX8OdtpeR9S_6AJHfqf.PtUKkvyBMF.M7PHXgNbNUqU1Oqe
 8effSpsrpTyt6PVS53pjULxUTpj2yrKoQhh.rjqwEAp917X.jnMwppwARtdZ
 b8jQl3YIfm4BfFe6Oit1OtKBoLbgPzw.OmgmhpOTXTeWRxRTAh3uDaLQJq6n
 UAJmv.EQk
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 08 Nov 2010 07:29:55 +0100
From: Lionel Debroux <lionel_debroux@yahoo.fr>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/checkpatch.pl: add ata_port_operations to the list of ops that ought to be const.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch against mainline.

---

Subject: [PATCH] scripts/checkpatch.pl: add ata_port_operations to the list of ops that ought to be const.

I noticed that many ata_port_operations instances are constified
by the grsecurity patch, so it may be desirable to reduce the
introduction of non-const instances through checkpatch.pl.

Signed-off-by: Lionel Debroux <lionel_debroux@yahoo.fr>
---
 scripts/checkpatch.pl |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e3c7fc0..33fab2e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2810,6 +2810,7 @@ sub process {
 # check for various ops structs, ensure they are const.
 		my $struct_ops = qr{acpi_dock_ops|
 				address_space_operations|
+				ata_port_operations|
 				backlight_ops|
 				block_device_operations|
 				dentry_operations|
-- 
1.7.3.2.161.g3089c
