Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab0FWVy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 17:54:26 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:34400 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868Ab0FWVyW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 17:54:22 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Jun 2010 23:54:12 +0200
Subject: Regression in next-20100618
Thread-Topic: Regression in next-20100618
Thread-Index: AcsTHp2q2vRCHXl7RIiFdKLkF7P6ww==
Message-ID: <CEE6BB42CAD6E947908279175AF8470A025FD0D260@EXDCVYMBSTM006.EQ1STM.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

I have a regression in the next tree from 20100618, the prompt
freezes on the U8500. Drilling down with git bisecting found:

34ffc9670d67fe068f9d8582dd4d2a18d9a61205
Author: Alan Cox <alan@linux.intel.com>
Date:   Tue Jun 1 22:53:00 2010 +0200

    serial: Use block_til_ready helper

    Our code now rather closely resembles the helper, so switch to it.

    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Reverting the commit makes the problem go away.

This platform is using drivers/serial/amba-pl011.c

Any ideas I could try out to help troubleshooting this one?
It could be that you're provoking some bug in amba-pl011.c.

Yours,
Linus Walleij
