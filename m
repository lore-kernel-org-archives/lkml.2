Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab0JNOjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 10:39:20 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:45757 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab0JNOjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 10:39:19 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Oct 2010 10:39:19 EDT
Date: Thu, 14 Oct 2010 10:32:28 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
        Peter Jones <pjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH -next] ibft: fix kconfig dependencies
Message-ID: <20101014143228.GA20645@andromeda.dapyr.net>
References: <20101013180716.6cf5a80f.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013180716.6cf5a80f.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 06:07:16PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kconfig dependency warning to satisfy dependencies:

Thanks for spotting it. Let me queue it up for the next merge window.
> 
> warning: (BE2ISCSI && SCSI_LOWLEVEL && PCI && SCSI && NET || ISCSI_IBFT && ISCSI_IBFT_FIND && SCSI) selects ISCSI_BOOT_SYSFS which has unmet direct dependencies (SCSI_LOWLEVEL && SCSI)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc:	Peter Jones <pjones@redhat.com>
> Cc:	Konrad Rzeszutek Wilk <konrad@kernel.org>
> ---
>  drivers/firmware/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20101013.orig/drivers/firmware/Kconfig
> +++ linux-next-20101013/drivers/firmware/Kconfig
> @@ -125,7 +125,7 @@ config ISCSI_IBFT_FIND
>  config ISCSI_IBFT
>  	tristate "iSCSI Boot Firmware Table Attributes module"
>  	select ISCSI_BOOT_SYSFS
> -	depends on ISCSI_IBFT_FIND && SCSI
> +	depends on ISCSI_IBFT_FIND && SCSI && SCSI_LOWLEVEL
>  	default	n
>  	help
>  	  This option enables support for detection and exposing of iSCSI
