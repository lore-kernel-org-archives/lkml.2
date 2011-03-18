Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab1CRQAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 12:00:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61476 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab1CRP75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:59:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tim Soderstrom <tim@moocowproductions.org>
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
Date: Fri, 18 Mar 2011 16:59:46 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-usb@vger.kernel.org,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
References: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan> <30463798-7ACB-4248-8CDC-CEFCB6ABC0BE@moocowproductions.org>
In-Reply-To: <30463798-7ACB-4248-8CDC-CEFCB6ABC0BE@moocowproductions.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103181659.46558.arnd@arndb.de>
X-Provags-ID: V02:K0:aBQNQtlbjpLvkPZAOHD+/W3vtq+dep8dpgS2X6MkrCH
 fgysC+rw1U/W4zlq5lU/y8q91cAxZkqEQb8UtACiQV4/ECiqZd
 aTfPdcxE3C4zcYc6Hj2NAynKXEiPAkEHOXr6o8tTg+tAeWKzT6
 1Un6biU8kuWAU/oRSR0pmOyofwRJ7a6rGUDXbMu8rtkQhjKocp
 YXco8cJx8dlxbVEz1Y9bA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 March 2011, Tim Soderstrom wrote:

> > 
> > However, after some amount of time, the errors occur below, is this USB
> > stick failing?  Since it has no SMART, is there any other way to verify
> > the 'health' of a USB stick?
> 
> What prompted you to go with XFS over, say, ext2? The journal will generally
> cause quite a bit more writes onto your USB device. I use ext2 on my CF card 
> in my NAS for that reason (the spinning media is on XFS of course). I know
> that's not an answer to your problem but thought I would add it as a suggestion :)

Using ext2 on flash media instead of ext3 or other file systems is
recommended a lot, but the situation is actually much more complex.
In https://lwn.net/Articles/428584/, I explain how these things work
under the cover. For a drive that can only have very few erase blocks
open, using a journaled file system will always mean thrashing, but
for drives with more open erase blocks, it's probably better to
use a journal than not.

I still need to do simulations to figure out how this exactly
ends up on various file systems, and I had not considered XFS
so far.

Getting back to the rogiinal question, I'd recommend testing the
stick by doing raw accesses instead of a file system. A simple

dd if=/dev/sdX of=/dev/zero iflag=direct bs=4M

will read the entire stick and report any errors. The corresponding

dd of=/dev/zero of=/dev/sdX oflag=direct bs=4M

writes the entire stick. Some media won't report errors on write,
though, so this might not help you at all.

I'm also interested in results from flashbench
(git://git.linaro.org/people/arnd/flashbench.git, e.g. like
http://lists.linaro.org/pipermail/flashbench-results/2011-March/000039.html)
That might help explain how the stick failed.

	Arnd


	Arnd
