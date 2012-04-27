Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab2D0VKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:10:25 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:17675 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab2D0VKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:10:22 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-127.messagelabs.com!1335561016!4190230!16
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] staging: comedi: introduce 'comedi_board' helper function
Date: Fri, 27 Apr 2012 14:10:15 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271410.15793.hartleys@visionengravers.com>
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

V2: change name

With this helper removing all the 'this_board' defines in the drivers
will be easier (and cleaner).

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 300fd84..02e4ae0 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -235,6 +235,11 @@ struct comedi_device {
 	void (*close) (struct comedi_device *dev);
 };
 
+static inline const void *comedi_board(struct comedi_device *dev)
+{
+	return dev->board_ptr;
+}
+
 struct comedi_device_file_info {
 	struct comedi_device *device;
 	struct comedi_subdevice *read_subdevice;
