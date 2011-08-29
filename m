Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab1H2TSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 15:18:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab1H2TSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 15:18:16 -0400
Date: Mon, 29 Aug 2011 22:18:58 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: Broken pci_block_user_cfg_access interface
Message-ID: <20110829191858.GA9415@redhat.com>
References: <20110829150552.GA6851@redhat.com>
 <4E5BB358.3060705@siemens.com>
 <4E5BDEAB.5000405@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5BDEAB.5000405@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 08:47:07PM +0200, Jan Kiszka wrote:
> On 2011-08-29 17:42, Jan Kiszka wrote:
> > I still don't get what prevents converting ipr to allow plain mutex
> > synchronization. My vision is:
> >  - push reset-on-error of ipr into workqueue (or threaded IRQ?)
> 
> I'm starting to like your proposal: I had a look at ipr, but it turned
> out to be anything but trivial to convert that driver. It runs its
> complete state machine under spin_lock_irq, and the functions calling
> pci_block/unblock_user_cfg_access are deep inside this thing. I have no
> hardware to test whatever change, and I feel a bit uncomfortable asking
> Brian to redesign his driver that massively.
> 
> So back to your idea: I would generalize pci_block_user_cfg_access to
> pci_block_cfg_access. It should fail when some other site already holds
> the access lock, but it should remain non-blocking - for the sake of ipr.

It would be easy to have blocking and non-blocking variants.

But
- I have no idea whether supporting sysfs config/reset access
  while ipr is active makes any sense - I know we need it for uio.
- reset while uio handles interrupt needs to block, not fail I think


> We should still provide generic pci-2.3 IRQ masking services, but that
> could be done in a second step. I could have a look at this.
> 
> Jan
> 
> -- 
> Siemens AG, Corporate Technology, CT T DE IT 1
> Corporate Competence Center Embedded Linux
