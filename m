Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab2J3JiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:38:16 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:3867 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756558Ab2J3JiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:38:14 -0400
Message-ID: <1351589886.1339.24.camel@x61.thuisdomein>
Subject: [PATCH] USB: io_edgeport: remove unused variable
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Date: Tue, 30 Oct 2012 10:38:06 +0100
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Oct 2012 09:38:06.0073 (UTC) FILETIME=[43A87690:01CDB682]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 14:34 -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.6.5 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

A (harmless) unused variable warning was introduced in the 3.6.4
release. That variable was apparently missed when adapting an upstream
commit to context changes. I do not know whether the stable release
process allows for fixing trivial stuff like that. If it does, here's a
patch to remove this variable.


Paul Bolle
---
The stable commit 12ddc74e8e25107eda81aceb74e3311c1480b381
("USB: io_edgeport: fix port-data memory leak") left one variable
unused:
    drivers/usb/serial/io_edgeport.c: In function 'edge_release':
    drivers/usb/serial/io_edgeport.c:3155:6: warning: unused variable 'i' [-Wunused-variable]

Remove this unused variable.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/usb/serial/io_edgeport.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index dca27a5..6c22679 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -3152,7 +3152,6 @@ static void edge_disconnect(struct usb_serial *serial)
 static void edge_release(struct usb_serial *serial)
 {
 	struct edgeport_serial *edge_serial = usb_get_serial_data(serial);
-	int i;
 
 	dbg("%s", __func__);
 
-- 
1.7.11.7

