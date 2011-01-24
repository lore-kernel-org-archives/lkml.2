Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab1AXViD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:38:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35385 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab1AXViB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:38:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 0/11] ACPI: Fixes and cleanups related to iomaps management
Date: Mon, 24 Jan 2011 22:37:43 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        platform-driver-x86@vger.kernel.org
References: <201101201226.41021.rjw@sisk.pl> <201101232135.32510.rjw@sisk.pl> <20110123231512.GB11203@khazad-dum.debian.net>
In-Reply-To: <20110123231512.GB11203@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101242237.44269.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 24, 2011, Henrique de Moraes Holschuh wrote:
> On Sun, 23 Jan 2011, Rafael J. Wysocki wrote:
> > On Sunday, January 23, 2011, Henrique de Moraes Holschuh wrote:
> > > On Sat, 22 Jan 2011, Rafael J. Wysocki wrote:
> > > > > I discovered CONFIG_THINKPAD_ACPI caused suspend-to-disk to hang. I
> > > > > need the Thinkpad ACPI to control the fan and bluetooth. It looks like
> > > > > the thinkpad acpi is trying acquire locks while suspending.  Disabling
> > > > > cmos, light, led and hotkeys makes suspend-to-disk works again.
> > > > 
> > > > Well, we should tell the thinkpad_acpi maintainer about that, then (CCed).
> > > 
> > > What are the requirements re. mutexes for sleep-to-disk versus sleep-to-ram?
> > 
> > No difference.  Basically, there are two differences between suspend and
> > hibernation, as far as drivers are concerned:
> > (1) It's better to use the ->freeze()/->thaw() and ->poweroff()/->restore()
> >     callbacks for hibernation.
> > (2) It may be _much_ more difficult to get free memory during hibernation
> >     (so theoretically attempts to get memory during hibernation are more likely
> >     to block).
> 
> So, if there is nothing wrong with mutex use by itself...
> 
> Thinkpad-acpi calls the thinkpad firmware (using normal ACPI method calls),
> which does SMI traps into the SMBIOS to do whatever it wants done.  And that
> includes writing to the NVS (both the peecee RTC CMOS, and ACPI-backed
> "NVS").
> 
> > Besides, the problem reported by Jeff seems to be caused by CPU hotplug.
> 
> Something weird going on with CPU hotplug could throw Lenovo's
> way-too-complex-for-comfort SMM firmware out of wack alright.
> 
> That can be checked.  Lobotomize the driver so that it does not do the acpi
> calls in the suspend path (but keep everything else).  If it still locks, it
> is not the firmware.

It turns out there's a bug in intel_idle causing people a lot of pain with CPU
hotplugging.  Should be fixed now it the Linus' tree.

Thanks,
Rafael
