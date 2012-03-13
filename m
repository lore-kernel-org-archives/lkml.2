Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2CMN3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:29:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47601 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab2CMN3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:29:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120313124738.GB10822@srcf.ucam.org>
References: <1331608337.2267.67.camel@debian.Gayathri>
	<20120312175130.GA18002@srcf.ucam.org>
	<1331640592.3485.50.camel@debian.Gayathri>
	<20120313124738.GB10822@srcf.ucam.org>
Date: Tue, 13 Mar 2012 18:59:35 +0530
Message-ID: <CABNxG=DswuqLOqe0qO0=tPdzZnX0paZ1JEcTv_vu-9GtyX25Lg@mail.gmail.com>
Subject: Re: [PATCH] Added backlight driver for Acer Aspire 4736
From: Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: rpurdie@rpsys.net, FlorianSchandinat@gmx.de, akpm@linux-foundation.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried giving acpi_backlight = vendor . In that case hot key for
brightness control is working. But i think  , it is not calculating
the correct value for brightness because increasing brightness after
maximum level gives blank screen .

 I also had tried 'acpi_backlight = acer_wmi' as the boot parameter
earlier . In that case  , the driver cannot find any acpi_wmi device
(showed error while booting).

By ' ACPI interface' , I mean 'acpi_video0' inside the
/sys/class/backlight. I havn't tried the /sys/class/backlight
interface directly . I will try that also.

Thanks ,

Pradeep Subrahmanion.

On Tue, Mar 13, 2012 at 6:17 PM, Matthew Garrett <mjg@redhat.com> wrote:
>
> On Tue, Mar 13, 2012 at 08:09:52AM -0400, Pradeep Subrahmanion wrote:
> > Before taking this approach , I had a look at the WMI interface.But I found from acer-acpi site that , the 4730 series
> > is using new WMI interface which needs to be reverse engineered.
> > As far as  acpi interface is concerned , by default it is not at all causing any change in brightness.
> > When 'acpi_osi=Linux' was added to the boot grub config , the brightness control with hot key started to work .
> > But it was not changing to correct values. Increasing brightness after maximum level gives blank screen.
>
> That page was last updated in 2009. Have you tried the current acer-wmi
> code? You'd probably need to pass backlight=vendor if there's a
> non-working ACPI interface.
>
> When you say the ACPI interface doesn't work, what do you mean? Have you
> tried using the /sys/class/backlight interface directly?
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
