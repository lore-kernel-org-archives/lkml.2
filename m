Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab0CaAha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:37:30 -0400
Received: from kroah.org ([198.145.64.141]:48560 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913Ab0C3XJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:14 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:50:00 2010
Message-Id: <20100330225000.417844559@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Buesch <mb@bu3sch.de>, Helge Deller <deller@gmx.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [31/45] parisc: isa-eeprom - Fix loff_t usage
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Buesch <mb@bu3sch.de>

commit 6b4dbcd86a9d464057fcc7abe4d0574093071fcc upstream.

loff_t is a signed type. If userspace passes a negative ppos, the "count"
range check is weakened. "count"s bigger than HPEE_MAX_LENGTH will pass the check.
Also, if ppos is negative, the readb(eisa_eeprom_addr + *ppos) will poke in random
memory.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/parisc/eisa_eeprom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/parisc/eisa_eeprom.c
+++ b/drivers/parisc/eisa_eeprom.c
@@ -55,7 +55,7 @@ static ssize_t eisa_eeprom_read(struct f
 	ssize_t ret;
 	int i;
 	
-	if (*ppos >= HPEE_MAX_LENGTH)
+	if (*ppos < 0 || *ppos >= HPEE_MAX_LENGTH)
 		return 0;
 	
 	count = *ppos + count < HPEE_MAX_LENGTH ? count : HPEE_MAX_LENGTH - *ppos;


