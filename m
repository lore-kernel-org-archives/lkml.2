Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab0JKSMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 14:12:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47192
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755828Ab0JKSMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 14:12:51 -0400
Date: Mon, 11 Oct 2010 11:13:13 -0700 (PDT)
Message-Id: <20101011.111313.59678995.davem@davemloft.net>
To: jslaby@suse.cz
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        chas@cmf.nrl.navy.mil
Subject: Re: [PATCH 2/3] ATM: iphase, remove sleep-inside-atomic
From: David Miller <davem@davemloft.net>
In-Reply-To: <1286789218-13976-2-git-send-email-jslaby@suse.cz>
References: <1286789218-13976-1-git-send-email-jslaby@suse.cz>
	<1286789218-13976-2-git-send-email-jslaby@suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Mon, 11 Oct 2010 11:26:57 +0200

> Stanse found that ia_init_one locks a spinlock and inside of that it
> calls ia_start which calls:
> * request_irq
> * tx_init which does kmalloc(GFP_KERNEL)
> 
> Both of them can thus sleep and result in a deadlock. I don't see a
> reason to have a per-device spinlock there which is used only there
> and inited right before the lock location. So remove it completely.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Applied.
