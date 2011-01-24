Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab1AXND0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 08:03:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:57770 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab1AXNDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 08:03:24 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: acpi_button: random oops on boot
Date: Mon, 24 Jan 2011 14:03:21 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-8.99.14.138eeaa-desktop; KDE/4.5.95; x86_64; ; )
Cc: Tobias Karnat <tobias.karnat@googlemail.com>, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        richard.coe@med.ge.com, jslaby@novell.com
References: <1291477752.5096.27.camel@Tobias-Karnat> <1291679699.6246.11.camel@Tobias-Karnat> <20101207051521.GA16804@helgaas.com>
In-Reply-To: <20101207051521.GA16804@helgaas.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101241403.21707.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 07, 2010 06:15:21 AM Bjorn Helgaas wrote:
> On Tue, Dec 07, 2010 at 12:54:59AM +0100, Tobias Karnat wrote:
... 
> > Couldn't this be a compiler issue?
> > Adding some printk's to fix it seems to be insane.
> 
> Agreed, adding printk's is absolutely not any kind of fix.
> I think it's more likely to be some sort of memory corruption or
> race than a compiler problem.  I assume there is some old kernel
> that works fine, even when compiled with the same compiler.
> 
> In addition to the isolation ideas I suggested above, you might
> boot with "maxcpus=1" and turn on all the Kconfig memory debug
> switches.
Aren't there some memory corruption checkers which can
additionally be enabled?

CONFIG_DEBUG_SLAB
Say Y here to have the kernel do limited verification on memory
allocation as well as poisoning memory on free to catch use of freed
memory. This can make kmalloc/kfree-intensive workloads much slower.

CONFIG_DEBUG_VM
Enable this to turn on extended checks in the virtual-memory system
that may impact performance.

CONFIG_DEBUG_LIST
Enable this to turn on extended checks in the linked-list
walking routines.

CONFIG_DEBUG_PAGEALLOC
Unmap pages from the kernel linear mapping after free_pages().
This results in a large slowdown, but helps to find certain types
of memory corruption.

Did I oversee one?

Not sure which is best, it should not hurt to turn on all
(if possible) for a test.

    Thomas
