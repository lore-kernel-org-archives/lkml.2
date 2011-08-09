Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1HIQh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:37:56 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35428 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab1HIQhy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:37:54 -0400
MIME-Version: 1.0
In-Reply-To: <1312906118.11924.8.camel@Joe-Laptop>
References: <1312904711-1855-1-git-send-email-wangshaoyan.pt@taobao.com>
	<1312906118.11924.8.camel@Joe-Laptop>
Date: Wed, 10 Aug 2011 00:37:54 +0800
Message-ID: <CANxBZFqdhbSttgf5C6UjmTvkS8BfHHbo2qSiftQtQCT0w=B07g@mail.gmail.com>
Subject: Re: [PATCH] gianfar: reduce stack usage in gianfar_ethtool.c
From: Wang Shaoyan <stufever@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought kfree should not call, when kmalloc is failed. Now I think
is fine, thanks, it is much clearer

> Perhaps it'd be clearer to use:
>
>        local_rqfpr = kmalloc(...)
>        local_rqfcr = kmalloc(...)
>        if (!local_rqfpr || !local_rqfcr) {
>                pr_err(...)
>                ret = -ENOMEM;
>                goto err;
>        }
>
> [...]
>
> err:
>        kfree(local_rqfpr);
>        kfree(local_rqfcr);
>        return ret;
>
> Is the "local_" prefix useful?
> It seems like visual noise to me.

They are some temporary variable, we better to left them

>
>



-- 
Wang Shaoyan
