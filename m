Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab2KZUil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:38:41 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:53771 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab2KZUik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:38:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Bill Pemberton <wfp5p@virginia.edu>
Subject: new warnings from partial __devexit removal
Date: Mon, 26 Nov 2012 20:38:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211262038.32276.arnd@arndb.de>
X-Provags-ID: V02:K0:/XwJ/YUP+2XlDCOBVjDNrcgquuO2CDbwmq/s9mM/AIH
 IgbYGh2nu4T/w5ZXKzHnJMWTpLIY1IVy5Qwejac4ZyClz55ArF
 2oXlEsyYuQrqfYpdm9pkPbe0q8wKMkJglk5/gtYESrO+d4Du97
 3ws4jy7FbIuWY1Qy8GdATKOy/4YBeX+Orgqg6Je+ijeXSggY72
 SeUj8luOcxQa2UAHCP8vq7H4ZZ5QDljUS3iUOf9yosnhYNsM9t
 zxwTwfEsIiIOnzVZoGksxWNqoT1BeScDwsDj0P5iLTHHtWefnZ
 bgliIZHPuyXJEWAMOgyKKiE3XBBOcCWLs7o5uWsjeMl0tSEb2F
 vo85EZ0+y9LRvsFxa2Vo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is probably known and fixed already, but in case it's not, let me just
mention that I saw two new warnings with ARM allyesconfig about a
__devexit being removed but the __devexit_p() still being there:

drivers/tty/serial/xilinx_uartps.c:1000:12: error: 'xuartps_remove' defined but not used [-Werror=unused-function]
drivers/usb/gadget/mv_udc_core.c:2131:12: error: 'mv_udc_remove' defined but not used [-Werror=unused-function]

Both patches were merged by Greg on Nov 19. I assume that there are a
few more, but I have not checked. These were the only ones that
caused warnings for me.

	Arnd
