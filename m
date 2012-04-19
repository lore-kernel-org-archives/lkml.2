Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab2DSNAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 09:00:50 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:32852 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449Ab2DSNAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 09:00:49 -0400
Message-ID: <4F900C7B.3060607@openvz.org>
Date: Thu, 19 Apr 2012 17:00:43 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Arnd Bergmann <arnd@arndb.de>, Pavel Emelianov <xemul@parallels.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH linux-next] ipc: fix local variable initialization in
 compat_do_msg_fill()
References: <20120419122124.15573.24504.stgit@zurg>
In-Reply-To: <20120419122124.15573.24504.stgit@zurg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Khlebnikov wrote:
> The "msgp" must points to the userspace buffer.
>
> fix for linux-next commit 774d0252d303969a7281eefd6eaccde50bb6eb6e
> ("c/r: ipc: message queue receive cleanup")

Oops, Dan Carpenter had caught this several days before me:
[patch] c/r: ipc: uninitialized variable in compat_do_msg_fill()

>
> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> Cc: Stanislav Kinsbursky<skinsbursky@parallels.com>
> Cc: Lucas De Marchi<lucas.de.marchi@gmail.com>
> Cc: Chris Metcalf<cmetcalf@tilera.com>
> Cc: Cyrill Gorcunov<gorcunov@openvz.org>
> Cc: Pavel Emelyanov<xemul@parallels.com>
> Cc: Arnd Bergmann<arnd@arndb.de>
> Cc: Andrew Morton<akpm@linux-foundation.org>
> ---
>   ipc/compat.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/ipc/compat.c b/ipc/compat.c
> index 6da376b..0c2ebd0 100644
> --- a/ipc/compat.c
> +++ b/ipc/compat.c
> @@ -363,7 +363,7 @@ static long compat_do_msg_steal(void __user *dest, struct msg_msg *msg, size_t b
>
>   long compat_do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
>   {
> -	struct compat_msgbuf __user *msgp;
> +	struct compat_msgbuf __user *msgp = dest;
>   	size_t msgsz;
>
>   	if (put_user(msg->m_type,&msgp->mtype))
>

