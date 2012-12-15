Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946153Ab2LOABZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 19:01:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54306 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945910Ab2LOABX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 19:01:23 -0500
Date: Sat, 15 Dec 2012 00:01:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rob Landley <rob@landley.net>
Cc: Greg Ungerer <gregungerer@westnet.com.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] m68k updates for 3.8
Message-ID: <20121215000115.GT4939@ZenIV.linux.org.uk>
References: <50CB15E3.8010902@westnet.com.au>
 <1355521700.18402.7@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355521700.18402.7@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 03:48:20PM -0600, Rob Landley wrote:
> On 12/14/2012 06:04:51 AM, Greg Ungerer wrote:
> >Hi Rob,
> ...
> >>Somebody got one of my images to boot under aranym but they had
> >>to patch
> >>the kernel fairly extensively to add the emulated device support that
> >>emulator provided. It doesn't emulate real devices the way qemu does,
> >>but qemu doesn't fully emulate the processor (just coldfire in
> >>mainline)...
> >
> >I use aranym for testing m68k. Though I don't really pound to heavily
> >on the devices. I really only cross-compile small systems for testing
> >on it.
> 
> What kernel config do you use for aranym? I don't see an an aranym
> entry in
> arch/m68k/configs, and I stopped using it precisely because it
> required several large patches to add emulated device support for
> everything from serial console to block devices. (There was a kernel
> upgrade, it broke, I cut a release without it. Pretty much the same
> reason I stopped using squashfs for a year or so until it finally
> got merged.)

config NATFEAT
        bool "ARAnyM emulator support"
        depends on ATARI
        help
          This option enables support for ARAnyM native features, such as
          access to a disk image as /dev/hda.

followed by rather obvious options that depend on it (block/console/NIC).
