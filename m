Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab0DEJjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 05:39:33 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:55019 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0DEJj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 05:39:26 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
Date: Mon, 5 Apr 2010 10:39:25 +0100
Message-ID: <s2g6a4b170b1004050239ga41e5496r1e416b755f655a0a@mail.gmail.com>
Subject: Bad watchdog ioctl definitions
From: James Hogan <james@albanarts.com>
To: Wim Van Sebroeck <wim@iguana.be>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thierry Reding <thierry.reding@avionic-design.de>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've noticed that some of the ioctl definitions in
include/linux/watchdog.h are incorrect, for example:

#define WDIOC_SETOPTIONS        _IOR(WATCHDOG_IOCTL_BASE, 4, int)
This is a write ioctl so should be _IOW

#define WDIOC_KEEPALIVE         _IOR(WATCHDOG_IOCTL_BASE, 5, int)
I think this should just be _IO since the argument is ignored anyway

>From a quick grep, mpcore_wdt appears to be the only watchdog driver
in drivers/watchdog that uses _IOC_DIR on the ioctl number, which
breaks the SETOPTIONS ioctl on this driver.

Is it usually even possible to change ioctl numbers for compatibility?
What's the usual process?

Cheers
-- 
James Hogan
