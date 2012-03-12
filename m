Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2CLKbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 06:31:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52743 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2CLKbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 06:31:15 -0400
Message-ID: <4F5DD01D.3010609@mvista.com>
Date: Mon, 12 Mar 2012 14:29:49 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, jslaby@suse.cz, cwillu@cwillu.com,
        jackdachef@gmail.com
Subject: Re: [PATCH] libata: disable runtime pm for hotpluggable port
References: <1331515012.3412.37.camel@minggr>
In-Reply-To: <1331515012.3412.37.camel@minggr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12-03-2012 5:16, Lin Ming wrote:

> Currently, hotplug doesn't work if port is already runtime suspended.
> For now, we simply disable runtime pm for hotpluggable port.
> Later, we should add runtime pm support for hotpluggable port too.

> https://lkml.org/lkml/2012/2/19/70

> TODO: add similar hotpluggable port check for controllers other than AHCI.

> Reported-and-tested-by: Jiri Slaby<jslaby@suse.cz>
> Reported-and-tested-by: cwillu@cwillu.com
> Reported-and-tested-by: jackdachef@gmail.com
> Signed-off-by: Lin Ming<ming.m.lin@intel.com>
[...]

> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 3085bdc..ccf0282 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -209,8 +209,10 @@ enum {
>   	ATA_FLAG_SW_ACTIVITY	= (1<<  22), /* driver supports sw activity
>   					      * led */
>   	ATA_FLAG_NO_DIPM	= (1<<  23), /* host not happy with DIPM */
> +	ATA_FLAG_EXTERNAL	= (1<<  24), /* controller supports external SATA */
> +	ATA_FLAG_PLUGGABLE	= (1<<  25), /* port is hotpluggable */
>
> -	/* bits 24:31 of ap->flags are reserved for LLD specific flags */
> +	/* bits 26:31 of ap->flags are reserved for LLD specific flags */

    There's no need to use bits 24..25, I've freed up some lower order bits 
last year, removing unused values.

WBR, Sergei
