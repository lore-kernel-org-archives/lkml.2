Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab2GaQdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:33:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:29341 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab2GaQdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:33:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="128893240"
Date: Tue, 31 Jul 2012 09:33:08 -0700
From: Jon Mason <jon.mason@intel.com>
To: Jianbin Kang <kjbmail@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>
Subject: Re: [RFC v2 1/2] PCI-Express Non-Transparent Bridge Support
Message-ID: <20120731163308.GA13610@jonmason-lab>
References: <1343607994-32415-1-git-send-email-jon.mason@intel.com>
 <1343607994-32415-2-git-send-email-jon.mason@intel.com>
 <CAErSpo4p_hxvCeVGqiTXVq3itXepheQZerpqRHwLvG6A7R2Lcg@mail.gmail.com>
 <20120730181542.GA987@jonmason-lab>
 <CAF8raN6M0_TWyCCzjyXZcFYP=vgFaqQg4hNmNpBxSM+D0C_Bpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF8raN6M0_TWyCCzjyXZcFYP=vgFaqQg4hNmNpBxSM+D0C_Bpg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 11:35:33AM +0800, Jianbin Kang wrote:
> > I've tried to make it all generic enough that non-Intel NTBs should plug in with
> > minimal changes to ntb_hw.c.  If their design is too divergent, then a slight
> > redesign of ntb_hw.c might be necessary.  But from what I've seen of other
> > designs on the internet, they appear to be extremely similar.  The transport and
> > client drivers were written with the hardware abstracted away as much as
> > possible to prevent the need to modify it for different hardware.  If there is
> > anything which is Intel hardware specific, I'd be happy to change it to make it
> > more generic.
>   In ntb_process_tx(), ntb uses hard-coding 'memcpy_toio' to copy data
> to remote.
>   Is it better to provide a function pointer like 'tx()' and call qp->tx().
>   memcpy_toio is a slow operation. Some hardware can setup a dma
> transfer and wait.
> 
>   IMHO, the best way is to handle tx in async mode. But it requires
> lots of modification.

Actually this is what I'm working on now, using async_tx to replace the
memcpy.  I believe the changes shouldn't be that significant.

Is the "hardware that can setup dma" you refer to something that does
not use this interface?

Thanks,
Jon
