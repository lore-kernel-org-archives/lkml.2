Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130Ab2E2M0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 08:26:51 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52517 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750887Ab2E2M0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 08:26:49 -0400
Message-ID: <4FC4C069.1000906@mvista.com>
Date: Tue, 29 May 2012 16:26:17 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Jeff Garzik <jgarzik@pobox.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v4 01/13] [SCSI]: add wrapper to access and set scsi_bus_type
 in struct acpi_bus_type
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com> <1338181720-4149-2-git-send-email-ming.m.lin@intel.com>
In-Reply-To: <1338181720-4149-2-git-send-email-ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 28-05-2012 9:08, Lin Ming wrote:

> From: Holger Macht<holger@homac.de>

> For being able to bind ata devices against acpi devices, scsi_bus_type
> needs to be set as bus in struct acpi_bus_type. So add wrapper to
> scsi_lib to accomplish that.

> Signed-off-by: Holger Macht<holger@homac.de>
> Signed-off-by: Lin Ming<ming.m.lin@intel.com>
> ---
>   drivers/scsi/scsi_lib.c |   17 +++++++++++++++++
>   include/scsi/scsi.h     |   10 ++++++++++
>   2 files changed, 27 insertions(+), 0 deletions(-)

> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index f34a5a8..4527b3a 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -214,6 +214,16 @@ scsi_command_size(const unsigned char *cmnd)
>   		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
>   }
>
> +#ifdef CONFIG_ACPI

    You don't have to enclode declarations into #ifdef.

> +struct acpi_bus_type;
> +
> +extern int

    'extern' is the default memory class for function, no need to specidy it.
And don't break the line here.

> +scsi_register_acpi_bus_type(struct acpi_bus_type *bus);
> +
> +extern void

    Same comment.

> +scsi_unregister_acpi_bus_type(struct acpi_bus_type *bus);
> +#endif

MBR, Sergei
