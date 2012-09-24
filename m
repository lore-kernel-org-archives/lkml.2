Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab2IXGnC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 02:43:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab2IXGm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 02:42:59 -0400
From: Thomas Renninger <trenn@suse.de>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/2] ACPI: Override arbitrary ACPI tables via initrd for debugging
Date: Mon, 24 Sep 2012 08:40:28 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.10-0.4-desktop; KDE/4.4.4; x86_64; ; )
Cc: hpa@zytor.com, initramfs@vger.kernel.org, robert.moore@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        yinghai@kernel.org, eric.piel@tremplin-utc.net, vojcek@tlen.pl
References: <1348234085-39220-1-git-send-email-trenn@suse.de> <201209230317.04050.trenn@suse.de> <505E8F44.9020208@kernel.org>
In-Reply-To: <505E8F44.9020208@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209240840.29342.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 September 2012 06:25:40 Len Brown wrote:
> > +config ACPI_INITRD_TABLE_OVERRIDE
> > +       bool
> > +       default y
> 
> Do distros in addition to SuSE concur they want to ship this way?
Whether distros ship this in their enterprise, community or just in
a -debug kernel flavor is up to them.
I cannot see why this cannot be enabled by default on all.
That is what the TAINT flag is for...
 
> The last time we tried to make debugging easier we added
> ACPI_CUSTOM_METHOD, which allowed root to over-ride an AML method
> on a running system.  Distro security-minded people were not amused.
Yep and therefore you have to remove this one from the tools for
ACPI debugging you listed.
The issue is/was, that root can inject code at runtime which is then
executed in kernel environment.
Afaik there are "security" provisions or say setups, which do
hide modprobe/insmod and do not allow root to load any kernel drivers 
or similar.
If one can write the kernel or initrd which gets booted, I guess there
are not much security restrictions anymore you could put on this user...
But thanks for the pointer, I'll go and double check with some
security guys.

> thanks,
> -Len Brown, Intel Open Source Technology Center
> 
> ps I noticed your reference to acpidump in the README.
> That reminded me to push it to the kernel source tree.
> Its new home will be tools/power/acpi
This is the one which I tried to/did adjust to acpica headers?
This sounds like a very good idea. I'll adjust the docs.

pss: Can this tool live there as well:
ftp://ftp.suse.com/pub/people/trenn/sources/ec/ec_access.c
It's the userspace tool for examining EC values (and changes) via
ec_sys debug driver and a corresponding /sys/kernel/debug/.. file.
It's more ore less doing the same what the old thinkpad_acpi driver
could, but offers this to all machines with an EC device.

    Thomas
