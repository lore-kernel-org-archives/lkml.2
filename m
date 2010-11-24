Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab0KXP3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 10:29:49 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51888 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab0KXP3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 10:29:48 -0500
Date: Wed, 24 Nov 2010 10:25:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Frantisek Hanzlik <franta@hanzlici.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrea Merello <andreamrl@tiscali.it>,
        Michael Wu <flamingice@sourmilk.net>
Subject: Re: rtl8180 freeze some i386 systems
Message-ID: <20101124152506.GA7435@tuxdriver.com>
References: <4CEBA51C.5010604@hanzlici.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEBA51C.5010604@hanzlici.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 12:27:24PM +0100, Frantisek Hanzlik wrote:
> On two PCs with Fedora 14/i386 these systems freezes just after command
> "ip link set wlan0 up" was entered.
> "freezes" meant system is totally unuseable, ping to LAN interface
> hasn't reply, kbd/mouse not work, only way is HW reset/power off.
> 
> This hang occurs always independently on system runlevel: when switch to
> runlevel 1, when only kernel threads + udev + root bash are active,
> system still hangs.
> Systems hangs on all tested kernels 2.6.34, 2.6.35.9 and 2.6.36.
> Systems hangs with implicit cmdline and too when using "nomodeset",
> "acpi=noirq", "acpi=off", "pci=biosirq", "pci=routeirq", "pci=noacpi"
> parameters.
> 
> I have two Zyxel "G-302 v3" wifi adapters reported as RTL 8185 rev 20
> (10ec:8185), which on other two PCs with F1{3,4}/i386 and same config
> works well.
> 
> Can someone help with? Is some general method for solving this issue?

Sorry for the late reply -- I wanted to attempt to recreate the issue.
Unfortunately(?) I am not seeing any such problem.  My card is a PCCard
apparently sold by CompUSA, but the chipset reported in dmesg matches
yours (i.e. RTL8185vD + rtl8225).

I have tried vanilla 2.6.34 and 2.6.35 as well as the Fedora-provided
2.6.35.6-48.fc14 -- all seem to work equally well, despite the annoying
warning that continues to pop-up during scans.  (I need to get that
fixed in Fedora!)

Could you try using netconsole to capture a backtrace over an ethernet
connection?

If that doesn't work, you might try doing a git bisect from the last
working kernel (2.6.33?) to the first broken one (2.6.34?).

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
