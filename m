Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab2F2PLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:11:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55468 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab2F2PLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:11:11 -0400
Subject: Re: [RFC] [TCP 1/3] tcp: Add MSG_NEW_PACKET flag to indicate
 preferable packet boundaries
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andreas Gruenbacher <agruen@linbit.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1340981690.25226.3.camel@gurkel.linbit>
References: <1340981690.25226.3.camel@gurkel.linbit>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jun 2012 17:11:06 +0200
Message-ID: <1340982666.21162.3.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 16:54 +0200, Andreas Gruenbacher wrote:
> The MSG_NEW_PACKET flag indicates to sendmsg / sendpage that the message or
> page should be put into a new packet even when there is still room left in the
> previous packet.
> 
> In the tcp protocol, messages which are not sent immediately are queued.  When
> more data is sent, it will be added to the last segment in that queue until
> that segment is "full" whenever possible; only then is a new segment added.
> Right now, there is no way to indicate when tcp should start a new segment.
> The new flag allows to control that.
> 
> Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
> ---

I don't understand how maintaining any message boundaries at sender can
prevent any middlebox or the receiver to coalesce frames to any
boundaries it prefers ?



