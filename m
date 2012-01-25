Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab2AYCHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 21:07:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56847 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab2AYCHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 21:07:18 -0500
MIME-Version: 1.0
In-Reply-To: <4F1F5FB4.1020004@linux.intel.com>
References: <4f1decfc19324ca832@agluck-desktop.sc.intel.com>
	<4F1F5FB4.1020004@linux.intel.com>
Date: Tue, 24 Jan 2012 18:07:17 -0800
X-Google-Sender-Auth: P4E2f6tI8IbXdtq6T8tpfgCQoxw
Message-ID: <CA+8MBb+gCrcs5=LdE0j-kh=xcVDLhRYWqeQSTRE7qfH-OsDVzQ@mail.gmail.com>
Subject: Re: [PATCH] Use acpi_os_map_memory() instead of ioremap() in einj driver
From: Tony Luck <tony.luck@intel.com>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Myron Stowe <mstowe@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 5:49 PM, Chen Gong <gong.chen@linux.intel.com> wrote:
> I can understand why here C memory access model can work because ACPI table
> is in physical memory zone but not in device space, but I still have
> two confusion: 1)why ioremap fail but acpi_os_map_memory can work? In
> essential
> acpi_os_map_memory is ioremap (or precisely, ioremap_cache), right?

Myron has been asking the same questions. Probably the difference is
between cache and nocache. But it unclear what changed between 3.2-rc7
(where these ioremap() calls worked) and 3.3-rc1 (where they fail).

> 2)since acpi_os_map_memory is io mapping too (though it is a little bit
> special), read/write should work besides *C memory access*. If so, why
> removing
> read/write here? Some ARCH compatibility or compilation issue?

It's just prettier - avoids the need for the local copies of readq()/writeq()
for 32-bit systems too.

-Tony
