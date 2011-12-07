Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783Ab1LGQZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:25:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757517Ab1LGQZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:25:05 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:20 2011
Message-Id: <20111207161219.967661710@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:05 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, wwang <wei_wang@realsil.com.cn>
Subject: [063/104] staging:rts_pstor:Complete scanning_done variable
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wwang <wei_wang@realsil.com.cn>

commit f7364ba04b0961f3a1f978bbe77102606801e35f upstream.

Complete scanning_done variable if rtsx-scan thread created failed.

Signed-off-by: wwang <wei_wang@realsil.com.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rts_pstor/rtsx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rts_pstor/rtsx.c
+++ b/drivers/staging/rts_pstor/rtsx.c
@@ -1015,6 +1015,7 @@ static int __devinit rtsx_probe(struct p
 	th = kthread_create(rtsx_scan_thread, dev, "rtsx-scan");
 	if (IS_ERR(th)) {
 		printk(KERN_ERR "Unable to start the device-scanning thread\n");
+		complete(&dev->scanning_done);
 		quiesce_and_remove_host(dev);
 		err = PTR_ERR(th);
 		goto errout;


