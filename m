Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935616Ab1KJEtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:49:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935507Ab1KJDct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:32:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:24 2011
Message-Id: <20111109212724.243286864@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:29:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tony Luck <tony.luck@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [235/262] ACPI atomicio: Convert width in bits to bytes in __acpi_ioremap_fast()
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Luck, Tony" <tony.luck@intel.com>

commit 3bf3f8b19d2bfccc40f13c456bf339fd8f535ebc upstream.

Callers to __acpi_ioremap_fast() pass the bit_width that they found in the
acpi_generic_address structure. Convert from bits to bytes when passing to
__acpi_find_iomap() - as it wants to see bytes, not bits.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/atomicio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/atomicio.c
+++ b/drivers/acpi/atomicio.c
@@ -76,7 +76,7 @@ static void __iomem *__acpi_ioremap_fast
 {
 	struct acpi_iomap *map;
 
-	map = __acpi_find_iomap(paddr, size);
+	map = __acpi_find_iomap(paddr, size/8);
 	if (map)
 		return map->vaddr + (paddr - map->paddr);
 	else


