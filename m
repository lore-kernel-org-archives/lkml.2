Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab0KPW2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:28:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54669 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab0KPW2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:28:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.37-rc1+: hibernate regression, claims not enough swap space
Date: Tue, 16 Nov 2010 23:27:27 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1-rjw+; KDE/4.4.4; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <20101114052138.GB2189@elf.ucw.cz> <201011152326.44357.rjw@sisk.pl> <20101116052634.GA30449@elf.ucw.cz>
In-Reply-To: <20101116052634.GA30449@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011162327.27454.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 16, 2010, Pavel Machek wrote:
> Hi!
> 
> > > ...but there's enough -- or at least it was enough to fit previous
> > > versions. 32-bit machine, so it has highmem.
> > > 
> > > System is in console mode, very lightly loaded.
> > > 
> > > Mem:   2054716k total,   736548k used,  1318168k free,    15368k buffers
> > > Swap:   779148k total,     2360k used,   776788k free,   546388k cached
> > 
> > Well, the swap is rather in short supply.  Below the 50% of RAM recommendation.
> 
> Well, but the biggest image we can write is not 50% of RAM, but 50% of
> lowmem... 

No, it is not.  It's been 50% of RAM for a couple of years now. :-)

> and swap is nearly as big as lowmem in this case -- so this
> machine is not misconfigured.
> 
> root@amd:/# cat /proc/meminfo 
> MemTotal:        2054716 kB
> MemFree:          192048 kB
> Buffers:           97628 kB
> Cached:          1427088 kB
> SwapCached:            0 kB
> Active:           547580 kB
> Inactive:        1091744 kB
> Active(anon):      57060 kB
> Inactive(anon):    58908 kB
> Active(file):     490520 kB
> Inactive(file):  1032836 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> HighTotal:       1178440 kB
> HighFree:         128092 kB
> LowTotal:         876276 kB
> LowFree:           63956 kB
> SwapTotal:        779148 kB
> SwapFree:         779148 kB
> 
> > > thinkpad_acpi: ACPI backlight control delay disabled
> > > PM: thaw of devices complete after 539.577 msecs
> > > PM: writing image.
> > > PM: Free swap pages: 194166
> > > PM: Not enough free swap
> > > Restarting tasks ...
> > > 
> > > Aha, and it is the new default /sys/power/image_size .. setting it to
> > > 0 lets machine hibernate. I guess the new default is very wrong for
> > > highmem machine...
> > 
> > The old default did the wrong thing for everyone with sufficient swap (it made
> > the OOM code trigger every time while preparing to create an image), so I think
> > the new one it's better overall.
> 
> OOM? No... image_size of 0 should have written "as small image as
> possible"; slow, but should not OOM.

This is not how it works now.  We preallocate memory to create memory pressure,
so if image_size is 0, we need to preallocate until we run out of pages that
can be freed, which means OOM.

Thanks,
Rafael
