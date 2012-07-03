Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2GCI43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 04:56:29 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61974 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2GCI40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 04:56:26 -0400
Date: Tue, 3 Jul 2012 17:04:41 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
Message-ID: <20120703090441.GA4804@gmail.com>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

Sorry for bothering you.  Could you please review this patch, or give me
some feedbacks.  If this patch can be applied, I can rebase it to the
lastest version of mainline kernel.  Thank you.

Regards,
Zheng

On Tue, May 08, 2012 at 11:24:03AM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Currently, SATA disk fua detection is disabled on default because most of
> devices don't support this feature at that time.  With the development of
> technology, more and more SATA disks support this feature.  So now we can enable
> this detection on default.
> 
> Although fua detection is defined as a kernel module parameter, it is too hard
> to set its value because it must be loaded and set before system starts up.
> That needs to modify initrd file.  So it is inconvenient for administrator who
> needs to manage a huge number of servers.
> 
> CC: Jeff Garzik <jeff@garzik.org>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  drivers/ata/libata-core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 23763a1..3627251 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -133,9 +133,9 @@ int atapi_passthru16 = 1;
>  module_param(atapi_passthru16, int, 0444);
>  MODULE_PARM_DESC(atapi_passthru16, "Enable ATA_16 passthru for ATAPI devices (0=off, 1=on [default])");
>  
> -int libata_fua = 0;
> +int libata_fua = 1;
>  module_param_named(fua, libata_fua, int, 0444);
> -MODULE_PARM_DESC(fua, "FUA support (0=off [default], 1=on)");
> +MODULE_PARM_DESC(fua, "FUA support (0=off, 1=on [default])");
>  
>  static int ata_ignore_hpa;
>  module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);
> -- 
> 1.7.4.1
> 
