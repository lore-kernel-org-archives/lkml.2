Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab0DNW16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 18:27:58 -0400
Received: from sous-sol.org ([216.99.217.87]:43022 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755914Ab0DNW15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 18:27:57 -0400
Date: Wed, 14 Apr 2010 15:25:50 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>, Daniel Mack <daniel@caiaq.de>,
       USB list <linux-usb@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       iommu@lists.linux-foundation.org, Chris Wright <chrisw@sous-sol.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100414222550.GB25962@sequoia.sous-sol.org>
References: <Pine.LNX.4.44L0.1004141300180.1716-100000@iolanthe.rowland.org>
 <1271270197.31006.2133.camel@macbook.infradead.org>
 <u2l74fd948d1004141412we3597f40q9ad5a29253c69164@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <u2l74fd948d1004141412we3597f40q9ad5a29253c69164@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pedro Ribeiro (pedrib@gmail.com) wrote:
> Turns out CONFIG_DMAR was disabled because of PREEMPT_RT. I disabled
> the later and enabled _DMAR. It took a long time to boot, something
> wrong with the usb ports. You can see it in the appended dmesg from
> time 11s to 100s.
> 
> Then after it booted, I could barely move my USB mouse and lots of
> errors appeared on dmesg. I tried to connect the DVB card but it
> wouldn't even initialize.

[  316.360045] DMAR:[DMA Write] Request device [00:02.0] fault addr 23c00000 
[  316.360046] DMAR:[fault reason 05] PTE Write access is not set

That's your video device.  Do you have CONFIG_DMAR_BROKEN_GFX_WA=y?

> Enabling it with iommu=pt seemed to make no difference.

It should (it should at least eliminate the video device problem).
