Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab1EaM7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:59:06 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43958 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046Ab1EaM7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:59:04 -0400
Date: Tue, 31 May 2011 14:59:02 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] irq: catch more wrong return values from interrupt
 handlers
Message-ID: <20110531125902.GA13217@Chamillionaire.breakpoint.cc>
References: <1306824972-27067-1-git-send-email-sebastian@breakpoint.cc>
 <1306824972-27067-3-git-send-email-sebastian@breakpoint.cc>
 <alpine.LFD.2.02.1105311231150.3078@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105311231150.3078@ionos>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner | 2011-05-31 12:32:58 [+0200]:

>On Tue, 31 May 2011, Sebastian Andrzej Siewior wrote:
>
>> We now also accept return value IRQ_WAKE_THREAD from a threaded
>> interrupt or IRQ_HANDLED | IRQ_WAKE_THREAD from primary and theaded
>> handler which is wrong. We need to accept the later on shared handlers
>> where one handler is primary only and the second is a threaded handler.
>> This patch attempts to catch them. Unfortunately this patch introduces
>> two new types so I'm not sure if it is worth it.
>
>I'd rather avoid that ugliness. If driver writers are that stupid,
>there is probably more significant wreckage than this.

Sure. It is just that the "old" code ensured that either NONE or HANDLED
is returned and nothing else and the previous patch broke that check.
This patch just points it out :)
Do you want bad_action_ret() removed or kept as it?

>Thanks,
>
>	tglx

Sebastian
