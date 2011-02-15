Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab1BOXCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 18:02:25 -0500
Received: from mail.vyatta.com ([76.74.103.46]:51050 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab1BOXCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 18:02:21 -0500
Date: Tue, 15 Feb 2011 15:02:18 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tom Herbert <therbert@google.com>, Changli Gao <xiaosuo@gmail.com>,
        Jesse Gross <jesse@nicira.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] core: dev: don't call BUG() on bad input
Message-ID: <20110215150218.65f64b3b@nehalam>
In-Reply-To: <1297680967-11893-1-git-send-email-segoon@openwall.com>
References: <1297680967-11893-1-git-send-email-segoon@openwall.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011 13:56:06 +0300
Vasiliy Kulikov <segoon@openwall.com> wrote:

> alloc_netdev() may be called with too long name (more that IFNAMSIZ bytes).
> Currently this leads to BUG().  Other insane inputs (bad txqs, rxqs) and
> even OOM don't lead to BUG().  Made alloc_netdev() return NULL, like on
> other errors.

The only way alloc_netdev could be called with a name too long
was if some driver was incorrectly written. It is not something
that can be exercised by user space.

Please leave the BUG() so the driver will show up in
kernel oops logs etc.
