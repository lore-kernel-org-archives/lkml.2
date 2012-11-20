Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab2KTB1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:27:07 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:46454 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab2KTB1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:27:04 -0500
Message-ID: <1353374326.10939.93.camel@misato.fc.hp.com>
Subject: Re: [PATCH v5 RESEND 1/5] ACPI: Add acpi_pr_<level>() interfaces
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com,
        vijaymohan.pandarathil@hp.com, imammedo@redhat.com, prarit@redhat.com
Date: Mon, 19 Nov 2012 18:18:46 -0700
In-Reply-To: <1773951.gVY7rPR0ka@vostro.rjw.lan>
References: <1352214130-12055-1-git-send-email-toshi.kani@hp.com>
	 <1352214130-12055-2-git-send-email-toshi.kani@hp.com>
	 <5543281.izkzCt1DyB@vostro.rjw.lan> <1773951.gVY7rPR0ka@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-20 at 02:17 +0100, Rafael J. Wysocki wrote:
> On Monday, November 19, 2012 09:10:58 AM Rafael J. Wysocki wrote:
> > On Tuesday, November 06, 2012 08:02:06 AM Toshi Kani wrote:
> > > This patch introduces acpi_pr_<level>(), where <level> is a kernel
> > > message level such as err/warn/info, to support improved logging
> > > messages for ACPI, esp. for hotplug operations.  acpi_pr_<level>()
> > > appends "ACPI" prefix and ACPI object path to the messages.  This
> > > improves diagnosis of hotplug operations since an error message in
> > > a log file identifies an object that caused an issue.
> > > 
> > > acpi_pr_<level>() takes acpi_handle as an argument, which is passed
> > > to ACPI hotplug notify handlers from the ACPICA.  Therefore, it is
> > > always available unlike other kernel objects, such as device.
> > > 
> > > For example:
> > >   acpi_pr_err(handle, "Device don't exist, dropping EJECT\n");
> > > logs an error message like this at KERN_ERR.
> > >   ACPI: \_SB_.SCK4.CPU4: Device don't exist, dropping EJECT
> > >
> > > ACPI drivers can use acpi_pr_<level>() when they need to identify
> > > a target ACPI object path in their messages, such as error cases.
> > > The usage model is similar to dev_<level>().  acpi_pr_<level>() can
> > > be used when device is not created/valid, which may be the case in
> > > ACPI hotplug handlers.  ACPI object path is also consistent on the
> > > platform, unlike device name that changes over hotplug operations.
> > > 
> > > ACPI drivers should use dev_<level>() when device is valid and
> > > acpi_pr_<level>() is already used by the caller in its error path.
> > > Device name provides more user friendly information.
> > > 
> > > ACPI drivers also continue to use pr_<level>() when messages do not
> > > need to specify device information, such as boot-up messages.
> > > 
> > > Note: ACPI_[WARNING|INFO|ERROR]() are intended for the ACPICA and
> > > are not associated with the kernel message level.
> > 
> > Well, the idea is generally good, but unfortunately acpi_get_name() is
> > not a cheap operation.  Namely, it takes the global namespace mutex,
> > so your acpi_printk() may be a source of serious contention on that
> > lock if used excessively from concurrent threads.
> > 
> > Do you think you can address this problem?
> > 
> > Moreover, this also means that acpi_printk() cannot be used from interrupt
> > context, so it is not a printk() replacement, which at least should be
> > documented.
> 
> Unfortunately, I lost your reply to my previous message in this thread
> due to my e-mail client malfunction.  Sorry about that.
> 
> What about calling them acpi_handle_printk() and acpi_handle_<level>,
> respectively?  Then, if it is clearly documented that those things
> acquire the global namespace mutex and are not suitable for interrupt
> context, it should be OK.

Sounds good to me.  I will update the function names and document it in
the comment and change log.

> And please take Joe's feedback into account. :-)

Yes, Joe has been great help on this patchset (Thanks Joe!).  I think
the only remaining point is the header file location, which I will reply
to your other email.

Thanks,
-Toshi


