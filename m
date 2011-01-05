Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab1AEMKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 07:10:09 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51121 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab1AEMKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 07:10:07 -0500
Date: Wed, 5 Jan 2011 13:09:59 +0100
From: Borislav Petkov <bp@amd64.org>
To: "James C. Georgas" <james.georgas@yahoo.ca>
Cc: linux-kernel@vger.kernel.org, Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: can't resume from ACPI S3 with TICK_ONESHOT
Message-ID: <20110105120959.GB4927@kryptos.osrc.amd.com>
References: <1294191939.3889.49.camel@Tachyon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294191939.3889.49.camel@Tachyon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 06:45:39PM -0700, James C. Georgas wrote:
> If I enable CONFIG_NO_HZ or CONFIG_HIGH_RES_TIMERS, then I can't resume
> from the ACPI S3 state (AKA suspend to RAM). The fan starts up, and the
> power LED stops blinking and comes back on, but then the fan spins down
> again, the screen stays off, and the system is unresponsive to input. I
> have to power down by holding the power button for four seconds.
> 
> The only thing I can see that both options have in common is that they
> both enable CONFIG_TICK_ONESHOT.
> 
> Here are my kernel config and dmesg. This config has CONFIG_NO_HZ set. I
> get the same result with it unset, and CONFIG_HIGH_RES_TIMERS set
> instead.

Can you try booting with "nohpet" on the kernel command line?

..

> Linux version 2.6.36.2-s2ram (root@Tachyon) (gcc version 4.4.4 (Gentoo 4.4.4-r2 p1.2, pie-0.4.5) ) #7 PREEMPT Tue Jan 4 17:43:43 MST 2011

Is that a vanilla kernel from kernel.org or is it a gentoo one with some
patches ontop?

More questions:

Can you try the freshly released 2.6.37 to see whether you see different
results with it.

Also, are you running the latest BIOS from your chipset vendor? Can you
send dmidecode and "lspci -v" output too?

How exactly do you suspend to RAM? Using pm-suspend from pm-utils?

That should be it for now.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
