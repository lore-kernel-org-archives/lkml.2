Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671Ab2DKWqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:46:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48086 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab2DKWqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:46:37 -0400
Subject: Re: [PATCH] staging: vt6656: Don't leak memory in drivers/staging/vt6656/ioctl.c::private_ioctl()
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <alpine.LNX.2.00.1204120032050.2137@swampdragon.chaosbits.net>
Date: Wed, 11 Apr 2012 18:46:33 -0400
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Forest Bond <forest@alittletooquiet.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <D26D474A-E696-447C-8B54-15295135368E@gmail.com>
References: <alpine.LNX.2.00.1204120032050.2137@swampdragon.chaosbits.net>
To: Jesper Juhl <jj@chaosbits.net>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 11, 2012, at 6:35 PM, Jesper Juhl wrote:

> -		pNodeList = (PSNodeList)kmalloc(sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)), (int)GFP_ATOMIC);
> +		pNodeList = kmalloc(sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)), (int)GFP_ATOMIC);

Can you also remove casts like "(int)GFP_ATOMIC"?

The parentheses "(sNodeList.uItem * sizeof(SNodeItem))" are also
pointless..

- xi