Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692Ab2IKKlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 06:41:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:61086 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab2IKKlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 06:41:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,404,1344236400"; 
   d="scan'208";a="220668407"
Date: Tue, 11 Sep 2012 12:41:16 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Peter Tyser <ptyser@xes-inc.com>, Aaron Sierra <asierra@xes-inc.com>
Subject: Re: [PATCH] gpio-ich: Share ownership of GPIO groups
Message-ID: <20120911104116.GR3647@sortiz-mobl>
References: <20120723173415.5b80b28b@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120723173415.5b80b28b@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Mon, Jul 23, 2012 at 05:34:15PM +0200, Jean Delvare wrote:
> The ICH chips have their GPIO pins organized in 2 or 3 independent
> groups of 32 GPIO pins. It can happen that the ACPI BIOS wants to make
> use of pins in one group, preventing the OS to access these. This does
> not prevent the OS from accessing the other group(s).
> 
> This is the case for example on my Asus Z8NA-D6 board. The ACPI BIOS
> wants to control GPIO 18 (group 1), while I (the OS) need to control
> GPIO 52 and 53 (group 2) for SMBus multiplexing.
> 
> So instead of checking for ACPI resource conflict on the whole I/O
> range, check on a per-group basis, and consider it a success if at
> least one of the groups is available for the OS to use.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Peter Tyser <ptyser@xes-inc.com>
> Cc: Aaron Sierra <asierra@xes-inc.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
> That's probably not the nicest code you've seen, but everything else I
> could think of either couldn't work or was looking worse. If anyone can
> think of a better approach, I'm all ears.
> 
>  drivers/gpio/gpio-ich.c     |   79 +++++++++++++++++++++++++++++++++++++------
>  drivers/mfd/lpc_ich.c       |   29 ++++++++++++++-
>  include/linux/mfd/lpc_ich.h |    1 
>  3 files changed, 97 insertions(+), 12 deletions(-)
Applied (finally) to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
