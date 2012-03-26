Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2CZBZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 21:25:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46016 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab2CZBZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 21:25:38 -0400
Message-ID: <4F6FC57D.3050404@zytor.com>
Date: Sun, 25 Mar 2012 18:25:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <201203240402.38749.trenn@suse.de> <4F6D50DD.4050306@zytor.com> <201203260245.43177.trenn@suse.de>
In-Reply-To: <201203260245.43177.trenn@suse.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2012 05:45 PM, Thomas Renninger wrote:
> Best would be if no distro specific mkinitrd magic is needed and it's
> just as easy as it is:
> cp DSDT.aml /boot/initrd-test
> cat /boot/initrd >>/boot/initrd-test
> and add a test boot entry to grub's menu.lst or whereever.
> Then developers would not have to look at distro specific implementations
> (which should not exist) about how to test a table quickly.

There is no distro-specific magic needed.  What I'm proposing is
basically what you have above, except that your DSDT.aml would be
wrapped in a cpio header.  What I would like to ask from you is if it
makes sense to have kernel/acpi/DSDT, kernel/acpi/SSDT and so on, or
just make it a single kernel/acpi member.

By wrapping in a cpio container it becomes a generic mechanism.

>> By the way, if "relying on the bootloader" was an option in any way
> 
> Why exactly is a change in the bootloader not an option?
> Not sure whether a version number is passed, but the magic number could be
> changed for now.

There are a lot of bootloaders, and one of the most commonly used ones
has a very adversarial relationship with the kernel maintainers.

> If the new magic number is passed, we get a linked list.

The linked list stuff is already supported.  This interface has been
supported in the kernel since 2007.

	-hpa
