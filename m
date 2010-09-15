Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0IOWmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 18:42:21 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:39228 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754939Ab0IOWmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 18:42:17 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18SVXkB3SISfb+cRxv7DQBkEZxvxypjGnu2vFOURi
	VCDJVv/QF2jKtV
Message-ID: <4C914BC4.8070809@gmx.de>
Date: Thu, 16 Sep 2010 00:42:12 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Dan Rosenberg <drosenberg@vsecurity.com>
CC: JosephChan@via.com.tw, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, security@kernel.org, stable@kernel.org
Subject: Re: [PATCH] drivers/video/via/ioctl.c: prevent reading uninitialized
 stack memory
References: <1284587059.6275.101.camel@dan>
In-Reply-To: <1284587059.6275.101.camel@dan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Dan Rosenberg schrieb:
> The VIAFB_GET_INFO device ioctl allows unprivileged users to read 1968
> bytes of uninitialized stack memory, because the "reserved" member of
> the viafb_ioctl_info struct declared on the stack is not altered or
> zeroed before being copied back to the user.  This patch takes care of
> it.

I am wondering about the number of bytes as sizeof(struct viafb_ioctl_info) = 
256 so it should be a bit less. But that's just nitpicking, the issue is 
certainly real. Your patch does the right thing but there is a bug in it:

> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
> 
> --- linux-2.6.35.4.orig/drivers/video/via/ioctl.c	2010-08-26 19:47:12.000000000 -0400
> +++ linux-2.6.35.4/drivers/video/via/ioctl.c	2010-09-15 11:53:29.997375748 -0400
> @@ -25,6 +25,8 @@ int viafb_ioctl_get_viafb_info(u_long ar
>  {
>  	struct viafb_ioctl_info viainfo;
>  
> +	memset(&viainfo, 0, sizeof(struct viafb_ioctl));

Shouldn't it be sizeof(struct viafb_ioctl_info) or sizeof(viainfo) ?
At least here it does not even compile otherwise....


Thanks,

Florian Tobias Schandinat
