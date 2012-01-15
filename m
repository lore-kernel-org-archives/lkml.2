Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2AOKwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 05:52:17 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54849 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230Ab2AOKwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 05:52:15 -0500
Date: Sun, 15 Jan 2012 12:52:03 +0200
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blutetooth: Remove bogus inline for l2cap_chan_connect()
Message-ID: <20120115105203.GA12584@x220.P-661HNU-F1>
Mail-Followup-To: Geert Uytterhoeven <geert@linux-m68k.org>,
	"Gustavo F. Padovan" <padovan@profusion.mobi>,
	Marcel Holtmann <marcel@holtmann.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1326622076-957-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1326622076-957-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Sun, Jan 15, 2012, Geert Uytterhoeven wrote:
> commit 03a001948166d966d0d580cddb8ae3a23f8b795b ("Bluetooth: invert locking
> order in connect path") marked l2cap_chan_connect() inline for both the
> prototype in include/net/bluetooth/l2cap.h and the implementation in
> net/bluetooth/l2cap_core.c.
> 
> As the former doesn't contain an implementation, net/bluetooth/l2cap_sock.c
> now fails to build, e.g. for m68k allmodconfig:
> 
>     net/bluetooth/l2cap_sock.c: In function ‘l2cap_sock_connect’:
>     include/net/bluetooth/l2cap.h:838: sorry, unimplemented: inlining failed in call to ‘l2cap_chan_connect’: function body not available
>     net/bluetooth/l2cap_sock.c:126: sorry, unimplemented: called from here
>     make[1]: *** [net/bluetooth/l2cap_sock.o] Error 1
> 
> As l2cap_chan_connect() is not that small and also called from
> net/bluetooth/l2cap_sock.c, I removed both inline keywords.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> --
> As I can't seem to find anyone else getting this, I guess it's only
> triggered by some versions of gcc. Mine is
> 
> gcc version 4.1.2 20061115 (prerelease) (Ubuntu 4.1.1-21)
> ---
>  include/net/bluetooth/l2cap.h |    2 +-
>  net/bluetooth/l2cap_core.c    |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

This was already reported[1] earlier this month and a patch[2] was also
created for it which right now resides in my bluetooth-next tree[3].

Johan

[1] http://www.spinics.net/lists/linux-bluetooth/msg19851.html
[2] http://www.spinics.net/lists/linux-bluetooth/msg20009.html
[3] http://git.kernel.org/?p=linux/kernel/git/jh/bluetooth-next.git;a=commitdiff;h=cd555072d0b0738c8a107776fe91902da686f94d
