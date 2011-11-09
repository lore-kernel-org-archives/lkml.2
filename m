Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034Ab1KJDh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:37:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935922Ab1KJDhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:37:47 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:45 2011
Message-Id: <20111109213144.918609156@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Andrei Warkentin <andrey.warkentin@gmail.com>,
        Philip Rakity <prakity@marvell.com>, Chris Ball <cjb@laptop.org>
Subject: [028/264] mmc: core: ext_csd.raw_* used in comparison but never set
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Warkentin <andrey.warkentin@gmail.com>

commit 5238acbe36dd5100fb6b035a995ae5fc89dd0708 upstream.

f39b2dd9d ("mmc: core: Bus width testing needs to handle suspend/resume")
added code to only compare read-only ext_csd fields in bus width testing
code, yet it's comparing some fields that are never set.

The affected fields are ext_csd.raw_erased_mem_count and
ext_csd.raw_partition_support.

Signed-off-by: Andrei Warkentin <andrey.warkentin@gmail.com>
Acked-by: Philip Rakity <prakity@marvell.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/core/mmc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -359,6 +359,7 @@ static int mmc_read_ext_csd(struct mmc_c
 		 * card has the Enhanced area enabled.  If so, export enhanced
 		 * area offset and size to user by adding sysfs interface.
 		 */
+		card->ext_csd.raw_partition_support = ext_csd[EXT_CSD_PARTITION_SUPPORT];
 		if ((ext_csd[EXT_CSD_PARTITION_SUPPORT] & 0x2) &&
 		    (ext_csd[EXT_CSD_PARTITION_ATTRIBUTE] & 0x1)) {
 			u8 hc_erase_grp_sz =
@@ -405,6 +406,7 @@ static int mmc_read_ext_csd(struct mmc_c
 	if (card->ext_csd.rev >= 5)
 		card->ext_csd.rel_param = ext_csd[EXT_CSD_WR_REL_PARAM];
 
+	card->ext_csd.raw_erased_mem_count = ext_csd[EXT_CSD_ERASED_MEM_CONT];
 	if (ext_csd[EXT_CSD_ERASED_MEM_CONT])
 		card->erased_byte = 0xFF;
 	else


