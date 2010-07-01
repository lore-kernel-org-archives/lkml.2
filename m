Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515Ab0GAW1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:27:15 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49366 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab0GAW1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:27:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=II6tWZBWl/WHrxdsRf4S/TKi7wLadJn4i5JHcmvOL7HsYbGMX/TuZKsUQR1m2/cDZi
         g4jrtJLTXbCym0Bv1qCC49pZh9vD+tiJS6BnUkJ2eF3hX+D+myUPQQf9zOBuR7k9ycOC
         q2/I8G6YXSAF+JH06q5LUAUXE/HSE84k/+8oM=
MIME-Version: 1.0
Date: Thu, 1 Jul 2010 23:27:11 +0100
Message-ID: <AANLkTik0ApmWdPB_m2iejwa2zr7KnEyv8Eh8Z4-CPwd5@mail.gmail.com>
Subject: [2.6.35-rc3] correct console log level when ERST ACPI table is not 
	found
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting 2.6.35-rc3 on a x86 system without an ERST ACPI table
with the 'quiet' option, we still observe an "ERST: Table is not
found!" warning.

Quiesce it to the same info log level as the other 'table not found' warnings.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 2ebc391..864dd46 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -781,7 +781,7 @@ static int __init erst_init(void)
 	status = acpi_get_table(ACPI_SIG_ERST, 0,
 				(struct acpi_table_header **)&erst_tab);
 	if (status == AE_NOT_FOUND) {
-		pr_err(ERST_PFX "Table is not found!\n");
+		pr_info(ERST_PFX "Table is not found!\n");
 		goto err;
 	} else if (ACPI_FAILURE(status)) {
 		const char *msg = acpi_format_exception(status);
-- 
Daniel J Blueman
