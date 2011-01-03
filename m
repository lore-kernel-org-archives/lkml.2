Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab1ACU5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 15:57:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53834 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab1ACU5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 15:57:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] acpi: Update battery information on notification 0x81
Date: Mon, 3 Jan 2011 21:56:24 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8+; KDE/4.4.4; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org
References: <1281990739-17912-1-git-send-email-mjg@redhat.com> <201012232323.42702.rjw@sisk.pl> <20110103175915.GA789@srcf.ucam.org>
In-Reply-To: <20110103175915.GA789@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101032156.24402.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 03, 2011, Matthew Garrett wrote:
> On Thu, Dec 23, 2010 at 11:23:42PM +0100, Rafael J. Wysocki wrote:
> 
> > As I've already said on IRC, I'd simply add a new function like:
> > 
> > void acpi_battery_refresh(struct acpi_battery *battery)
> > {
> > 	if (!battery->bat.dev)
> > 		return;
> > 	acpi_battery_get_info(battery);
> > 	/* The battery may have changed its reporting units */
> > 	sysfs_remove_battery(battery);
> > 	sysfs_add_battery(battery);
> > }
> > 
> > and call it before acpi_battery_update()
> > (a) in acpi_battery_resume()
> > (b) in acpi_battery_notify() if event == ACPI_BATTERY_NOTIFY_INFO
> > 
> > That would be more straightforward IMHO.
> 
> That might be more reasonable. Want to send that, or shall I?

I can do that.

Thanks,
Rafael
