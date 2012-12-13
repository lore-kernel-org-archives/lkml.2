Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2LMJh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 04:37:56 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41496 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2LMJhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 04:37:55 -0500
Date: Thu, 13 Dec 2012 12:37:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH 1/1] Drivers: hv: balloon: Fix a memory leak
Message-ID: <20121213093740.GW6568@mwanda>
References: <1355252837-9827-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355252837-9827-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 11:07:17AM -0800, K. Y. Srinivasan wrote:
> -probe_error1:
> +probe_error2:
>  	kthread_stop(dm_device.thread);
>  
> -probe_error0:
> +probe_error1:
>  	vmbus_close(dev->channel);
> +probe_error0:
> +	kfree(send_buffer);

If you used labels that describe what the code does instead of
GW-BASIC labels then you wouldn't need to rename them.

err_stop_thread:
	kthread_stop(dm_device.thread);
err_close_vmbus:
	vmbus_close(dev->channel);
err_free_send_buf:
	kfree(send_buffer);

regards,
dan carpenter

