Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab1DDQbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:31:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37738 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab1DDQbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:31:00 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com
Subject: Microblaze early console support
Date: Mon,  4 Apr 2011 18:30:54 +0200
Message-Id: <1301934655-20495-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have one question about early console support on MMU kernel.
When do you register an early console and what TLB mapping you use?

For Microblaze I registered it before main memory is setup that's why I was
hardcoded TLB 63 to 1:1 mapping (virt addr = phys addr). 
It is output only for early_printk messages but I would like to use it 
as boot console. There are only some messages that's why TLB 63 was released
later on.
That is the current state.

I have added CON_BOOT flag and register early console by register_console function
and I allocate TLB 63 for it. But unfortunately I haven't found any function 
in unregister_console which is called for unregistering to help me to release TLB 63
when early console is not used. Is there any way how to do it?

>From our experiment in past there is performance degression when kernel can't use
a TLB that's why I tried to find out a way to release TLB 63.
This is the reason why I would like to know your opinion if my style is correct 
or not.
I created new remap_early_printk function which does ioremap for console space.
This function is called from setup_arch when memory is setup. Then early mapping of TLB 63
is automatically released and can be used for Linux purpose.
Is it correct design how to do it?

How do you handle it in your arch? Do you register early console before memory initialization
is done?

You can also look at my patch I have done.

Thanks for your suggestions,
Michal


