Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1AWXPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 18:15:19 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44251 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010Ab1AWXPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 18:15:17 -0500
X-Sasl-enc: iyX1TDU3nX89gJCw7tWHvyLmm3nfTtA9/SgZeGNbZXPA 1295824516
Date: Sun, 23 Jan 2011 21:15:12 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH 0/11] ACPI: Fixes and cleanups related to iomaps
 management
Message-ID: <20110123231512.GB11203@khazad-dum.debian.net>
References: <201101201226.41021.rjw@sisk.pl>
 <201101221013.10239.rjw@sisk.pl>
 <20110123182037.GH24071@khazad-dum.debian.net>
 <201101232135.32510.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101232135.32510.rjw@sisk.pl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Jan 2011, Rafael J. Wysocki wrote:
> On Sunday, January 23, 2011, Henrique de Moraes Holschuh wrote:
> > On Sat, 22 Jan 2011, Rafael J. Wysocki wrote:
> > > > I discovered CONFIG_THINKPAD_ACPI caused suspend-to-disk to hang. I
> > > > need the Thinkpad ACPI to control the fan and bluetooth. It looks like
> > > > the thinkpad acpi is trying acquire locks while suspending.  Disabling
> > > > cmos, light, led and hotkeys makes suspend-to-disk works again.
> > > 
> > > Well, we should tell the thinkpad_acpi maintainer about that, then (CCed).
> > 
> > What are the requirements re. mutexes for sleep-to-disk versus sleep-to-ram?
> 
> No difference.  Basically, there are two differences between suspend and
> hibernation, as far as drivers are concerned:
> (1) It's better to use the ->freeze()/->thaw() and ->poweroff()/->restore()
>     callbacks for hibernation.
> (2) It may be _much_ more difficult to get free memory during hibernation
>     (so theoretically attempts to get memory during hibernation are more likely
>     to block).

So, if there is nothing wrong with mutex use by itself...

Thinkpad-acpi calls the thinkpad firmware (using normal ACPI method calls),
which does SMI traps into the SMBIOS to do whatever it wants done.  And that
includes writing to the NVS (both the peecee RTC CMOS, and ACPI-backed
"NVS").

> Besides, the problem reported by Jeff seems to be caused by CPU hotplug.

Something weird going on with CPU hotplug could throw Lenovo's
way-too-complex-for-comfort SMM firmware out of wack alright.

That can be checked.  Lobotomize the driver so that it does not do the acpi
calls in the suspend path (but keep everything else).  If it still locks, it
is not the firmware.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
