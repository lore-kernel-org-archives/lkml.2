Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065Ab1ADW6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 17:58:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60336 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab1ADW6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 17:58:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: suspend hangs at platform phase [was: mmotm 2010-12-23-16-58 uploaded]
Date: Tue, 4 Jan 2011 23:57:08 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8+; KDE/4.4.4; x86_64; ; )
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>, steiner@sgi.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>
References: <201012240132.oBO1W8Ub022207@imap1.linux-foundation.org> <4D232352.2030809@gmail.com> <4D234F8E.7080102@gmail.com>
In-Reply-To: <4D234F8E.7080102@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201101042357.08600.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 04, 2011, Jiri Slaby wrote:
> On 01/04/2011 02:40 PM, Jiri Slaby wrote:
> > On 12/24/2010 01:58 AM, akpm@linux-foundation.org wrote:
> >> The mm-of-the-moment snapshot 2010-12-23-16-58 has been uploaded to
> > 
> > Hi, this kernel regresses with respect to suspend to ram in comparison
> > with mmotm 2010-12-16-14-56.
> > 
> > This is OK:
> > echo devices > /sys/power/pm_test
> > pm-suspend
> > This hangs at suspend phase:
> > echo platform > /sys/power/pm_test
> > pm-suspend

Hmm.  So it looks like _PTS hangs?

> > Note that this kernel is based on next-20101221. Should I try newer (and
> > clean) -next?
> 
> Ok, bisected down to:
> 16dc39c98a6ca56a27f22f7ac6731d8223237a2e is first bad commit
> commit 16dc39c98a6ca56a27f22f7ac6731d8223237a2e
> Author: Len Brown <len.brown@intel.com>
> Date:   Thu Dec 16 23:12:23 2010 -0500
> 
>     ACPI: use ioremap_cache()
> 
>     Although the temporary boot-time ACPI table mappings
>     were set up with CPU caching enabled, the permanent table
>     mappings and AML run-time region memory accesses were
>     set up with ioremap(), which on x86 is a synonym for
>     ioremap_nocache().
> 
>     Changing this to ioremap_cache() improves performance as
>     seen when accessing the tables via acpidump,
>     or /sys/firmware/acpi/tables.  It should also improve
>     AML run-time performance.
> 
>     No change on ia64.
> 
>     Reported-by: Jack Steiner <steiner@sgi.com>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> :040000 040000 be35c5e8f214f10f94688c1a27f33ecfb8505220
> 52581222d0edf190f160f3e5aa5d2c1af8e76988 M      arch
> :040000 040000 ccdca0d41938b8312e946cde3c01c59b32d1c17c
> 96ccf2357f2ac4a31d19cc41f5728d9f87b6cac0 M      drivers
> 
> Revert of that patch fixes the problem.

Can you send a dmesg output and acpidump output from the failing system, please?

Rafael
