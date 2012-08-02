Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab2HBXV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 19:21:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59697 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab2HBXV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 19:21:57 -0400
Date: Thu, 02 Aug 2012 16:21:56 -0700 (PDT)
Message-Id: <20120802.162156.1853851468137303302.davem@davemloft.net>
To: fengguang.wu@intel.com
Cc: netdev@vger.kernel.org, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        joe@perches.com, isdn@linux-pingi.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdnloop: fix and simplify isdnloop_init()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120802110543.GA21745@localhost>
References: <20120802110543.GA21745@localhost>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fengguang Wu <fengguang.wu@intel.com>
Date: Thu, 2 Aug 2012 19:05:43 +0800

> Fix a buffer overflow bug by removing the revision transform code.
> 
> [   22.016214] isdnloop-ISDN-driver Rev 1.11.6.7 
> [   22.097508] isdnloop: (loop0) virtual card added
> [   22.174400] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ffffffff83244972
> [   22.174400] 
> [   22.436157] Pid: 1, comm: swapper Not tainted 3.5.0-bisect-00018-gfa8bbb1-dirty #129
> [   22.624071] Call Trace:
> [   22.720558]  [<ffffffff832448c3>] ? CallcNew+0x56/0x56
> [   22.815248]  [<ffffffff8222b623>] panic+0x110/0x329
> [   22.914330]  [<ffffffff83244972>] ? isdnloop_init+0xaf/0xb1
> [   23.014800]  [<ffffffff832448c3>] ? CallcNew+0x56/0x56
> [   23.090763]  [<ffffffff8108e24b>] __stack_chk_fail+0x2b/0x30
> [   23.185748]  [<ffffffff83244972>] isdnloop_init+0xaf/0xb1
> 
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

The reason the "$Revision ..." prefix is there is so that automated
version control tools will change the string automatically when code
is committed in CVS.

In the GIT era this revision style is obsolete.

Therefore you might as well just delete this crap altogether.
