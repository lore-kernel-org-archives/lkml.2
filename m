Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab2CZApf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 20:45:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab2CZApe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 20:45:34 -0400
From: Thomas Renninger <trenn@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via initrd
Date: Mon, 26 Mar 2012 02:45:29 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.10-0.4-desktop; KDE/4.4.4; x86_64; ; )
Cc: eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, hpa@zytor.com
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <201203240226.35314.trenn@suse.de> <CAE9FiQVxH4cSotaTOKrNe-W+EQEdg=r5AbUaejD3FtyY2bRCsQ@mail.gmail.com>
In-Reply-To: <CAE9FiQVxH4cSotaTOKrNe-W+EQEdg=r5AbUaejD3FtyY2bRCsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203260245.31105.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 March 2012 05:41:37 Yinghai Lu wrote:
> On Fri, Mar 23, 2012 at 6:26 PM, Thomas Renninger <trenn@suse.de> wrote:
> >> maybe could have dmi checking for more strict checking.
> > I do not understand what should get checked?
> > Hm, I guess you mean if a general table is always added that is distributed
> > on different platforms and you want to white/blacklist machines to
> > explicitly load/not load the table?
> > This must not happen.
> > The tables are always platform specific and you provide tables for
> > a specific machine only for debugging purposes.
> >
> >> also would help if have one boot command that could skip overriding.
> > Same. Both should not be needed.
> >
> > Or you have a use-case in mind I cannot not think of...
> 
> For known broken system,  could be old, or vendor does not want to
> provide updated firmware anymore.
> if the user could boot system with debug parameter
> like "noapic maxcpus=1...."
> then have user space util to extract acpi tables, and patch them and
> repack them into initrd.
> next boot will have system running with optimal ...
> 
> If we could do that, we could avoid or kill workaround and quirks in the kernel.
> 
> So we may need some strict check or skip when you are moving disk
> around or update different bios later.
NO!

This is exactly for what you've written first:
---
that is very good feature for development and debug.
will not need to ask for testbios ...
---

Linux ACPI policy is to support BIOSes which work with latest Windows version
supported systems. If needed, quirks are added.
I agree that some very old quirks can vanish, I don't have a nice example at hand,
there should not be much of them.
When DSDT overriding via initrd was not possible any more because it has been done
too early, I saw about 3 bugs of poor souls with old machines who really needed this
to get the system half way running. For such old systems this may be an option and
they do not need to compile a modified DSDT into their kernel anymore.


If this was not clear by tainting the kernel and adding this to Documentation/ :
+Please keep in mind that this is a debug option.
+ACPI tables should not get overridden for productive use.
+If BIOS ACPI tables are overridden the kernel will get tainted with the
+TAINT_OVERRIDDEN_ACPI_TABLE flag.
+Complain to your platform/BIOS vendor if you find a bug which is that sever
+that a workaround is not accepted in the Linus kernel.

a message like "Overriding an ACPI table, don't do that unless you know exactly
what you are doing" or the Kconfig option can be moved from the ACPI to the
"Kernel hacking" section to make this even more obvious.

Len has a bunch of arguments why fixing things by overriding ACPI tables is
the wrong approach.

This still is a very convenient feature:
  - to find bugs in BIOS ACPI tables or in the kernel.
  - for research -> in the end ACPI is an essential part of the X86
    architecture and e.g. by clustering the DSDT with debug statements it's
    now easy to get an idea how bits are shifted around and where they
    are coming from.
  - for BIOS developers and platform vendors to easily test the impact of their
    changes on the Linux kernel. Also to let them use the Intel ACPI aka ACPICA
    tools which is the code base syned into (used in) the kernel.

   Thomas
