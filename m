Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab2DOScN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 14:32:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44114 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab2DOScI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 14:32:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: 3.3.2 - Crash in kthread_data (power_supply_core/led?)
Date: Sun, 15 Apr 2012 20:36:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, cbou@mail.ru,
        stern@rowland.harvard.edu, Linux PM list <linux-pm@vger.kernel.org>
References: <1334481858.1444.20.camel@localhost.localdomain>
In-Reply-To: <1334481858.1444.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201204152036.41938.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 15, 2012, Thomas Meyer wrote:
> Hi,
> 
> I resumed my computer from RAM today and found this crash on the text
> console -> see attachment. One LED was blinking, (PS2 attached) keyboard
> didn't react anymore and I had to reboot my machine.
> 
> I couldn't capture the whole dump, the crash didn't made it to the log
> on disk, so I only have this screenshot. It's the first time I see this
> crash with any kernel. I did update to 3.3.2 yesterday, but maybe this
> is unrelated.
> 
> The crash looks like the power_supply_core/led wants to send some event
> and then things goes awry.

This looks like a delayed work item triggering at a wrong time.

I guess that the leds' suspend forgets to cancel its delayed work itmes which
then may be started during system resume.

Thanks,
Rafael
