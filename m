Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab2GRAOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:14:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39056 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab2GRAMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:12:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dean Nelson <dnelson@redhat.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Pieper <jeffrey.e.pieper@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [ 09/23] e1000e: Correct link check logic for 82571 serdes
Date: Tue, 17 Jul 2012 17:12:02 -0700
Message-Id: <20120717232329.973132421@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232329.276003806@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232329.276003806@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tushar Dave <tushar.n.dave@intel.com>

commit d0efa8f23a644f7cb7d1f8e78dd9a223efa412a3 upstream.

SYNCH bit and IV bit of RXCW register are sticky. Before examining these bits,
RXCW should be read twice to filter out one-time false events and have correct
values for these bits. Incorrect values of these bits in link check logic can
cause weird link stability issues if auto-negotiation fails.

Reported-by: Dean Nelson <dnelson@redhat.com>
Signed-off-by: Tushar Dave <tushar.n.dave@intel.com>
Reviewed-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Jeff Pieper <jeffrey.e.pieper@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/e1000e/82571.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -1573,6 +1573,9 @@ static s32 e1000_check_for_serdes_link_8
 	ctrl = er32(CTRL);
 	status = er32(STATUS);
 	rxcw = er32(RXCW);
+	/* SYNCH bit and IV bit are sticky */
+	udelay(10);
+	rxcw = er32(RXCW);
 
 	if ((rxcw & E1000_RXCW_SYNCH) && !(rxcw & E1000_RXCW_IV)) {
 


