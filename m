Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab1LEAOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 19:14:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41309 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab1LEAOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 19:14:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] PM / sh7372: Make domain stay_on bit only affect system suspend
Date: Mon, 5 Dec 2011 01:17:05 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <201112042308.14255.rjw@sisk.pl>
In-Reply-To: <201112042308.14255.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112050117.05214.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 04, 2011, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> SH7372 uses two independent mechanisms for ensuring that power
> domains will never be turned off: the stay_on flag and the "always
> on" domain governor.  However, the "always on" governor is only taken
> into accout by runtime PM code paths, while the stay_on flag affects
> all attempts to turn the given domain off.  This is a problem for
> domains that only need to stay in the "power on" state during system
> sleep, but may be turned off by runtime PM if specific conditions are
> satisfied.  For this reason, make SH7372 register a PM notifier that
> will enable the checking of the domain stay_on flag on during system
> suspend and disable it during system resume.  This way, the stay_on
> flag will only affect system sleep states, while the "always on"
> governor will only affect runtime PM.

Well, it's not that simple, because we need to make the domains that
should stay "on" during system suspend be powered on beforehand.

I'll send an updated patch in a while.

Thanks,
Rafael
