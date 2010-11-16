Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab0KPWgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:36:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54699 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab0KPWgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:36:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: maciej.rutecki@gmail.com
Subject: Re: [REGRESSION] [2.6.37-rc1] Fan noise after suspend to ram/disk
Date: Tue, 16 Nov 2010 23:35:26 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Zhang Rui <rui.zhang@intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>
References: <201011041706.59046.maciej.rutecki@gmail.com> <1289870775.8148.2020.camel@rui> <201011162028.47007.maciej.rutecki@gmail.com>
In-Reply-To: <201011162028.47007.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011162335.26220.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 16, 2010, Maciej Rutecki wrote:
> On wtorek, 16 listopada 2010 o 02:26:15 Zhang Rui wrote:
> > On Tue, 2010-11-16 at 04:39 +0800, Maciej Rutecki wrote:
> > > On poniedziałek, 15 listopada 2010 o 04:16:35 Zhang Rui wrote:
> > > > On Tue, 2010-11-09 at 01:35 +0800, Maciej Rutecki wrote:
> > > > > On poniedziałek, 8 listopada 2010 o 07:58:52 Zhang Rui wrote:
> > > > > > IMO, the only one that may cause this regression is commit
> > > > > > c57b62f5b1e6dd69ff8c96f6db7f86ea31c0e21f
> > > > > > some app may enable polling via procfs and update the thermal zone
> > > > > > status.
> > > > > 
> > > > > I revert this commit from 2.6.37-rc1. Still the same:
> > > > could you please apply the patch attached, on top of 2.6.37-rc1, and
> > > > then attach the dmesg output if the fan is noise after suspend/resume.
> > > 
> > > Dmesg in attachement.
> > > 
> > > Starting suspend to ram from:
> > > [  104.602674] PM: Syncing filesystems ... done.
> > > resume OK, but next:
> > > [  144.298104] PM: Syncing filesystems ... done.
> > > after resume fan starts on full speed.
> > 
> > it seems that it's not the thermal driver that changes the Fan speed.
> > Please apply the debug patch attached, rebuild with CONFIG_ACPI_DEBUG
> > set and reboot with "acpi.debug_level=0x004
> > acpi.debug_layer=0x04A10000", and then attach the dmesg output after the
> > same test.
> > Please attach the acpidump output of this laptop as well.
> > 
> > thanks,
> > rui
> > 
> > > Regards
> 
> Revert 3e384ee6c687cb397581ee8f9440fc8220cfac80 seems solve problem:
> https://bugzilla.kernel.org/show_bug.cgi?id=22932#c3

Please do the test I asked for in the bug entry.

Thanks,
Rafael
