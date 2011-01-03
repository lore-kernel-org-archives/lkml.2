Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab1ACR7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:59:23 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51990 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab1ACR7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:59:22 -0500
Date: Mon, 3 Jan 2011 17:59:15 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH] acpi: Update battery information on notification 0x81
Message-ID: <20110103175915.GA789@srcf.ucam.org>
References: <1281990739-17912-1-git-send-email-mjg@redhat.com> <20101215171928.GA17746@srcf.ucam.org> <20101223211638.GA7862@srcf.ucam.org> <201012232323.42702.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012232323.42702.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 11:23:42PM +0100, Rafael J. Wysocki wrote:

> As I've already said on IRC, I'd simply add a new function like:
> 
> void acpi_battery_refresh(struct acpi_battery *battery)
> {
> 	if (!battery->bat.dev)
> 		return;
> 	acpi_battery_get_info(battery);
> 	/* The battery may have changed its reporting units */
> 	sysfs_remove_battery(battery);
> 	sysfs_add_battery(battery);
> }
> 
> and call it before acpi_battery_update()
> (a) in acpi_battery_resume()
> (b) in acpi_battery_notify() if event == ACPI_BATTERY_NOTIFY_INFO
> 
> That would be more straightforward IMHO.

That might be more reasonable. Want to send that, or shall I?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
