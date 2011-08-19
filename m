Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1HSS0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 14:26:49 -0400
Received: from b.mail.sonic.net ([64.142.19.5]:40883 "EHLO b.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab1HSS0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 14:26:44 -0400
X-Greylist: delayed 2515 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Aug 2011 14:26:44 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Mailer: AtMail PHP 5.62
Message-ID: <26505.1313775887@sonic.net>
To: <linux-kernel@vger.kernel.org>
Reply-To: mikeci@acm.org
X-Origin: 207.114.132.30
X-Atmail-Account: mikeci@sonic.net
Date: Fri, 19 Aug 2011 10:44:47 -0700
Subject: Possible bug in 8250.c
From: Ivica Mikec <mikeci@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 Hi!


I noticed a problem in 8250.c. 

My board has only one UART port, and is 16550 compatible, so in function serial8250_interrupt I see that serial_in function is called twice. Second time, code "else if (end == NULL)" is executed and function return IRQ_NONE. This causes an entry in /proc/irq/spurious:

count 239
unhandled 1
last_unhandled 4294700846 ms

But this is not a spurious interrupt.

Regards.
