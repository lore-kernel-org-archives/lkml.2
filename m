Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab1GGNxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:53:20 -0400
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:2419 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751748Ab1GGNxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:53:16 -0400
Message-ID: <4E15B9FD.8080003@draigBrady.com>
Date: Thu, 07 Jul 2011 14:51:57 +0100
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 0/2] [RFC] watchdog reboot timeout
References: <20110706160744.4002.94920.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20110706160744.4002.94920.stgit@bhelgaas.mtv.corp.google.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/11 17:09, Bjorn Helgaas wrote:
> I'm looking for comments on these patches.  I'm not really happy with
> them because they add basically identical code in each driver.  I also
> don't like the fact that the parameter is not generic, so I have to know
> which driver will be used on my machine.

Hmm, so this is protecting the window between watchdog_stop and machine_reset.
It would be nice to have this as generic code that did WDIOC_SETTIMEOUT
immediately after (or instead of) shutdown.

Leaving a watchdog enabled across boot does have issues on some systems.
It was OK for winboond based watchdogs I tested, but for some IBM
server systems, "weird stuff" happened if the watchdog was left enabled
across boot.

Just to mention the other watchdog boot scenario I often use
(which does _not_ protect your window above), which is to enable the
watchdog in the BIOS.  This is more general protection for the
boot _up_ process.  On a netboot system for example this will mean
that the system will keep rebooting until whatever switch is
down etc. is restored. Many systems I've used had support
for this in the BIOS and those that didn't were quickly updated
by vendors to do so.

A related issue I noticed with iTCO_wdt is that something
else in the kernel disables the iTCO watchdog (which my BIOS had started).
This is undesirable for obvious reasons.

cheers,
Pádraig.
