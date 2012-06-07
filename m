Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826Ab2FGRId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:08:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:60584 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760643Ab2FGRIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:08:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="176256197"
From: Andi Kleen <andi@firstfloor.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Khalid Aziz <khalid.aziz@hp.com>, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, linux-pci@vger.kernel.org
Subject: Re: [PATCH] Disable Bus Master on PCI device shutdown
References: <20120427190033.GA17588@ldl.usa.hp.com>
	<20120606135009.GB1517@srcf.ucam.org>
Date: Thu, 07 Jun 2012 10:08:31 -0700
In-Reply-To: <20120606135009.GB1517@srcf.ucam.org> (Matthew Garrett's message
	of "Wed, 6 Jun 2012 14:50:09 +0100")
Message-ID: <m2wr3jhwxc.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg@redhat.com> writes:
>
> This protects against the case where a piece of hardware is continuing 
> to DMA even after the driver shutdown method has been called? I'm not 
> convinced this is safe. Some Broadcom parts will crash if busmastering 
> is disabled while they're still performing DMA, and they'll then hang 
> the bus if reenabled. There's also the risk that the hardware will start 
> DMAing again if it's reenabled after being shut down. It seems like 
> you're covering over the case where the driver didn't correctly quiesce 
> the hardware, but you risk triggering other bugs instead.

One alternative I've been pondering some time is to use AER link reset
instead. But this is mainly on servers, a lot of clients don't have it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
