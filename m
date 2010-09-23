Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab0IWUlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:41:11 -0400
Received: from mail.perches.com ([173.55.12.10]:2303 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab0IWUlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:41:10 -0400
Subject: Re: [PATCH 1/1] Rename camel case variables in channel.c
From: Joe Perches <joe@perches.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "'gregkh@suse.de'" <gregkh@suse.de>,
        Hank Janssen <hjanssen@microsoft.com>
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7289EBB57C@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7289EBB57C@TK5EX14MBXC128.redmond.corp.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 13:41:08 -0700
Message-ID: <1285274468.25928.15.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-23 at 20:24 +0000, Haiyang Zhang wrote:
>  drivers/staging/hv/channel.c |  729 +++++++++++++++++++++---------------------
[]
> -	struct hv_monitor_page *monitorPage;
> +	struct hv_monitor_page *monitorpage;

Some of these renames would be better with a "_" for
the CamelCase conversions (ie: CamelCase -> camel_case).

perl regex: 's/\b([A-Z])([a-z]+)([A-Z])([a-z]+)\b/\L$1$2_\L$3$4/g'

For instance, I think this should be monitor_page;

> -void VmbusChannelGetDebugInfo(struct vmbus_channel *Channel,
> -			      struct vmbus_channel_debug_info *DebugInfo)
> +void VmbusChannelGetDebugInfo(struct vmbus_channel *channel,
> +			      struct vmbus_channel_debug_info *debuginfo)

perhaps debug_info

>  {
> -	struct hv_monitor_page *monitorPage;
> -	u8 monitorGroup = (u8)Channel->OfferMsg.MonitorId / 32;
> -	u8 monitorOffset = (u8)Channel->OfferMsg.MonitorId % 32;
> +	struct hv_monitor_page *monitorpage;
> +	u8 monitorGroup = (u8)channel->OfferMsg.MonitorId / 32;
> +	u8 monitorOffset = (u8)channel->OfferMsg.MonitorId % 32;

Why not convert these to monitor_(group|offset)?

etc...

