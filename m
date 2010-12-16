Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab0LPU22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:28:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55807
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756100Ab0LPU21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:28:27 -0500
Date: Thu, 16 Dec 2010 12:28:55 -0800 (PST)
Message-Id: <20101216.122855.48497491.davem@davemloft.net>
To: avagin@openvz.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: delete expired route in ip6_pmtu_deliver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1292116811-22216-1-git-send-email-avagin@openvz.org>
References: <1292116811-22216-1-git-send-email-avagin@openvz.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Vagin <avagin@openvz.org>
Date: Sun, 12 Dec 2010 04:20:11 +0300

> The first big packets sent to a "low-MTU" client correctly
> triggers the creation of a temporary route containing the reduced MTU.
> 
> But after the temporary route has expired, new ICMP6 "packet too big"
> will be sent, rt6_pmtu_discovery will find the previous EXPIRED route
> check that its mtu isn't bigger then in icmp packet and do nothing
> before the temporary route will not deleted by gc.
> 
> I make the simple experiment:
> while :; do
>     time ( dd if=/dev/zero bs=10K count=1 | ssh hostname dd of=/dev/null ) || break;
> done
> 
> The "time" reports real 0m0.197s if a temporary route isn't expired, but
> it reports real 0m52.837s (!!!!) immediately after a temporare route has
> expired.
> 
> Signed-off-by: Andrey Vagin <avagin@openvz.org>

Applied and queued up for -stable, thanks.
