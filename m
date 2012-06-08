Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2FHLUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 07:20:40 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48512 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860Ab2FHLUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 07:20:38 -0400
Message-ID: <4FD1DFDB.3020300@mvista.com>
Date: Fri, 08 Jun 2012 15:19:55 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        stable@vger.kernel.org
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove(v1)
References: <1339133929-30679-1-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1339133929-30679-1-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08-06-2012 9:38, Ming Lei wrote:

> Firstly, .shutdown callback may touch a uninitialized hardware
> if dev->driver is set and .probe is not completed.

> Secondly, device_shutdown() may dereference a null pointer to cause
> oops when dev->driver is cleared after it is checked in
> device_shutdown().

> So just hold device lock and its parent lock if it has to fix the
> races.

> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: stable@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>   drivers/base/core.c |    8 ++++++++
>   1 file changed, 8 insertions(+)

> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 346be8b..cbc8bd2 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1820,6 +1820,11 @@ void device_shutdown(void)
>   		list_del_init(&dev->kobj.entry);
>   		spin_unlock(&devices_kset->list_lock);
>
> +		/*hold lock[s] to avoid races with .probe/.release*/

    Please add spaces after /* and before */. Or the applier please do it...

WBR, Sergei
