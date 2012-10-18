Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab2JRJqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:46:53 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26719 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2JRJqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:46:51 -0400
Date: Thu, 18 Oct 2012 12:46:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/3] Drivers: hv: Cleanup error handling in vmbus_open()
Message-ID: <20121018094625.GB5685@mwanda>
References: <1350073335-10575-1-git-send-email-kys@microsoft.com>
 <1350073363-10614-1-git-send-email-kys@microsoft.com>
 <1350073363-10614-2-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350073363-10614-2-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 01:22:42PM -0700, K. Y. Srinivasan wrote:
> -errorout:
> -	hv_ringbuffer_cleanup(&newchannel->outbound);
> -	hv_ringbuffer_cleanup(&newchannel->inbound);
> +error1:
> +	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
> +	list_del(&open_info->msglistentry);
> +	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
> +
> +error0:

It's better to give the labels meaningful names like error_del and
error_pages instead of GW-BASIC numbers.

regards,
dan carpenter

