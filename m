Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab2E1QrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 12:47:04 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34576 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab2E1QrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 12:47:02 -0400
Date: Mon, 28 May 2012 18:46:26 +0200 (CEST)
From: Eldad Zack <eldadzack@gmail.com>
X-X-Sender: eldad@debianer
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <jejbbe@hansenpartnership.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Miller <davem@davemloft.net>, mroos@linux.ee,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: 3.4.0-02580-g72c04af regression on sparc64 - partitions not
 recognized
In-Reply-To: <201205252127.21436.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.02.1205281835400.32511@debianer>
References: <Pine.LNX.4.44L0.1205251034190.1907-100000@iolanthe.rowland.org> <201205252127.21436.rjw@sisk.pl>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 25 May 2012, Rafael J. Wysocki wrote:
> On Friday, May 25, 2012, Alan Stern wrote:
> > On Fri, 25 May 2012, James Bottomley wrote:
> > 
> > Whether or not the boot kernel can have modular drivers isn't clear to me;
> 
> It can, but then the code in question is irrelevant and the resume has to
> be triggered in a different way.  For example, by writing to
> /sys/power/resume from the initrd boot scripts.
> 
> > I don't know when the check for a valid image in the swap area is carried
> > out in relation to starting up the initramfs task.
> 
> This particular one is carried out before the initrd is loaded.

I just got hit by this one too, but on x86 qemu. There's no initrd, and all
the modules are built in.

With commit a7a20d103994fd760766e6c9d494daa569cbfe06 the kernel doesn't 
get to the point where it reads the partition table.

If it's of any help, I can provide more details.

Eldad
