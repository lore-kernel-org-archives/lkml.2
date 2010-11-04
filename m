Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab0KDPUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:20:48 -0400
Received: from claw.goop.org ([74.207.240.146]:49900 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab0KDPUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:20:47 -0400
Message-ID: <4CD2CF4A.9080503@goop.org>
Date: Thu, 04 Nov 2010 11:20:42 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
        jirislaby@gmail.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 3/3] VIDEO: xen-fb, switch to for_each_console
References: <1288798114-23206-1-git-send-email-jslaby@suse.cz> <1288798114-23206-3-git-send-email-jslaby@suse.cz>
In-Reply-To: <1288798114-23206-3-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 11:28 AM, Jiri Slaby wrote:
> Use newly added for_each_console for iterating consoles.
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Jeremy Fitzhardinge <jeremy@xensource.com>

Sure, if that's what all the kids are doing these days.

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

    J

> Cc: Chris Wright <chrisw@sous-sol.org>
> Cc: virtualization@lists.osdl.org
> Cc: xen-devel@lists.xensource.com
> Cc: linux-fbdev@vger.kernel.org
> ---
>  drivers/video/xen-fbfront.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
> index 428d273..4abb0b9 100644
> --- a/drivers/video/xen-fbfront.c
> +++ b/drivers/video/xen-fbfront.c
> @@ -492,7 +492,7 @@ xenfb_make_preferred_console(void)
>  		return;
>  
>  	acquire_console_sem();
> -	for (c = console_drivers; c; c = c->next) {
> +	for_each_console(c) {
>  		if (!strcmp(c->name, "tty") && c->index == 0)
>  			break;
>  	}

