Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab2A0OWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:22:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40792 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab2A0OWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:22:37 -0500
Message-ID: <4F22B326.4060605@suse.cz>
Date: Fri, 27 Jan 2012 15:22:30 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120118 Thunderbird/10.0
MIME-Version: 1.0
To: philippe.langlais@stericsson.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <gregkh@suse.de>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: 8250 regression: infinite interrupts
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the commit below causes infinite interrupts to be generated on some
chips. Namely on IBM x3850 M2.

commit 235dae5d094c415fcf0fc79fa637f1901bc8afe2
Author: Philippe Langlais <philippe.langlais@stericsson.com>
Date:   Thu Jul 29 17:13:57 2010 +0200

    U6715 16550A serial driver support

The culprit is the added size_fifo call proper in autoconfig_16550a. It
returns 16, but the chip is confused by what the function does at that
point. It is yet to be investigated why. Any ideas at this stage why
this could be a problem?

thanks,
-- 
js
suse labs
