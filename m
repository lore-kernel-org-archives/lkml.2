Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab0IOXq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 19:46:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57984 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab0IOXq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 19:46:56 -0400
Message-ID: <4C915AB2.9090203@zytor.com>
Date: Wed, 15 Sep 2010 16:45:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Becker <chemobejk@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] PCI: allocate bus resources from the top down
References: <20100915210818.12365.58732.stgit@bob.kio> <20100915210912.12365.78836.stgit@bob.kio> <4C913F96.4020106@zytor.com> <201009151644.38563.bjorn.helgaas@hp.com>
In-Reply-To: <201009151644.38563.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2010 03:44 PM, Bjorn Helgaas wrote:
> 
> I'd like to do that, but I don't see a good way to do it yet.
> 
> We saw the problem on a T3500, a T3400, and a T4500, and I'm sure there
> are others.  So I don't know how to identify the affected machines.
> 
> And I don't know how to identify the invalid ranges, because I suspect
> it depends on the memory size.  I think it would be quite unusual for
> a window to start 1MB under the nice 256MB boundary, but I'm not sure
> I'm ready to say that's always illegal.
> 
> On these machines, the [mem 0xbff00000-0xbfffffff] area is actually
> reported as reserved in the E820 map, and I first thought we could
> simply rely on that.  But I'm not really comfortable with that either,
> because I don't think there's a dependable relationship between those
> E820 entries and ACPI and PCI devices.  For one thing, I experimented
> with Windows, and it happily places PCI devices in reserved areas,
> and I think we're likely to trip over more BIOS bugs if we rely on
> something Windows doesn't.
> 
> I suspect Windows would blow up, too, if we could somehow fill up the
> rest of the window and force it to allocate the bottom.  But since
> it's only a 1MB area, I think that would be very difficult to do
> unless there's some way to tweak PCI BARs before booting Windows.
> 

If we put PCI devices in E820 RESERVED areas that's a bug, plain and
simple.  We should absolutely not doing so!

To some degree I don't care if Windows does or not ... that is the
documented mechanism for reserving address space, and we should respect
that.  Furthermore, we use the same mechanism internally for reserving
address space.

Furthermore, the only potentially bad outcome is reserving excessive
address space, which is in general safer than the opposite.

So let's just fix this.

	-hpa
