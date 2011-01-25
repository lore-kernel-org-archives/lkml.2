Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab1AYIj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 03:39:28 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44137 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab1AYIj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 03:39:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bnQ1FNzY3w39fDptDPl+QwnfVcN6VA3B6a4xVlz9jSEcw84KkiYvIxIIq/ahCYkhWz
         rbi+Dw3WV/23ZaVCOQXhKC7NSzWlqbkuVd+3o0QEbVm8lplT2kQH8f/jcQQYanH0d5LN
         2XI9IK1yef5sYgo58uUJjuVmKLfWTfbT27K9M=
Date: Tue, 25 Jan 2011 16:39:15 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, nab@linux-iscsi.org,
        "David S. Miller" <davem@davemloft.net>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH] net: NETCONSOLE_DYNAMIC need CONFIGFS_FS=y
Message-ID: <20110125083915.GE13618@cr0.nay.redhat.com>
References: <1295943748-9699-1-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295943748-9699-1-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 04:22:28PM +0800, Yong Zhang wrote:
>With CONFIGFS_FS=m && NETCONSOLE_DYNAMIC=y, build error:
>
>drivers/built-in.o: In function `netconsole_target_put':
>build/drivers/net/netconsole.c:133: undefined reference to `config_item_put'
>drivers/built-in.o: In function `netconsole_target_get':
>build/drivers/net/netconsole.c:127: undefined reference to `config_item_get'
>build/drivers/net/netconsole.c:127: undefined reference to `config_item_get'
>drivers/built-in.o: In function `netconsole_target_put':
>build/drivers/net/netconsole.c:133: undefined reference to `config_item_put'
>drivers/built-in.o: In function `drop_netconsole_target':
>build/drivers/net/netconsole.c:634: undefined reference to `config_item_put'
>drivers/built-in.o: In function `make_netconsole_target':
>build/drivers/net/netconsole.c:607: undefined reference to `config_item_init_type_name'
>drivers/built-in.o: In function `dynamic_netconsole_init':
>build/drivers/net/netconsole.c:109: undefined reference to `config_group_init'
>build/drivers/net/netconsole.c:111: undefined reference to `configfs_register_subsystem'
>drivers/built-in.o: In function `dynamic_netconsole_exit':
>build/drivers/net/netconsole.c:116: undefined reference to `configfs_unregister_subsystem'
>

Yeah, this was reported, another way to fix this is "select CONFIGFS_FS".
Using "select" makes you configure NETCONSOLE_DYNAMIC without caring
about if you have configured CONFIGFS_FS=y, which seems better.

Thanks.
