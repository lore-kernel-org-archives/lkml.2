Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab2DSPP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 11:15:59 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46783 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211Ab2DSPP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 11:15:58 -0400
X-Sasl-enc: qSY7PlkJu2s/K49IF7H1d1Vw1qcWPtggGyuZ1a2qVexR 1334848557
Date: Thu, 19 Apr 2012 08:15:56 -0700
From: Greg KH <greg@kroah.com>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        artem.bityutskiy@linux.intel.com, shubhrajyoti@ti.com
Subject: Re: [PATCH 5/6] HSI: hsi_char: Remove max_data_size from sysfs
Message-ID: <20120419151556.GA31543@kroah.com>
References: <1334837127-12931-1-git-send-email-carlos.chinea@nokia.com>
 <1334837127-12931-6-git-send-email-carlos.chinea@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334837127-12931-6-git-send-email-carlos.chinea@nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 03:05:26PM +0300, Carlos Chinea wrote:
> Remove max_data_size sysfs entry. Otherwise is possible
> to have a buffer overrun if its value is increased after
> the device is open.
> 
> Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
> ---
>  drivers/hsi/clients/hsi_char.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hsi/clients/hsi_char.c b/drivers/hsi/clients/hsi_char.c
> index 88a050d..3ad91f6 100644
> --- a/drivers/hsi/clients/hsi_char.c
> +++ b/drivers/hsi/clients/hsi_char.c
> @@ -123,7 +123,7 @@ struct hsc_client_data {
>  static unsigned int hsc_major;
>  /* Maximum buffer size that hsi_char will accept from userspace */
>  static unsigned int max_data_size = 0x1000;
> -module_param(max_data_size, uint, S_IRUSR | S_IWUSR);
> +module_param(max_data_size, uint, 0);

You can just change this to be read-only, that way userspace can see
what the value is, and it can't be changed.

But that's up to you, not an issue at all.

greg k-h
