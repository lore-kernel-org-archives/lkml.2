Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab0IAQ26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 12:28:58 -0400
Received: from mail.perches.com ([173.55.12.10]:1190 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750Ab0IAQ25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 12:28:57 -0400
Subject: Re: [PATCH 5/5] staging: hv: Gracefully handle SCSI resets - RESEND
From: Joe Perches <joe@perches.com>
To: Hank Janssen <hjanssen@sailtheuniverse.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        virtualization@lists.osdl.org, devel@driverdev.osuosl.org,
        haiyangz@microsoft.com
In-Reply-To: <4C7D4848.6090409@sailtheuniverse.com>
References: <4C7D4848.6090409@sailtheuniverse.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 09:28:53 -0700
Message-ID: <1283358535.1797.174.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 11:22 -0700, Hank Janssen wrote:
> If we get a SCSI host bus reset we now gracefully handle it, and we 
> take the device offline. This before sometimes caused hangs.
> ---
>  drivers/staging/hv/storvsc.c |   36 +++++++++++++++++++++++++++++++++++-
[]
> +	/*
> +	 * Wait for traffic in transit to complete
> +	 */
> +	while (atomic_read(&storDevice->NumOutstandingRequests))
> +		udelay(1000);
> +

Is it useful to have a maximum check or timeout?
Maybe use usleep_range?


