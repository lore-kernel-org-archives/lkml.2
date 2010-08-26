Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0HZTxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 15:53:42 -0400
Received: from atl.turmel.org ([74.117.157.138]:33573 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab0HZTxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 15:53:39 -0400
Message-ID: <4C76C641.30901@turmel.org>
Date: Thu, 26 Aug 2010 15:53:37 -0400
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100815 Lightning/1.0b2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Eric.Valette@Free.fr
CC: linux-kernel@vger.kernel.org, Florian Mickler <florian@mickler.org>
Subject: Re: Please add generic support for root=UUID= at kernel parameter
 command line (LABEL, BYID maybe also)
References: <4C728790.7050805@Free.fr> <4C72EE8F.3040708@turmel.org> <4C768919.30104@Free.fr>
In-Reply-To: <4C768919.30104@Free.fr>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On 08/26/2010 11:32 AM, Eric Valette wrote:
> I found a solution myself using the grub embedded "search --fs-uuid". I do it once the linux boot partition and also on one partition of the external disk. If the search on the external disk report an error, I know root=/dev/sda1 else root=/dev/sdb1. But I really think this should be linux job!

Although this works now, there's no guarantee this will continue to work.  What if you plug in an eSATA enclosure that has a port multiplier and two disks?  I think you'll find your root device on /dev/sdc1.  Or maybe someday a robust scheme for simultaneous probing will be adopted (for faster booting, presumably), and the order will vary from boot to boot.

> I also converted my /etc/fstab to LABEL=foo /foo syntax.

That's good.

> Now I'm really puzzled grub2 as a "search by fs uuid" command that linux is unable to deliver for the root device!

The key word here is "unable".  The maintainers aren't *unable* to do this.  They are *unwilling* to do this.  I don't recall the precise discussion, but basically it boils down to the fact that early userspace (aka initramfs) can do this efficiently, and it needs to be supported in initramfs for other reasons, so it is pointless to duplicate this code in the kernel.  I'm sure block folk will chime in if this isn't a fair representation (my apologies in advance if so).

Try dracut.  Seriously.  It's lean and mean just for this use-case, and you'll be protecting yourself against future changes in the block layer.  And you can put root=LABEL=foo on your kernel command line to match your fstab.

Usage (from your kernel source dir):

$ make
$ make modules
# make modules_install
# make install
# dracut [-v] [-f] '' `make kernelrelease`

HTH,

Phil
