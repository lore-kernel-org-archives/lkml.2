Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992621Ab2KOCu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 21:50:57 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38634 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992461Ab2KOCu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 21:50:56 -0500
Date: Wed, 14 Nov 2012 21:50:55 -0500 (EST)
Message-Id: <20121114.215055.1156530698069105896.davem@davemloft.net>
To: xtfeng@gmail.com
Cc: dannyfeng@tencent.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: fix tasklet misuse issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1352872056-5637-1-git-send-email-xtfeng@gmail.com>
References: <1352872056-5637-1-git-send-email-xtfeng@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaotian Feng <xtfeng@gmail.com>
Date: Wed, 14 Nov 2012 13:47:36 +0800

> In commit 175c0dff, drivers uses tasklet_kill to avoid put disabled tasklet
> on the tasklet vec. But some of the drivers uses tasklet_init & tasklet_disable
> in the driver init code, then tasklet_enable when it is opened. This makes
> tasklet_enable on a killed tasklet and make ksoftirqd crazy then. Normally,
> drivers should use tasklet_init/tasklet_kill on device open/remove, and use
> tasklet_disable/tasklet_enable on device suspend/resume.
> 
> Reported-by: Peter Wu <lekensteyn@gmail.com>
> Tested-by: Peter Wu <lekensteyn@gmail.com>
> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>

Applied, thanks.
