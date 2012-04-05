Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab2DEVDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 17:03:06 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:53688 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab2DEVDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 17:03:05 -0400
Message-ID: <4F7E0884.5090602@suse.cz>
Date: Thu, 05 Apr 2012 23:03:00 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120331 Thunderbird/13.0a2
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@amd.com>
CC: Len Brown <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: BUG at cpuidle_play_dead
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm hitting this BUG as the last thing during shutdown:
BUG: unable to handle kernel NULL pointer dereference at 00000000000002d8
IP: [<ffffffff814ab60d>] cpuidle_play_dead+0x1d/0xb0


It's because drv is NULL. The problem is gone if I do this:
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -83,6 +83,11 @@ int cpuidle_play_dead(void)
        int i, dead_state = -1;
        int power_usage = -1;

+       if (!drv) {
+               printk("DRIVER IS NULL\n");
+               return -ENODEV;
+       }
+
        /* Find lowest-power state that supports long-term idle */
        for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
                struct cpuidle_state *s = &drv->states[i];

thanks,
-- 
js
suse labs

