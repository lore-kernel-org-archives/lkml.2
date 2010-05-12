Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab0ELPVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:21:52 -0400
Received: from mga05.intel.com ([192.55.52.89]:36915 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752791Ab0ELPVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:21:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,215,1272870000"; 
   d="scan'208";a="797792184"
Date: Wed, 12 May 2010 08:21:37 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Clemens Ladisch <clemens@ladisch.de>, Tejun Heo <tj@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Joe Perches <joe@perches.com>, USB list <linux-usb@vger.kernel.org>,
       alsa-devel@alsa-project.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Use of start_frame in usbusx2yaudio.c
Message-ID: <20100512152137.GA3358@xanatos>
References: <20100512051058.GA32459@xanatos>
 <Pine.LNX.4.44L0.1005121051040.1962-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005121051040.1962-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 10:54:23AM -0400, Alan Stern wrote:
> On Tue, 11 May 2010, Sarah Sharp wrote:
> 
> > Are there any drivers in the kernel that set urb->start_frame on every
> > URB?
> > 
> > Could those drivers handle it if only the first URB they submitted to
> > the host controller was scheduled for that frame ID, and all the rest of
> > the URBs were scheduled ASAP?
> 
> BTW, urb->start_frame generally is ignored as an input parameter.  Many 
> host controller drivers pay no attention to it.  Unless someone has a 
> real reason, I think we are better off not using it.

Oh good.  In theory, the xHCI driver is supposed to be able to set the
starting frame ID of an isoc transfer (although the current patches for
isoc don't do that).  The xHCI spec writers were looking at limiting
software to only being able to set the frame ID on the very first
transfer you enqueue to the endpoint, to limit the complexity of the
hardware scheduler.  It looks like they won't have an issue with legacy
drivers if they do.

Sarah Sharp
