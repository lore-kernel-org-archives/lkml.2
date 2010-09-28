Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573Ab0I1JWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 05:22:13 -0400
Received: from dhruva1.ncra.tifr.res.in ([158.144.12.129]:36730 "EHLO
	dhruva1.ncra.tifr.res.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab0I1JWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 05:22:11 -0400
From: "Raju Rameshwar Uprade" <rajsingh@ncra.tifr.res.in>
To: Greg KH <gregkh@suse.de>,
        Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Regarding USB-to-serial device driver
Date: Tue, 28 Sep 2010 14:51:57 +0530
Message-Id: <20100928091520.M79654@admin-gateway.ncra.tifr.res.in>
In-Reply-To: <20100923140236.GB31394@suse.de>
References: <20100913091318.M67834@admin-gateway.ncra.tifr.res.in> <20100913154843.GA27496@suse.de> <20100914060649.M96376@admin-gateway.ncra.tifr.res.in> <20100914131925.GC375@suse.de> <20100922052107.M44650@admin-gateway.ncra.tifr.res.in> <20100922145607.GB26309@suse.de> <20100923100127.M64470@admin-gateway.ncra.tifr.res.in> <20100923140236.GB31394@suse.de>
X-Mailer: OpenWebMail 2.53 (08:Aug:2008)
X-OriginatingIP: 158.144.12.129
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,
 
      I am using pl2303.c ( USB to serial device driver ) to communicate to various
devices connected in parallel using RS-485 interface card.

I am now able to separate the Address byte and data bytes.Driver send the Address byte
properly but when it tries to send the data bytes following error occurs,

pl2303_mcm ttyUSB0: pl2303_write - failed submitting write urb, error -22.

I have also attached the kernel log.

/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: pl2303_write before any thing - port 0, 9
bytes 
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: set_control_lines - value = 3, retval = 0
 
 Data in The BUF 0 is -----> 02 
 
 Data in The BUF 1 is -----> 08 
 
 Data in The BUF 2 is -----> 00 
 
 Data in The BUF 3 is -----> 00 
 
 Data in The BUF 4 is -----> 00 
 
 Data in The BUF 5 is -----> 00 
 
 Data in The BUF 6 is -----> 00 
 
 Data in The BUF 7 is -----> 00 
 
 Data in The BUF 8 is -----> f8 
pl2303_mcm ttyUSB0: pl2303_write - length = 1, data = 02 
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: After the first urb submission count =  9
and length = 8 
pl2303_mcm ttyUSB0: pl2303_write - length = 8, data = 08 00 00 00 00 00 00 f8 
pl2303_mcm ttyUSB0: pl2303_write - failed submitting write urb, error -22
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: pl2303_write_bulk_callback - port 0
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: set_control_lines - value = 0, retval = 0

Kindly help me.

Raj.

