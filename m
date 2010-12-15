Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab0LOVQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 16:16:38 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:61510 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab0LOVQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 16:16:35 -0500
Date: Wed, 15 Dec 2010 16:16:15 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Jack Steiner <steiner@sgi.com>
Cc: hpa@zytor.com, hmh@hmh.eng.br, tony.luck@gmail.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gbeshers@sgi.com
Subject: Re: [PATCH] - Mapping ACPI tables as CACHED
In-reply-to: <20101215164635.GA27373@sgi.com>
Message-id: <alpine.LFD.2.00.1012151536510.21167@x980>
References: <20101214220932.GA1206@sgi.com>
 <alpine.LFD.2.00.1012141903210.25387@x980> <20101215024136.GB19601@sgi.com>
 <alpine.LFD.2.00.1012142302110.4878@x980> <20101215164635.GA27373@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Do you want me to resend the patch w/o the calls to e820?

Sure.

I think this would be a 1 line-patch in acpi_os_map_memory()
to change ioremap() to ioremap_cache() if ia64 had an ioremap_cache().

Maybe it is a 2-line patch to define ioremap_cache() to ioremap()
in ia64?  It appears that ia64 has an ioremap() and an ioremap_nocache()
so presumably this would change no functionalty there.

I actually don't like the original patch wording with map_table_permanent,
since acpi_os_map_memory() is used for more than tables -- any AML
memory opregion will use it, so lets avoid that.

Granted, __acpi_map_table() isn't the best name either,
though it happens to be used only for tables by virtue
of being guarded by testing acpi_gbl_permenent_map.

That said, we don't start using cached mappings until
acpi_gbl_permanent_mmap is set in acpi_early_init(),
(when you see "ACPI Core revision" in dmesg)

I'll bet we can improve the boot sequence so that
some of the stuff we do before we have cached mappings
we can do with cached mappings...
We checksum all the tables, enumerate the CPUs and the APICs
all using non-cached mappings....


thanks,
Len Brown, Intel Open Source Technology Center

