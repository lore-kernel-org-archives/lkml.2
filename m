Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab1AFVB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:01:28 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:55144 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab1AFVB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:01:27 -0500
Date: Thu, 06 Jan 2011 16:01:12 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Slaby <jirislaby@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 1/1] PM: fix oops in suspend/hibernate code
In-reply-to: <201101061738.14581.rjw@sisk.pl>
Message-id: <alpine.LFD.2.02.1101061554130.17728@x980>
References: <201101060028.43342.rjw@sisk.pl> <201101061657.39723.rjw@sisk.pl>
 <4D25E943.804@gmail.com> <201101061738.14581.rjw@sisk.pl>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ... My theory is that we have mapped the
> same area already using ioremap_cache() and now we're trying to map it again
> using ioremap_nocache(), hence the conflict.  I need to confirm this.

On my test box.

BIOS-e820: 0000000077626000 - 0000000077632000 (ACPI NVS)

yet there are at least two tables (FACS and SSDT)
that live in that region, and there are several
run-time AML memory opregions residing in that range too.
So the region has already been mapped by acpi_os_map_memory()
(now using ioremap_cache()) before suspend_nvs_save() runs.

Is there a reason that suspend_nvs_save()
requires a non-cached mapping?

cheers,
Len Brown, Intel Open Source Technology Center

