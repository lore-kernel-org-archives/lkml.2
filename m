Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab1K1KOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 05:14:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50299 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1K1KOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 05:14:18 -0500
Message-ID: <4ED35EBF.6030602@mvista.com>
Date: Mon, 28 Nov 2011 14:13:19 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <JBottomley@parallels.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH v4 6/6] ata: add ata port runtime PM callbacks
References: <1322442950-16268-1-git-send-email-ming.m.lin@intel.com> <1322442950-16268-7-git-send-email-ming.m.lin@intel.com>
In-Reply-To: <1322442950-16268-7-git-send-email-ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 28-11-2011 5:15, Lin Ming wrote:

> Add ata port runtime suspend/resume/idle callbacks.
> Set ->eh_noresume to skip the runtime PM calls on scsi host
> in the error handler to avoid dead lock.

> Signed-off-by: Lin Ming<ming.m.lin@intel.com>
> ---
>   drivers/ata/libata-core.c      |   10 ++++++++++
>   drivers/ata/libata-scsi.c      |    1 +
>   drivers/ata/libata-transport.c |    4 ++++
>   3 files changed, 15 insertions(+), 0 deletions(-)

> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 04c208e..15a3d4d 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
[...]
> @@ -5307,9 +5308,18 @@ static int ata_port_resume(struct device *dev)
>   	return rc;
>   }
>
> +static int ata_port_runtime_idle(struct device *dev)
> +{
> +	return pm_runtime_suspend(dev);
> +}
> +
>   static const struct dev_pm_ops ata_port_pm_ops = {
>   	.suspend = ata_port_suspend,
>   	.resume = ata_port_resume,
> +
> +	.runtime_suspend = ata_port_suspend_common,
> +	.runtime_resume = ata_port_resume,
> +	.runtime_idle = ata_port_runtime_idle,

    Can't use set this to pm_runtime_suspend directly?

MBR, Sergei
