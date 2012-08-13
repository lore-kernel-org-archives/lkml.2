Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2HMWRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:17:54 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59891 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab2HMWRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:17:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tony Luck <tony.luck@intel.com>, Theodore Tso <tytso@mit.edu>
Subject: [ 43/65] dmi: Feed DMI table to /dev/random driver
Date: Mon, 13 Aug 2012 15:14:27 -0700
Message-Id: <20120813221418.775428333@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813221414.965154048@linuxfoundation.org>
References: <20120813221414.965154048@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit d114a33387472555188f142ed8e98acdb8181c6d upstream.

Send the entire DMI (SMBIOS) table to the /dev/random driver to
help seed its pools.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/dmi_scan.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -6,6 +6,7 @@
 #include <linux/dmi.h>
 #include <linux/efi.h>
 #include <linux/bootmem.h>
+#include <linux/random.h>
 #include <asm/dmi.h>
 
 /*
@@ -111,6 +112,8 @@ static int __init dmi_walk_early(void (*
 
 	dmi_table(buf, dmi_len, dmi_num, decode, NULL);
 
+	add_device_randomness(buf, dmi_len);
+
 	dmi_iounmap(buf, dmi_len);
 	return 0;
 }


