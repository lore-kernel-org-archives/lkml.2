Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1AZNKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 08:10:38 -0500
Received: from queue01.mail.zen.net.uk ([212.23.3.234]:52951 "EHLO
	queue01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab1AZNKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 08:10:37 -0500
X-Greylist: delayed 1320 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jan 2011 08:10:37 EST
Message-ID: <4D401824.6090109@cyconix.com>
Date: Wed, 26 Jan 2011 12:48:36 +0000
From: Evan Lavelle <sa212+lkml@cyconix.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Kernel deferring driver 'close' call: workaround?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost01-IP: [82.70.243.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've written a PCIe driver for a specialist card, which can only have a 
single user ('open' returns EBUSY if the board is already open). A user 
has complained that they can't do this with the card:

1 - open()    // Ok
2 - close()
3 - open()    // fails

'strace' shows that the 'close' succeeds, but the driver debug output 
shows that the driver close/release (step 2) is not called before the 
next open (step 3), so the open fails.

I appreciate that the kernel may want to defer the driver 'close', even 
though the open count is only 1. However, I'm surprised that the kernel 
calls the driver open code at step (3) without first calling the 
deferred close from step (2).

Is this expected behaviour? If so, can anyone suggest a work-around, at 
either driver or user level?

Thanks.
