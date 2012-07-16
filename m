Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab2GPN2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 09:28:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:34930 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab2GPN2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:28:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="166899679"
Date: Mon, 16 Jul 2012 15:28:05 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Qiao Zhou <zhouqiao@marvell.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mfd: Remove __devexit annotation for pm80x_deinit
Message-ID: <20120716132805.GF20652@sortiz-mobl>
References: <1341972070.25495.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341972070.25495.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Wed, Jul 11, 2012 at 10:01:10AM +0800, Axel Lin wrote:
> This fixes below section mismatch warning:
> 
>   LD      drivers/mfd/built-in.o
> WARNING: drivers/mfd/built-in.o(.devinit.text+0x46c): Section mismatch in reference from the function pm800_probe() to the function .devexit.text:pm80x_deinit()
> The function __devinit pm800_probe() references
> a function __devexit pm80x_deinit().
> This is often seen when error handling in the init function
> uses functionality in the exit path.
> The fix is often to remove the __devexit annotation of
> pm80x_deinit() so it may be used outside an exit section.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> v2: Also remove the __devexit annotation in 88pm80x.h
> 
>  drivers/mfd/88pm80x.c       |    2 +-
>  include/linux/mfd/88pm80x.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
