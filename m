Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab1EPSNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:13:06 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52724 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1EPSND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:13:03 -0400
Date: Mon, 16 May 2011 14:11:58 -0400 (EDT)
Message-Id: <20110516.141158.1777924960833804150.davem@davemloft.net>
To: kvalo@adurom.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] Fix uevent race in register_netdevice()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110516143913.13838.85357.stgit@localhost6.localdomain6>
References: <20110516143913.13838.85357.stgit@localhost6.localdomain6>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 16 May 2011 11:12:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 16 May 2011 17:46:30 +0300

> I'm trying to fix a race in register_netdevice(). The problem is that
> there's a uevent to userspace before the netdevice is ready for use. The
> problem is described here:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=15606
> 
> I have sent few different ways to fix this, but none of them have been
> really usable. Now I came up with a way which changes the driver core
> to make it possible send the uevent in a separate call. This is a clean
> and safe way to fix the race. Downside is that two new functions are
> added to the driver core interface.
> 
> Please comment.

This doesn't work.

The sysfs file will still be there before the uevent, so any
process can go in there, and see the inconsistent state.
