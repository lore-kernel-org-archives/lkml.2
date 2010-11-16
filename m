Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab0KPRbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:31:19 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57735 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab0KPRbQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:31:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=rjaeFidpeTpa/KHvCx3rcQxpxjYJF5Y/olNMIcjeSd9/kYm1ilPEVvwKiNMY4OV+cG
         kTOAjIsQLrqk4bo5fMq/EBay8RcKkxyUJYRJVU0q4uDMg/3SaIQScVsI1JSRHBhKA2O3
         aJVXRolsFWO4yPquU8noubuIJ4NDyTTQRG7R4=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [REGRESSION] [2.6.37-rc1] Fan noise after suspend to ram/disk
Date: Tue, 16 Nov 2010 18:31:10 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1; KDE/4.4.5; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <201011041706.59046.maciej.rutecki@gmail.com> <201011152139.46261.maciej.rutecki@gmail.com> <1289870775.8148.2020.camel@rui>
In-Reply-To: <1289870775.8148.2020.camel@rui>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011161831.11209.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 16 listopada 2010 o 02:26:15 Zhang Rui wrote:
> On Tue, 2010-11-16 at 04:39 +0800, Maciej Rutecki wrote:
> > On poniedziałek, 15 listopada 2010 o 04:16:35 Zhang Rui wrote:
> > > On Tue, 2010-11-09 at 01:35 +0800, Maciej Rutecki wrote:
> > > > On poniedziałek, 8 listopada 2010 o 07:58:52 Zhang Rui wrote:
> > > > > IMO, the only one that may cause this regression is commit
> > > > > c57b62f5b1e6dd69ff8c96f6db7f86ea31c0e21f
> > > > > some app may enable polling via procfs and update the thermal zone
> > > > > status.
> > > > 
> > > > I revert this commit from 2.6.37-rc1. Still the same:
> > > could you please apply the patch attached, on top of 2.6.37-rc1, and
> > > then attach the dmesg output if the fan is noise after suspend/resume.
> > 
> > Dmesg in attachement.
> > 
> > Starting suspend to ram from:
> > [  104.602674] PM: Syncing filesystems ... done.
> > resume OK, but next:
> > [  144.298104] PM: Syncing filesystems ... done.
> > after resume fan starts on full speed.
> 
> it seems that it's not the thermal driver that changes the Fan speed.
> Please apply the debug patch attached, rebuild with CONFIG_ACPI_DEBUG
> set and reboot with "acpi.debug_level=0x004
> acpi.debug_layer=0x04A10000", and then attach the dmesg output after the
> same test.

2.6.37-rc1 + your latest patch, suspend to ram&resume:
http://unixy.pl/maciek/download/kernel/2.6.37-rc1/gumis/dmesg-debug-2.6.37-
rc1.txt.zip

Thanks
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
