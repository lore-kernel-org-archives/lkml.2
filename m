Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab0KISCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:02:15 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:60818 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab0KISCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:02:14 -0500
Date: Tue, 9 Nov 2010 19:01:23 +0100
From: Borislav Petkov <bp@amd64.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Clemens Ladisch <clemens@ladisch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>
Subject: Re: HPET (?) related hangs and breakage in 2.6.35,36
Message-ID: <20101109180123.GB31121@aftab>
References: <AANLkTikA6hZDV0A30fku7VT7Z1P8OqxcsF-EK95pBdD=@mail.gmail.com>
 <4CD966D8.4000602@ladisch.de>
 <20101109153805.GB3146@kryptos.osrc.amd.com>
 <AANLkTi=cUGGpkgWcbX=KMxzu+E=Toy_O+LeLoAFFUAsh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=cUGGpkgWcbX=KMxzu+E=Toy_O+LeLoAFFUAsh@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 12:44:48PM -0500, Andrew Lutomirski wrote:
> I may have just reproduced after a couple of days of uptime it in
> 2.6.36 with hpet=disable (in any case, the system hung and netconsole
> didn't work).
> 
> I'm currently testing the hpet_min_tick stuff, backported to 2.6.36,
> with hpet on.  Haven't had a problem yet, but I'll see what happens
> after a few hours.  So far, it said:
> 
> ACPI: HPET id: 0x8086a301 base: 0xfed00000 min tick: 128

This doesn't say what your BIOS has set it to originally. For that, do

hexdump -C /sys/firmware/acpi/tables/HPET

and check what does the u16 little endian value at offset 0x35 say.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
