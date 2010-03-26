Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab0CZRMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 13:12:33 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:39835 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab0CZRMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 13:12:32 -0400
Subject: Re: [PATCH] rfkill: core: add custom rfkill switch
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavan Savoy <pavan_savoy@yahoo.co.in>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <911285.11966.qm@web94910.mail.in2.yahoo.com>
References: <911285.11966.qm@web94910.mail.in2.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 10:12:38 -0700
Message-ID: <1269623558.4342.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-26 at 21:43 +0530, Pavan Savoy wrote:

> Well, Almost, I don't want to signal the user-space about the counter.
> Have a look @ http://lkml.org/lkml/2010/3/24/303
> 
> See the kernel space (bluetooth driver) would register itself, to my line discipline driver, when someone does a 'hciconfig hci0 up' which is essentially BT-On.
> 
> So, now from my ldisc driver (which intends to mux BT/FM and GPS over UART), I need to signal a user-space daemon to open the TTY device, set the baud rate and install the ldisc - So I can make use of it.
> 
> To notify that user-space daemon, I had planned to use /dev/rfkill.
> However, now with BT application also toggling the rfkill switch by writing to sysfs entry - is causing a bit of confusion to my user-space daemon.
> 
> Although I now use hard/soft members of struct rfkill_event now to differentiate the 2 events (1 auto generated, another from BT app) - This patch would make it a bit more proper.

No. The proper way would be to either have your driver manage the UART
instead of userspace, or have your driver have its own userspace
interface. rfkill has nothing to do with it.

johannes

