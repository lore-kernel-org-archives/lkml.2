Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992755Ab2K3S4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:56:36 -0500
Received: from mail.kernel.org ([198.145.19.201]:58465 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992616Ab2K3S4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 07/56] scsi: aha152x: Fix sparse warning and make printing pointer address more portable.
Date: Fri, 30 Nov 2012 10:54:59 -0800
Message-Id: <20121130185119.083991003@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>

commit b631cf1f899f9d2e449884dbccc34940637c639f upstream.

This is to change use of "0x%08x" in favour of "%p" as per ../Documentation/printk-formats.txt,
which also takes care about the following warning during compilation time:

  drivers/scsi/aha152x.c: In function ‘get_command’:
  drivers/scsi/aha152x.c:2987: warning: cast from pointer to integer of different size

Signed-off-by: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/aha152x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -2984,8 +2984,8 @@ static int get_command(char *pos, Scsi_C
 	char *start = pos;
 	int i;
 
-	SPRINTF("0x%08x: target=%d; lun=%d; cmnd=( ",
-		(unsigned int) ptr, ptr->device->id, ptr->device->lun);
+	SPRINTF("%p: target=%d; lun=%d; cmnd=( ",
+		ptr, ptr->device->id, ptr->device->lun);
 
 	for (i = 0; i < COMMAND_SIZE(ptr->cmnd[0]); i++)
 		SPRINTF("0x%02x ", ptr->cmnd[i]);


