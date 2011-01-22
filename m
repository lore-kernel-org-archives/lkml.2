Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab1AVJ0g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 04:26:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41771 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab1AVJ0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 04:26:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH 0/11] ACPI: Fixes and cleanups related to iomaps management
Date: Sat, 22 Jan 2011 10:25:49 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <201101201226.41021.rjw@sisk.pl> <AANLkTimEoAhO9TRx4Aq7NnTTt6G-u+cHJRyAMjSAJgTm@mail.gmail.com> <AANLkTin3d4LdnqDYtrTK=KdmjADA2MsaWYoLG19FxOzG@mail.gmail.com>
In-Reply-To: <AANLkTin3d4LdnqDYtrTK=KdmjADA2MsaWYoLG19FxOzG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201101221025.49327.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 22, 2011, Jeff Chua wrote:
> On Sat, Jan 22, 2011 at 1:54 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> > 2011/1/22 Rafael J. Wysocki <rjw@sisk.pl>:
> >> On Friday, January 21, 2011, Jeff Chua wrote:
> >>> 2011/1/21 Rafael J. Wysocki <rjw@sisk.pl>:
> >>> > Thanks, but unfortunately this wasn't conclusive.  Please apply the patch below
> >>> > instead of the previous one (on top of [1/11] - [11/11]) and collect dmesg
> >> So, below is a replacement for [11/11].  Please test it on top of
> >> [1/11] - [10/11] (the current Linus' tree already contains [1/11] and [2/11])
> >> and let me know if it works for you (in either case, please attach dmesg
> >> output containing a suspend attempt).
> >>
> >> If it works, I'll remove the diagnostic messages and submit along with the
> >> rest of the patchset.
> >
> > Rafael,
> >
> > dmesg attached. This time, it worked!
> >
> > I discovered CONFIG_THINKPAD_ACPI caused suspend-to-disk to hang. I
> > need the Thinkpad ACPI to control the fan and bluetooth. It looks like
> > the thinkpad acpi is trying acquire locks while suspending.  Disabling
> > cmos, light, led and hotkeys makes suspend-to-disk works again.
> 
> Here's the dmesg.

Thanks!

Well, and this:

Brought up 4 CPUs
2011-01-22T11:32:56.424328+08:00 boston kernel: Total of 4 processors activated (17023.83 BogoMIPS).
2011-01-22T11:32:56.424329+08:00 boston kernel: PM: Registering ACPI NVS region at bb371000 (528384 bytes)
2011-01-22T11:32:56.424332+08:00 boston kernel: PM: Registering ACPI NVS region at bb668000 (524288 bytes)
2011-01-22T11:32:56.424334+08:00 boston kernel: PM: Registering ACPI NVS region at bb76b000 (49152 bytes)
2011-01-22T11:32:56.424335+08:00 boston kernel: PM: Registering ACPI NVS region at bb77a000 (28672 bytes)
2011-01-22T11:32:56.424337+08:00 boston kernel: PM: Registering ACPI NVS region at bb782000 (36864 bytes)
2011-01-22T11:32:56.424338+08:00 boston kernel: PM: Registering ACPI NVS region at bb78c000 (77824 bytes)
2011-01-22T11:32:56.424339+08:00 boston kernel: NET: Registered protocol family 16

means that my patch [11/11] _and_ the replacement are totally wrong, because you have
_multiple_ NVS regions.  That really helped, thanks a lot.

Rafael
