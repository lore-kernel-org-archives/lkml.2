Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab0CTV27 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 17:28:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46934
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231Ab0CTV25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 17:28:57 -0400
Date: Sat, 20 Mar 2010 14:29:20 -0700 (PDT)
Message-Id: <20100320.142920.242147630.davem@davemloft.net>
To: steve@digidescorp.com
Cc: netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
       jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NET_DMA: free skbs periodically
From: David Miller <davem@davemloft.net>
In-Reply-To: <1268752964-4397-1-git-send-email-steve@digidescorp.com>
References: <1268752964-4397-1-git-send-email-steve@digidescorp.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven J. Magnani" <steve@digidescorp.com>
Date: Tue, 16 Mar 2010 10:22:44 -0500

> Under NET_DMA, data transfer can grind to a halt when userland issues a
> large read on a socket with a high RCVLOWAT (i.e., 512 KB for both).
> This appears to be because the NET_DMA design queues up lots of memcpy 
> operations, but doesn't issue or wait for them (and thus free the 
> associated skbs) until it is time for tcp_recvmesg() to return. 
> The socket hangs when its TCP window goes to zero before enough data is 
> available to satisfy the read.
> 
> Periodically issue asynchronous memcpy operations, and free skbs for ones 
> that have completed, to prevent sockets from going into zero-window mode.
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>

Applied, thanks for fixing this bug Steven.
