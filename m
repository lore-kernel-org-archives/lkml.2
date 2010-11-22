Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0KVS7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 13:59:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55599
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754383Ab0KVS7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 13:59:50 -0500
Date: Mon, 22 Nov 2010 11:00:15 -0800 (PST)
Message-Id: <20101122.110015.183067365.davem@davemloft.net>
To: alban.crequy@collabora.co.uk
Cc: eric.dumazet@gmail.com, shemminger@vyatta.com, gorcunov@openvz.org,
        adobriyan@gmail.com, lennart@poettering.net, kay.sievers@vrfy.org,
        ian.molton@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] AF_UNIX: create, join and leave multicast groups
 with setsockopt
From: David Miller <davem@davemloft.net>
In-Reply-To: <1290450982-17480-3-git-send-email-alban.crequy@collabora.co.uk>
References: <20101122183447.124afce5@chocolatine.cbg.collabora.co.uk>
	<1290450982-17480-3-git-send-email-alban.crequy@collabora.co.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alban Crequy <alban.crequy@collabora.co.uk>
Date: Mon, 22 Nov 2010 18:36:16 +0000

> +	other = unix_find_other(sock_net(sock->sk), &mreq->address, namelen,
> +				sock->type, hash, &err);
> +	if (other)
> +		return -EADDRINUSE;

Leaks 'other'.
