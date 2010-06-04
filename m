Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab0FDW2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 18:28:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754767Ab0FDW2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 18:28:08 -0400
Date: Fri, 4 Jun 2010 15:27:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: John Villalovos <jvillalo@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] Documentation: Add doc about aerdriver.* parameters to
 kernel-parameters.txt
Message-Id: <20100604152722.2da5de06.akpm@linux-foundation.org>
In-Reply-To: <20100602152721.GA8939@linuxjohn.usersys.redhat.com>
References: <20100602152721.GA8939@linuxjohn.usersys.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 11:27:22 -0400
John Villalovos <jvillalo@redhat.com> wrote:

> Adding documentation about two aerdriver.* command line parameters.
> 
> Signed-off-by: John L. Villalovos <john.l.villalovos@intel.com>
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 1808f11..57ff168 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -293,6 +293,19 @@ and is between 256 and 4096 characters. It is defined in the file
>  			Format: <io>,<irq>,<dma>,<mss_io>,<mpu_io>,<mpu_irq>
>  			See also header of sound/oss/aedsp16.c.
>  
> +	aerdriver.forceload= [HW,PCIE] Advanced Error Recovery (AER) Root Driver
> +			{ y, n }
> +			y: Force the AER Root driver to load
> +			n: Do not force the AER Root driver to load [DEFAULT]
> +			See also Documentation/PCI/pcieaer-howto.txt
> +
> +	aerdriver.nosourceid= [HW,PCIE]
> +			{ y, n }
> +			y: Use when broken hardware (mostly chipsets) has root
> +			   ports that cannot obtain the reporting source ID.
> +			n: [DEFAULT]
> +			See also Documentation/PCI/pcieaer-howto.txt
> +
>  	agp=		[AGP]
>  			{ off | try_unsupported }
>  			off: disable AGP support

We don't normally document the parameters for random drivers within
kernel-parameters.txt - that file is more for core-kernel things.

The way to document these guys is with MODULE_PARM_DESC() in
drivers/pci/pcie/aer/aerdrv_core.c.  Coz some dope forgot to do that.

I'm sure there's some way of extracting all these random
MODULE_PARM_DESC()s from vmlinux/modules/etc for human consumption, but
I'm not sure what that way is.

