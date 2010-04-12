Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab0DLLxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 07:53:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45217 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab0DLLxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 07:53:06 -0400
Date: Mon, 12 Apr 2010 13:53:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Daniel Mack <daniel@caiaq.de>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, Pedro Ribeiro <pedrib@gmail.com>,
       akpm@linux-foundation.org, Greg KH <gregkh@suse.de>,
       alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100412115300.GM18855@one.firstfloor.org>
References: <20100407090623.GN30807@buzzloop.caiaq.de> <Pine.LNX.4.44L0.1004071036060.1779-100000@iolanthe.rowland.org> <87sk719hbm.fsf@basil.nowhere.org> <20100412111439.GU30801@buzzloop.caiaq.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412111439.GU30801@buzzloop.caiaq.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Which is exactly what usb_buffer_alloc() does already. So at least for
> x86 you say this is the right thing to do? However, we don't necessarily
> need coherent memory on other platforms, which is why I hessitate to
> enforce that type of memory for all transfer_buffer allocations.

Yes today it's faster at least.

Probably we should have better interfaces for this, but we don't.

> 
> > Or just use GFP_KERNEL and pci_map_* later.
> 
> The USB core does this already, but at least on Pedro's machine, this
> seems unsufficient. Unfortunately, I can't reproduce the issue yet, even
> with more than 4GB of RAM installed.

Then something must be broken in Pedro's system and likely other drivers
will also not work. I don't think it should be worked around in the USB layer.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
