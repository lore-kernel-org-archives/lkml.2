Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab2HBKkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 06:40:24 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:45807 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab2HBKkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:40:22 -0400
Date: Thu, 2 Aug 2012 03:40:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] isdnloop: fix and simplify isdnloop_init()
Message-ID: <20120802104018.GA2058@kroah.com>
References: <20120802040158.GA11860@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120802040158.GA11860@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 12:01:58PM +0800, Fengguang Wu wrote:
> Remove the non-sense isdnloop revision transform code, so as to fix:
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
> ---
>  drivers/isdn/isdnloop/isdnloop.c |   13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)

Please use scripts/get_maintainer.pl to send this to the correct people
(hint, you got one address right, lkml, but that was it.)

greg k-h
