Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab1HaJ24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 05:28:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812Ab1HaJ2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 05:28:53 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [Devel] [PATCH 1/2] ACPICA: Introduce acpi_os_phys_table_override function
Date: Wed, 31 Aug 2011 11:28:49 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop; KDE/4.6.0; x86_64; ; )
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "jnelson-suse@jamponi.net" <jnelson-suse@jamponi.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "devel@acpica.org" <devel@acpica.org>
References: <1314179290-31526-1-git-send-email-trenn@suse.de> <1314179290-31526-2-git-send-email-trenn@suse.de> <1314758622.6486.74.camel@minggr.sh.intel.com>
In-Reply-To: <1314758622.6486.74.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311128.50256.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 31, 2011 04:43:42 AM Lin Ming wrote:
> On Wed, 2011-08-24 at 17:48 +0800, Thomas Renninger wrote:
...
> You add a new interface.
Yes, is this a bigger problem?

> Can we just extend the existing interface: acpi_os_table_override?
Not sure how to do that without OS/ACPICA API changes.
The virtual address handling is nasty. You have to differ
early mappings (early_ioremap) and later mappings (io/memremap).
Re-mapping later is not possible because the physical address is
lost with the current overriding interface.
The physical address usage is transparent and from what I can
see the only way to provide proper table overriding.

If it's ok to add more paramters to acpi_os_table_override and
either pass the virtual (as before) or the physical address,
this would work:
acpi_os_table_override(struct acpi_table_header *existing_table,
                      struct acpi_table_header **new_table,
                      acpi_physical_address *address, u32 *table_length);

This would be an interface change which looked even worse to me, than 
adding a new function.

   Thomas
