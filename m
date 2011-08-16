Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1HPCwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:52:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab1HPCwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:52:18 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Mon Aug 15 19:44:53 2011
Message-Id: <20110816024453.245127373@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 15 Aug 2011 19:42:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ionut Nicu <ionut.nicu@cloudbit.ro>
Subject: [07/26] USB: ftdi_sio: fix minor typo in get_ftdi_divisor
In-Reply-To: <20110816024553.GA5631@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ionut Nicu <ionut.nicu@cloudbit.ro>

commit 1862cdd542025218f7a390b7e6ddc83a1362d1e0 upstream.

Even if it's unlikely for this to cause an error,
there is a typo in the code that uses the bitwise-AND
operator instead of the logical one.

Signed-off-by: Ionut Nicu <ionut.nicu@cloudbit.ro>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1171,7 +1171,7 @@ static __u32 get_ftdi_divisor(struct tty
 	case FT2232H: /* FT2232H chip */
 	case FT4232H: /* FT4232H chip */
 	case FT232H:  /* FT232H chip */
-		if ((baud <= 12000000) & (baud >= 1200)) {
+		if ((baud <= 12000000) && (baud >= 1200)) {
 			div_value = ftdi_2232h_baud_to_divisor(baud);
 		} else if (baud < 1200) {
 			div_value = ftdi_232bm_baud_to_divisor(baud);


