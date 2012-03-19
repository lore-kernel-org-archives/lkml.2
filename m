Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965156Ab2CSSbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 14:31:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60918 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965009Ab2CSSbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 14:31:00 -0400
Subject: RE: [PATCH 1/1] net/hyperv: Fix the code handling tx busy
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        KY Srinivasan <kys@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
In-Reply-To: <A1F3067C9B68744AA19F6802BAB8FFDC0DCEA873@TK5EX14MBXC223.redmond.corp.microsoft.com>
References: <1332176549-30960-1-git-send-email-haiyangz@microsoft.com>
	 <1332176549-30960-2-git-send-email-haiyangz@microsoft.com>
	 <1332177118.9397.32.camel@edumazet-glaptop>
	 <20120319104847.3a4c5fc0@nehalam.linuxnetplumber.net>
	 <A1F3067C9B68744AA19F6802BAB8FFDC0DCEA873@TK5EX14MBXC223.redmond.corp.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Mar 2012 11:30:58 -0700
Message-ID: <1332181858.9397.49.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 17:50 +0000, Haiyang Zhang wrote:

> As in my previous reply to Eric --
> We actually stop queue when the ring buffer is busy, see the code in netvsc.c
> 
> I have tested with one CPU. After NETDEV_TX_BUSY is returned, the Linux guest OS
> continues to respond without any problem.

Then something is wrong somewhere.

Dont hide a bug adding a trick.

If you ever return NETDEV_TX_BUSY from start_xmit(), then you MUST call
netif_tx_stop_queue() as well right before.

I believe I already told this before...


