Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab2JZGVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:21:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43852 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab2JZGVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:21:00 -0400
Date: Fri, 26 Oct 2012 02:20:58 -0400 (EDT)
Message-Id: <20121026.022058.1269607845663983487.davem@davemloft.net>
To: tilman@imap.cc
Cc: isdn@linux-pingi.de, oneukum@suse.de, hjlipp@web.de,
        gigaset307x-common@lists.sourceforge.net, linux-usb@vger.kernel.org,
        i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bas_gigaset: fix pre_reset handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121024-patch-gigaset-01.tilman@imap.cc>
References: <20121024-patch-gigaset-01.tilman@imap.cc>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Wed, 24 Oct 2012 20:44:32 +0200

> The delayed work function int_in_work() may call usb_reset_device()
> and thus, indirectly, the driver's pre_reset method. Trying to
> cancel the work synchronously in that situation would deadlock.
> Fix by avoiding cancel_work_sync() in the pre_reset method.
> 
> If the reset was NOT initiated by int_in_work() this might cause
> int_in_work() to run after the post_reset method, with urb_int_in
> already resubmitted, so handle that case gracefully.
> 
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>

Applied, thanks.
