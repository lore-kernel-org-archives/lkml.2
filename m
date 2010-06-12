Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab0FLS7K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 14:59:10 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:44267 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab0FLS7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 14:59:08 -0400
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.44
X-Originating-IP: 74.107.143.84
Date: Sat, 12 Jun 2010 11:55:39 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, x86@kernel.org,
       584846@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bug#584846: Detects only 64MB and fails to boot on Intel Green
 City board if e820 hooked by GRUB2
Message-ID: <20100612185538.GA4511@feather>
References: <20100612060322.29053.94187.reportbug@feather>
 <1276351120.14011.194.camel@localhost>
 <4C13D1E7.7060604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C13D1E7.7060604@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 12, 2010 at 11:28:55AM -0700, H. Peter Anvin wrote:
> On 06/12/2010 06:58 AM, Ben Hutchings wrote:
> > Josh Triplett reported this problem with memory sizing:
> > 
> >>
> >> A kernel built from c549e71d073a6e9a4847497344db28a784061455 finds <64MB
> >> of RAM; a kernel built from c549e71d073a6e9a4847497344db28a784061455^
> >> successfully finds all 4GB of RAM.
> >>
> >> Also note that newer upstream kernels, including v2.6.35-rc3, fail as
> >> well.  Since later kernels revert part of the above commit, the issue
> >> must lie with the parts of the commit not reverted.
> >>
> >> And, again, I can reproduce this using the stock upstream GRUB2 1.98
> >> release built from source, by booting it from a USB key, and then
> >> booting the disk MBR via:
> >>
> >> set root=(hd1)
> >> drivemap (hd1) (hd0)
> >> chainloader +1
> >> boot
> >>
> >> Nothing special about drivemap here; anything that uses grub's mmap
> >> module to reserve memory via e820 (GRUB_MACHINE_MEMORY_RESERVED) will
> >> cause grub to hook e820 and trigger this bug.  However, in stock grub,
> >> only drivemap does this.
> >>
> 
> It's kind of hard to know what is involved, since clearly it relates to
> Grub2, which -- how do I say this politely -- seems to excel at doing
> things in the most inferior way possible.  This is a great example of that.
> 
> The most likely reason it fails is because Grub2 uses ACPI 3-style reads
> of the board memory map, gets wrong results for the same reasons the
> kernel do, and then pass then downstream to the kernel.  As such, there
> is absolutely nothing the kernel can do about it.

grub2 doesn't do ACPI 3 reads; it always asks for 20 bytes, not 24.

Also, note that it works with older Linux kernels (before the commit in
question) and fails with newer ones.  That doesn't rule out the
possibility of a grub bug instead of a Linux bug, but since older Linux
somehow coped with the situation, it seems like a regression that newer
Linux cannot cope.

- Josh Triplett
