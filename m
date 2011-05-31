Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab1EaWau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 18:30:50 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41912 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932743Ab1EaWat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 18:30:49 -0400
Date: Tue, 31 May 2011 15:30:30 -0700 (PDT)
Message-Id: <20110531.153030.224764258.davem@davemloft.net>
To: khoroshilov@ispras.ru
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/usb/catc.c: Fix potential deadlock in
 catc_ctrl_run()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306775184-5520-1-git-send-email-khoroshilov@ispras.ru>
References: <1306774878-5471-1-git-send-email-khoroshilov@ispras.ru>
	<1306775184-5520-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 31 May 2011 15:30:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Date: Mon, 30 May 2011 21:06:24 +0400

> catc_ctrl_run() calls usb_submit_urb() with GFP_KERNEL, while it is called from
> catc_ctrl_async() and catc_ctrl_done() with catc->ctrl_lock spinlock held.
> 
> The patch replaces GFP_KERNEL with GFP_ATOMIC.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Applied.
