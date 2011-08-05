Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab1HEO7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 10:59:06 -0400
Received: from mail.ispras.ru ([83.149.199.43]:33866 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab1HEO7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 10:59:03 -0400
X-Greylist: delayed 1276 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Aug 2011 10:59:02 EDT
Message-ID: <4E3BFF9E.9060504@ispras.ru>
Date: Fri, 05 Aug 2011 18:35:10 +0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: gregkh@suse.de
CC: wfp5p@virginia.edu, linux-kernel@vger.kernel.org
Subject: Staging: serqt_usb2: kmalloc(GFP_NOIO) with spinlock held in qt_break()
 and qt_tiocmset()
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qt_break() calls usb_control_msg() with spinlock held,
while usb_control_msg() calls kmalloc(GFP_NOIO) and indirectly usb_alloc_urb(GFP_NOIO).

The same is true for qt_tiocmget() and qt_tiocmset().

Is replacing spinlock with mutex an appropriate solution to fix the issue?


Found by Linux Driver Verification project (linuxtesting.org).

--
Alexey Khoroshilov
Linux Verification Center, ISPRAS
