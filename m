Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030558Ab2CNN7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 09:59:12 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49176 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964940Ab2CNN6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 09:58:55 -0400
Message-ID: <4F60A416.30903@gmail.com>
Date: Wed, 14 Mar 2012 21:58:46 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Weiping Pan <panweiping3@gmail.com>
CC: fubar@us.ibm.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net V2] bonding: send igmp report for its master
References: <f5d199e12d78dadcfb932e103984276d36b186e0.1331539261.git.panweiping3@gmail.com> <f5d199e12d78dadcfb932e103984276d36b186e0.1331539261.git.panweiping3@gmail.com>
In-Reply-To: <f5d199e12d78dadcfb932e103984276d36b186e0.1331539261.git.panweiping3@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2012 11:37 AM, Weiping Pan wrote:
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 435984a..300c490 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -794,6 +794,14 @@ static void bond_resend_igmp_join_requests_delayed(struct work_struct *work)
>   {
>   	struct bonding *bond = container_of(work, struct bonding,
>   					    mcast_work.work);
> +	struct net_device *bond_dev, *master_dev = NULL;
> +	bond_dev = bond->dev;

IIRC, you need to hold read_lock for this...

