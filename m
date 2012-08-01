Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab2HAKRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 06:17:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:3536 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab2HAKRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 06:17:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="174019393"
Date: Wed, 1 Aug 2012 12:16:46 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>,
        Aaron Sierra <asierra@xes-inc.com>
Subject: Re: [PATCH] gpio-ich: Share ownership of GPIO groups
Message-ID: <20120801101646.GG16859@sortiz-mobl>
References: <20120723173415.5b80b28b@endymion.delvare>
 <20120801111359.6839bec7@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120801111359.6839bec7@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Wed, Aug 01, 2012 at 11:13:59AM +0200, Jean Delvare wrote:
> On Mon, 23 Jul 2012 17:34:15 +0200, Jean Delvare wrote:
> > The ICH chips have their GPIO pins organized in 2 or 3 independent
> > groups of 32 GPIO pins. It can happen that the ACPI BIOS wants to make
> > use of pins in one group, preventing the OS to access these. This does
> > not prevent the OS from accessing the other group(s).
> > 
> > This is the case for example on my Asus Z8NA-D6 board. The ACPI BIOS
> > wants to control GPIO 18 (group 1), while I (the OS) need to control
> > GPIO 52 and 53 (group 2) for SMBus multiplexing.
> > 
> > So instead of checking for ACPI resource conflict on the whole I/O
> > range, check on a per-group basis, and consider it a success if at
> > least one of the groups is available for the OS to use.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Cc: Peter Tyser <ptyser@xes-inc.com>
> > Cc: Aaron Sierra <asierra@xes-inc.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > ---
> > That's probably not the nicest code you've seen, but everything else I
> > could think of either couldn't work or was looking worse. If anyone can
> > think of a better approach, I'm all ears.
> > 
> >  drivers/gpio/gpio-ich.c     |   79 +++++++++++++++++++++++++++++++++++++------
> >  drivers/mfd/lpc_ich.c       |   29 ++++++++++++++-
> >  include/linux/mfd/lpc_ich.h |    1 
> >  3 files changed, 97 insertions(+), 12 deletions(-)
> 
> Grant, Samuel, Linus (sorry for not including you on original
> submission), any comment on this? I suppose it's too late for 3.6 but
> can this be scheduled to be integrated in 3.7?
I was planning to look at this one and queue it for 3.7 as I'll be working on
my for-next branch once rc1 is tagged.
As you said, this is not the nicest code ever, so I may have a few comments.
No time for that right now though.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
