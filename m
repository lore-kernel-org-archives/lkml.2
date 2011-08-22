Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab1HVSf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 14:35:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39790 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab1HVSfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 14:35:53 -0400
Date: Mon, 22 Aug 2011 11:35:44 -0700 (PDT)
Message-Id: <20110822.113544.28950168095176936.davem@davemloft.net>
To: jun.kondo@ctc-g.co.jp
Cc: linux-kernel@vger.kernel.org, omega-g1@ctc-g.co.jp, notsuki@redhat.com,
        motokazu.kozaki@hp.com, htaira@redhat.com, netdev@vger.kernel.org,
        tomohiko.takahashi@ctc-g.co.jp, kotaro.sakai@ctc-g.co.jp,
        ken.sugawara@ctc-g.co.jp
Subject: Re: [omega-g1:11072] Re: [PATCH] net: configurable sysctl
 parameter "net.core.tcp_lowat" for sk_stream_min_wspace()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E51A3F0.5010500@ctc-g.co.jp>
References: <4E4E2CCD.6050809@ctc-g.co.jp>
	<20110819.024326.598275465899000817.davem@davemloft.net>
	<4E51A3F0.5010500@ctc-g.co.jp>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 22 Aug 2011 11:35:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jun.Kondo" <jun.kondo@ctc-g.co.jp>
Date: Mon, 22 Aug 2011 09:33:52 +0900

> is it (really) network problem ?
> or is wmem not enough free to write?

Oh yes you can indeed make this determination, by using the socket
timeouts via the SO_RCVTIMEO and SO_SNDTIMEO socket options.

Timeouts, when hit, will return -EINTR, whereas lack of buffer space
on a non-blocking socket will return -EAGAIN.

I think you simply are unaware of the facilities available in the BSD
socket API.
