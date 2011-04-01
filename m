Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab1DASL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:11:26 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45079 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798Ab1DASLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:11:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NTv5cvF1eQ+sbGARCukmFP7Mvq+dwBzBYGHy4FzxPKUpEZC9FJLSQlWgw2EqlN+wd6
         K593COk6oQ9yiaLtptyynUc1oe78IxM22nT7vugcuAnt9zKECYCILjxSy1MMBVFhYbo4
         cSYzwrnIeEArxxFb2SckyflD/KTUUgv69aB7A=
MIME-Version: 1.0
In-Reply-To: <1301631861-12470-1-git-send-email-namei.unix@gmail.com>
References: <1301631861-12470-1-git-send-email-namei.unix@gmail.com>
Date: Fri, 1 Apr 2011 23:41:23 +0530
Message-ID: <AANLkTikH6M5f479PnWL-V-C3uF7Qcm79P1+eDizWasyV@mail.gmail.com>
Subject: Re: [Bridge] [PATCH] net/bridge: Fix wrong return-no-vaule
From: Sasikanth V <sasikanth.v19@gmail.com>
To: namei.unix@gmail.com
Cc: shemminger@linux-foundation.org, davem@davemloft.net,
        "open list:ETHERNET BRIDGE" <netdev@vger.kernel.org>,
        Liu Yuan <tailai.ly@taobao.com>,
        "open list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is already fixed and applied

On 4/1/11, namei.unix@gmail.com <namei.unix@gmail.com> wrote:
> From: Liu Yuan <tailai.ly@taobao.com>
>
> In br_stp_if.c/br_stp_recalculate_bridge_id, it should return
> false, which indicates that there is no change when we find
> that user has chosen a value.
>
> Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
> ---
>  net/bridge/br_stp_if.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
> index 5593f5a..9b61d09 100644
> --- a/net/bridge/br_stp_if.c
> +++ b/net/bridge/br_stp_if.c
> @@ -213,7 +213,7 @@ bool br_stp_recalculate_bridge_id(struct net_bridge *br)
>
>  	/* user has chosen a value so keep it */
>  	if (br->flags & BR_SET_MAC_ADDR)
> -		return;
> +		return false;
>
>  	list_for_each_entry(p, &br->port_list, list) {
>  		if (addr == br_mac_zero ||
> --
> 1.7.1
>
> _______________________________________________
> Bridge mailing list
> Bridge@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/bridge
>
