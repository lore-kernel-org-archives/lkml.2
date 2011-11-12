Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab1KLWWv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 17:22:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37232 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab1KLWWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 17:22:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [bisected][bug] commit e978aa7d7d57d04eb5f88 breaks suspend on laptop.
Date: Sat, 12 Nov 2011 23:25:08 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>
References: <201111120341.12473.arnd@arndb.de>
In-Reply-To: <201111120341.12473.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111122325.09134.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 12, 2011, Arnd Bergmann wrote:
> On Saturday, November 12, 2011, Rafael J. Wysocki wrote:
> > If that's "acpi_idle", the appended patch should help (it works for
> > me at least).
> 
> Hi Rafael,
> 
> I currently have limited email connectivity but I happened to bisect the
> same bug and your patch fixes it for me. I am certainly on acpi_idle
> with my thinkpad w500.

Yes, I'm quite sure everyone on acpi_idle is affected by this bug.

> Sorry for breaking the email threading and dropping people from Cc.

No problem.

> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: ACPI / cpuidle: Remove acpi_idle_suspend (to fix suspend regression)
> > After commit e978aa7d7d57d04eb5f88a7507c4fb98577def77 (cpuidle: Move
> > dev->last_residency update to driver enter routine; remove
> > dev->last_state) setting acpi_idle_suspend to 1 by
> > acpi_processor_suspend() causes the ACPI cpuidle routines to return
> > error codes continuously, which in turn causes cpuidle to lock up
> > (hard).  However, acpi_idle_suspend doesn't appear to be useful for
> > any purpose (it's racy and doesn't really provide any real
> > protection), so it can be removed, which makes the problem go away.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Tested-by: Arnd Bergmann <arnd@arndb.de>

Thanks for the info.  Unfortunately, I've already resent the patch without
your Tested-by: tag, but it can still be added when the patch is committed.

Rafael
