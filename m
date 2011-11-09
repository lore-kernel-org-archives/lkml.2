Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966181Ab1KJDt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:49:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966155Ab1KJDtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:49:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:07 2011
Message-Id: <20111109213207.393097704@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andres Salomon <dilinger@queued.net>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [247/264] mtd: provide an alias for the redboot module name
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andres Salomon <dilinger@queued.net>

commit d5de1907d0af22e1a02de2b16a624148517a39c2 upstream.

parse_mtd_partitions takes a list of partition types; if the driver
isn't loaded, it attempts to load it, and then it grabs the partition
parser.  For redboot, the module name is "redboot.ko", while the parser
name is "RedBoot".  Since modprobe is case-sensitive, attempting to
modprobe "RedBoot" will never work.  I suspect the embedded systems that
make use of redboot just always manually loaded redboot prior to loading
their specific nand chip drivers (or statically compiled it in).

Signed-off-by: Andres Salomon <dilinger@queued.net>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/redboot.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/redboot.c
+++ b/drivers/mtd/redboot.c
@@ -297,6 +297,9 @@ static struct mtd_part_parser redboot_pa
 	.name = "RedBoot",
 };
 
+/* mtd parsers will request the module by parser name */
+MODULE_ALIAS("RedBoot");
+
 static int __init redboot_parser_init(void)
 {
 	return register_mtd_parser(&redboot_parser);


