Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab0LHBig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:38:36 -0500
Received: from kroah.org ([198.145.64.141]:48924 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232Ab0LHBBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:04 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:33 2010
Message-Id: <20101208005733.270241846@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Hennerich <michael.hennerich@analog.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Chris Verges <chrisv@cyberswitching.com>
Subject: [119/289] drivers/misc/ad525x_dpot.c: fix typo in spi write16 and write24 transfer counts
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Hennerich <michael.hennerich@analog.com>

commit 1f9fa5216eacf4fdf9d3e4ab57feb8b642f0e78b upstream.

This is a bug fix.  Some SPI connected devices using 16/24 bit accesses,
previously failed, now work.

This typo slipped in after testing, during some restructuring.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Chris Verges <chrisv@cyberswitching.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/ad525x_dpot-spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/misc/ad525x_dpot-spi.c
+++ b/drivers/misc/ad525x_dpot-spi.c
@@ -53,13 +53,13 @@ static int write8(void *client, u8 val)
 static int write16(void *client, u8 reg, u8 val)
 {
 	u8 data[2] = {reg, val};
-	return spi_write(client, data, 1);
+	return spi_write(client, data, 2);
 }
 
 static int write24(void *client, u8 reg, u16 val)
 {
 	u8 data[3] = {reg, val >> 8, val};
-	return spi_write(client, data, 1);
+	return spi_write(client, data, 3);
 }
 
 static int read8(void *client)


