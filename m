Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336Ab1LGUEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 15:04:44 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65298 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926Ab1LGUEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 15:04:42 -0500
Message-ID: <4EDFC6D6.3050601@pobox.com>
Date: Wed, 07 Dec 2011 15:04:38 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: James Bottomley <JBottomley@parallels.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH v5 1/6] ata: make ata port as parent device of scsi host
References: <1323048028-10421-1-git-send-email-ming.m.lin@intel.com> <1323048028-10421-2-git-send-email-ming.m.lin@intel.com>
In-Reply-To: <1323048028-10421-2-git-send-email-ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2011 08:20 PM, Lin Ming wrote:
> Currently, the device tree of ata port and scsi host looks as below,
>
>          /sys/devices/pci0000:00/0000:00:1f.2    (ahci controller)
>          |-- ata1                                (ata port)
>          |-- host0                               (scsi host)
>             |-- target0:0:0                      (scsi target)
>                 |-- 0:0:0:0                      (disk)
>
> This patch makes ata port as parent device of scsi host, then it becomes
>
>          /sys/devices/pci0000:00/0000:00:1f.2    (ahci controller)
>          |-- ata1                                (ata port)
>              |-- host0                           (scsi host)
>                  |-- target0:0:0                 (scsi target)
>                      |-- 0:0:0:0                 (disk)
>
> With this change, the ata port runtime PM is easier.
> For example, the ata port runtime suspend will happen as,
>
> disk suspend -->  scsi target suspend -->  scsi host suspend -->  ata port
> suspend.
>
> Acked-by: Tejun Heo<tj@kernel.org>
> Signed-off-by: Lin Ming<ming.m.lin@intel.com>
> ---
>   drivers/ata/libata-scsi.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)

applied 1-6, thanks



