Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761216Ab2D0SuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:50:04 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:64786 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912Ab2D0SuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:50:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1335552489!4964891!106
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: introduce 'comedi_get_board' helper function
Date: Fri, 27 Apr 2012 11:49:48 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271149.49035.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helper function is used to fetch the comedi_device board_ptr
which is used during the attach to pass board specific information
to the comedi drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

With this helper removing all the 'this_board' defines in the drivers
will be easier (and cleaner).

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 300fd84..53a05dd 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -235,6 +235,11 @@ struct comedi_device {
 	void (*close) (struct comedi_device *dev);
 };
 
+static inline const void *comedi_get_board(struct comedi_device *dev)
+{
+	return dev->board_ptr;
+}
+
 struct comedi_device_file_info {
 	struct comedi_device *device;
 	struct comedi_subdevice *read_subdevice;
