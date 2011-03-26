Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab1CZUpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 16:45:17 -0400
Received: from cobra.newdream.net ([66.33.216.30]:45482 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab1CZUpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 16:45:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=IinDsH6J/godnoukeSYWNDVva
	pXlyWLSVxAxqSG48atmamPH2uZJqk/2Im0bPEx4eR73w4t2xQtY3n2FeSNN6bIiH
	botvHsOWI3qXN98S2Nsy8cPdF05lx92snf1VgMYUdKJvE+SEgim7V9TG0R+T0HHd
	XeYAEkZ3jaIWQAeiS0=
Date: Sat, 26 Mar 2011 13:48:05 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Mariusz Kozlowski <mk@lab.zgora.pl>
cc: "David S. Miller" <davem@davemloft.net>, ceph-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ceph: fix possible NULL pointer dereference
In-Reply-To: <1301164174-8597-1-git-send-email-mk@lab.zgora.pl>
Message-ID: <Pine.LNX.4.64.1103261347580.17758@cobra.newdream.net>
References: <1301164174-8597-1-git-send-email-mk@lab.zgora.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied, thanks!

sage


On Sat, 26 Mar 2011, Mariusz Kozlowski wrote:

> This patch fixes 'event_work' dereference before it is checked for NULL.
> 
> Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
> ---
>  net/ceph/osd_client.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 02212ed..b6776cb 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -1602,11 +1602,11 @@ void handle_watch_notify(struct ceph_osd_client *osdc, struct ceph_msg *msg)
>  	     cookie, ver, event);
>  	if (event) {
>  		event_work = kmalloc(sizeof(*event_work), GFP_NOIO);
> -		INIT_WORK(&event_work->work, do_event_work);
>  		if (!event_work) {
>  			dout("ERROR: could not allocate event_work\n");
>  			goto done_err;
>  		}
> +		INIT_WORK(&event_work->work, do_event_work);
>  		event_work->event = event;
>  		event_work->ver = ver;
>  		event_work->notify_id = notify_id;
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
