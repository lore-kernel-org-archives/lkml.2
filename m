Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab2IWBTg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 21:19:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab2IWBTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 21:19:33 -0400
From: Thomas Renninger <trenn@suse.de>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/2] ACPI: Override arbitrary ACPI tables via initrd for debugging
Date: Sun, 23 Sep 2012 03:17:03 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.10-0.4-desktop; KDE/4.4.4; x86_64; ; )
Cc: hpa@zytor.com, initramfs@vger.kernel.org, robert.moore@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        yinghai@kernel.org, eric.piel@tremplin-utc.net, vojcek@tlen.pl
References: <1348234085-39220-1-git-send-email-trenn@suse.de> <1348234085-39220-3-git-send-email-trenn@suse.de> <505DD65F.9080203@kernel.org>
In-Reply-To: <505DD65F.9080203@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209230317.04050.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

On Saturday 22 September 2012 17:16:47 Len Brown wrote:
> This isn't a NAK, but I'm at best, "like warm" on this.
We had this discussion already...
And you already had similar patches Signed-off and put in your queue
for Linus in 2008:
http://www.mail-archive.com/linux-acpi@vger.kernel.org/msg11907.html

Iirc they have not been accepted because populate_rootfs was too
late or the way the tables have been passed has been (correctly)
considered a bad approach.

This is the clean re-write.
 
> I'm not convinced it is a good thing to have - enabled by default -
> the ability for users to easily over-ride ACPI tables.
> 
> I am concerned this will result in users hacking their BIOS, and making themselves
> unsupportable by both their HW and SW suppliers.
They can do that already by overriding via re-compiling the kernel.
Making it as hard as possible, also means making debugging ACPI problems
on Linux as hard as possible.
There are quite some bugs that got stuck, because people could not compile
a kernel.
And quite some people who have the knowledge and had overridden their DSDTs
via recompiling the kernel wasted some hours/days (compiling a kernel on the
private laptop at home takes time) and they could have invested their time
better.

> "But it is just a _debug_ capability", one counters, "we'd never have
> to support somebody who actually uses it."
Both is right and these are the answers to most of your concerns.
 
> Even if you toss support (and security) out the window, there is a more insidious
> problem.  When such a user latches onto a workaround that tickles their
> itch, they are satisfied, and they have zero incentive to get
> either their BIOS or Linux fixed for the benefit of other users.
I expect it exactly the other way round:
It has been made clear to report issues.
Currently these guys are more or less on their own, not finding a workaround
or any solution at all.
Now with some help they will find workarounds, post them on the list and
developers will already get a concrete idea of what is going wrong.
 
> Today we have 2 methods to override AML:
> ACPI_CUSTOM_METHOD (default n) allows you to scribble on AML
> on the current running system.
> ACPI_CUSTOM_DSDT (default n) allows you to override the entire DSDT/SSDT,
> but requires you to build that DSDT into the custom kernel itself.
I know, what is so bad to make developing this stuff on Linux "even easier"?

> Developers running on their own systems are not complaining about these.
> 
> But what if you want to debug something on a remote system
> with a distro binary kernel, you say?  The user doesn't know how
> to build a kernel, and the distro is too busy to do so.
> Some distros ship the initrd hack to  address this problem,
> even though it has been repeatedly rejected upstream.
> But curiously, even larger distros do NOT ship that hack
> and somehow they have survived the last decade of Linux/ACPI
> deployment without it.  How is that possible?
>  
> Yes, convenience sounds like an improvement over inconvenience.
> Yes, generality to override any table sounds like a good thing
> over the limitation to override just AML tables.
> But does that make it a good idea?

I do not want to re-discuss the topic all over again if possible,
here my major points:
  - Even on "Linux supported by vendor" systems it can be convenient
    for example for a distribution to be able to prove a bug to be
    a BIOS and not a kernel bug, by simply booting the fixed BIOS
    and verify the issue to be fixed.
  - Quite some BIOS tables, even from vendors supporting Linux, have
    dozens of warnings and errors in their ACPI tables.
    If it is easier to develop and debug ACPI code on Linux, there
    might be more vendors doing that and providing more robust BIOSes.
  - Unfortunately a lot or most laptop/desktop vendors still do not
    care that much about Linux. Quite some systems are sold and nobody
    even tried to boot Linux on them. The BIOS did only get verified
    on Windows. On such systems it's essential that people can find
    out as easy as possible how and why their BIOS behaves like the
    way it does and then contribute that information to the list to get
    things solved.
  - ...
    
> specific comments in-line below...

Thanks a lot for going through it!
I'll address yours (and Yinghai's) findings and try to get an update
sent out on Monday.

    Thomas
