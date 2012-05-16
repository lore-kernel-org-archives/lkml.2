Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051Ab2EPRSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:18:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49374 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751743Ab2EPRS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:18:28 -0400
Message-ID: <1337188707.6903.4.camel@joe2Laptop>
Subject: Re: SCSI RAM driver ported to 3.3 kernel for file system and I/O
 testing
From: Joe Perches <joe@perches.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>
Date: Wed, 16 May 2012 10:18:27 -0700
In-Reply-To: <1337188023.3796.130.camel@schen9-DESK>
References: <1337188023.3796.130.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 10:07 -0700, Tim Chen wrote:
> I've ported Matthew's scsi RAM driver (originally posted in
> http://marc.info/?l=linux-scsi&m=120331663227540&w=2) to the 3.3 kernel.

just trivia:

> diff --git a/drivers/scsi/scsi_ram.c b/drivers/scsi/scsi_ram.c
[]
> +static void scsi_ram_too_big(struct scsi_cmnd *cmnd, unsigned int start,
> +				unsigned int len)
> +{
> +	printk(KERN_WARNING, "Request exceeded device capacity! %u %u\n", start, len);

Probably ignored a warning here. No comma after KERN_WARNING.

I'd add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt before
any include and use pr_<level> instead.

[]

> +static int scsi_ram_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
> +{
> +	struct scsi_ram_cmnd *ram_cmnd = (void *)&cmnd->SCp;
> +	struct scsi_ram_device *ram_device = scsi_ram_devices[cmnd->device->id];
> +	unsigned long flags;
> +
> +	pr_debug("%s: Queueing command\n", DRV_NAME);

No need for DRV_NAME when using pr_fmt

[]

> +static int scsi_ram_slave_alloc(struct scsi_device *sdev)
> +{
> +	struct scsi_ram_device *ram_device;
> +
> +	pr_debug("%s: slave_alloc %d:%d\n", DRV_NAME, sdev->id, sdev->lun);

here too, etc...


