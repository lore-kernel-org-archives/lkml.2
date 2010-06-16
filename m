Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab0FPVJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 17:09:10 -0400
Received: from smtp5.freeserve.com ([193.252.22.151]:60375 "EHLO
	smtp6.freeserve.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753391Ab0FPVJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 17:09:09 -0400
X-ME-UUID: 20100616210848280.448F41C037A7@mwinf3526.me.freeserve.com
Date: Wed, 16 Jun 2010 22:08:24 +0100
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Jeff Layton <jlayton@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nfsd hang and kernel bug in 2.6.35-rc3
Message-ID: <20100616220824.4e886552@boulder.homenet>
In-Reply-To: <20100616123532.569efeb9@tlielax.poochiereds.net>
References: <20100615175034.1e015fbc@boulder.homenet>
	<20100616153603.GH10223@fieldses.org>
	<20100616123532.569efeb9@tlielax.poochiereds.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010 12:35:32 -0400
Jeff Layton <jlayton@redhat.com> wrote:
[snip]
> No, I don't think we ever saw any oopses from this, but I think I can
> see what happened here:
> 
> rpc.nfsd was unable to hand any socket fd's off to the kernel due to
> being unable to start lockd. Regardless though, it tried to start
> threads anyway, and called into nfsd_init_socks. It then started a udp
> socket, and tried to call lockd_up again. That failed, and it
> returned error. Now sv_permsocks is non-empty but the socket there
> doesn't hold a lockd reference.
> 
> The right fix is probably to tear down the socket when lockd_up fails
> in nfsd_init_socks.
> 
> I suspect that Chris may be using an older version of rpc.nfsd though
> that might behave a little differently than the one I was using, and
> that might account for why he hit this and we didn't.
> 
> Chris, what version of nfs-utils do you have installed on this box?
[snip]

It's the stock nfs-utils-1.2.2 which comes with slackware 13.1, which
seems to be the latest (stable) release.

Chris


