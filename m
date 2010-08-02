Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab0HBRBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:01:23 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48098 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab0HBRBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:01:22 -0400
Date: Mon, 2 Aug 2010 14:01:37 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] bluetooth rfcomm: fix section mismatch warning
Message-ID: <20100802170136.GA19526@vigoh>
References: <1280736976.1730.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280736976.1730.1.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

* Axel Lin <axel.lin@gmail.com> [2010-08-02 16:16:16 +0800]:

> Introduced by Commit 2f8362afcd2da8b313ec3cc04a50af19d3592972
> ( Bluetooth: Add __init and __exit marks to RFCOMM )
> 
> WARNING: vmlinux.o(.init.text+0x246d1): Section mismatch in reference from the function rfcomm_init() to the function .exit.text:rfcomm_cleanup_ttys()
> The function __init rfcomm_init() references
> a function __exit rfcomm_cleanup_ttys().
> This is often seen when error handling in the init function
> uses functionality in the exit path.
> The fix is often to remove the __exit annotation of
> rfcomm_cleanup_ttys() so it may be used outside an exit section.
> 
> This patch removes the __exit annotation from rfcomm_cleanup_ttys to eliminate the warning.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  net/bluetooth/rfcomm/tty.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

We have fixed that already. Thanks anyway. ;)

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
