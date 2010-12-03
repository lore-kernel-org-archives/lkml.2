Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402Ab0LCOOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:14:07 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:50278 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758349Ab0LCOOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:14:06 -0500
Date: Fri, 3 Dec 2010 15:13:58 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: ming.m.lin@intel.com, robert.moore@intel.com, len.brown@intel.com
Cc: Calvin Walton <calvin.walton@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [Regression] 2.6.37-rc1: Lenovo T61 mute button does not work
Message-ID: <20101203141358.GA6936@ics.muni.cz>
References: <20101130185303.GI10354@ics.muni.cz>
 <1291172324.14274.33.camel@nayuki>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1291172324.14274.33.camel@nayuki>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 03 Dec 2010 15:13:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 30, 2010 at 09:58:44PM -0500, Calvin Walton wrote:
> > in 2.6.36, mute button worked as expected on my ThinkPad T61 - it toggled
> > mute with mixer applet notification. In 2.6.37-rc1, it only mutes without any
> > event to any mixer applet.

[...]

> By default on this series of laptops, Linux runs with the ACPI
> _OSI(Linux) exported - when the bios of this laptop model sees that it's
> running on Linux, it disables the hardware mute functionality and the
> mute button acts as a standard keyboard key.
> 
> Search your dmesg for lines containing '_OSI(Linux)' - it should say
> that a BIOS query was honoured. Make sure you do not have 'acpi_osi="!
> Linux"' on your kernel command line.

The breaking commit is this one: b0ed7a915abac309fcb5a51bccd3782e3daa7417

This changes 
[    0.200241] ACPI: BIOS _OSI(Linux) query honored via DMI
to
[    0.200241] ACPI: BIOS _OSI(Linux) query honored via cmdline

which apparently does not work with Lenovo T61.

-- 
Luká¹ Hejtmánek
