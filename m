Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885Ab2C3VMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:12:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935830Ab2C3VMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:12:43 -0400
Message-Id: <20120330194850.981900891@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 077/149] target: Dont set WBUS16 or SYNC bits in INQUIRY response
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit effc6cc8828257c32c37635e737f14fd6e19ecd7 upstream.

SPC-4 says about the WBUS16 and SYNC bits:

    The meanings of these fields are specific to SPI-5 (see 6.4.3).
    For SCSI transport protocols other than the SCSI Parallel
    Interface, these fields are reserved.

We don't have a SPI fabric module, so we should never set these bits.
(The comment was misleading, since it only mentioned Sync but the
actual code set WBUS16 too).

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_cdb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -116,7 +116,7 @@ target_emulate_inquiry_std(struct se_cmd
 		goto out;
 	}
 
-	buf[7] = 0x32; /* Sync=1 and CmdQue=1 */
+	buf[7] = 0x2; /* CmdQue=1 */
 
 	/*
 	 * Do not include vendor, product, reversion info in INQUIRY


