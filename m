Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab2J2L6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:58:14 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48915 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758795Ab2J2L6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:58:12 -0400
MIME-Version: 1.0
In-Reply-To: <1351440721-9121-1-git-send-email-peter.senna@gmail.com>
References: <1351440721-9121-1-git-send-email-peter.senna@gmail.com>
Date: Mon, 29 Oct 2012 09:58:11 -0200
Message-ID: <CAAAP30Gm56x+k92iCxG20a8ONsWgKqyYfsZXBQMuU9j9zx6b1Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers/net/ethernet/nxp/lpc_eth.c: Call
 mdiobus_unregister before mdiobus_free
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: davem@davemloft.net, stigge@antcom.de, edumazet@google.com,
        djduanjiong@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 2:12 PM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
> Based on commit b27393aecf66199f5ddad37c302d3e0cfadbe6c0
>
> Calling mdiobus_free without calling mdiobus_unregister causes
> BUG_ON(). This patch fixes the issue.
>
> The semantic patch that found this issue(http://coccinelle.lip6.fr/):
> // <smpl>
> @@
> expression E;
> @@
>   ... when != mdiobus_unregister(E);
>
> + mdiobus_unregister(E);
>   mdiobus_free(E);
> // </smpl>
>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---

Tested-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
