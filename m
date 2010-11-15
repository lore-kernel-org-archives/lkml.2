Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab0KOW15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:27:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51260 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050Ab0KOW15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:27:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.37-rc1+: hibernate regression, claims not enough swap space
Date: Mon, 15 Nov 2010 23:26:44 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1-rjw+; KDE/4.4.4; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <20101114052138.GB2189@elf.ucw.cz>
In-Reply-To: <20101114052138.GB2189@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011152326.44357.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 14, 2010, Pavel Machek wrote:
> Hi!

Hi,

> ...but there's enough -- or at least it was enough to fit previous
> versions. 32-bit machine, so it has highmem.
> 
> System is in console mode, very lightly loaded.
> 
> Mem:   2054716k total,   736548k used,  1318168k free,    15368k buffers
> Swap:   779148k total,     2360k used,   776788k free,   546388k cached

Well, the swap is rather in short supply.  Below the 50% of RAM recommendation.

> thinkpad_acpi: ACPI backlight control delay disabled
> PM: thaw of devices complete after 539.577 msecs
> PM: writing image.
> PM: Free swap pages: 194166
> PM: Not enough free swap
> Restarting tasks ...
> 
> Aha, and it is the new default /sys/power/image_size .. setting it to
> 0 lets machine hibernate. I guess the new default is very wrong for
> highmem machine...

The old default did the wrong thing for everyone with sufficient swap (it made
the OOM code trigger every time while preparing to create an image), so I think
the new one it's better overall.

Thanks,
Rafael
