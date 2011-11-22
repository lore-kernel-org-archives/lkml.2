Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1KVRyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:54:15 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:45559 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab1KVRyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:54:14 -0500
Date: Tue, 22 Nov 2011 18:54:02 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jean-Francois Dagenais <jeff.dagenais@gmail.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg KH <gregkh@suse.de>,
        tglx@linutronix.de, linux-pci@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: extra large DMA buffer for PCI-E device under UIO
Message-ID: <20111122175402.GC15508@local>
References: <B458B2F0-2DDA-461F-A125-8C6C4CDEB6C5@gmail.com>
 <20111118220849.GA25205@suse.de>
 <9E9C8A95-723C-427A-AD01-17284EDF7E4F@gmail.com>
 <20111121173620.GA5028@suse.de>
 <20111121181724.GB12011@local>
 <4498E0C9-B5E9-44B5-8868-140D6416100E@gmail.com>
 <20111122153525.GB17268@redhat.com>
 <40906F5E-5E97-44CF-AB95-40355204B63F@gmail.com>
 <20111122173722.GA29068@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122173722.GA29068@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 07:37:23PM +0200, Michael S. Tsirkin wrote:
[...]
> > Or am I better off with a UIO solution?
> 
> You should probably write a proper kernel driver, not a UIO one.
> your kernel driver would have to prevent the device fom DMA into memory
> outside the allocated range, even if userspace is malicious.
> That's why UIO is generally not recommended for PCI devices that do DMA.

When UIO was designed, the main goal was the ability to handle interrupts
from userspace. There was no requirement for DMA. In fact, in five years I
didn't get one real world device on my desk that needed it. That doesn't
mean there are no such devices. Adding DMA support to the UIO core was
discussed several times but noone ever did it. Ideas are still welcome...

If parts of the driver should be in userspace, you should really try
to extend the UIO core instead of re-implementing UIO functionality in
a "proper kernel driver".

Thanks,
Hans

