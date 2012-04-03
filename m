Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab2DCLjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:39:39 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48051 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab2DCLjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:39:35 -0400
Subject: Re: [PATCH v6 0/2] Ethernet drivers for WIZnet chips
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mike Sinkovsky <msink@permonline.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1333450726-24455-1-git-send-email-msink@permonline.ru>
References: <1332752876-1650-1-git-send-email-msink@permonline.ru>
	 <1333450726-24455-1-git-send-email-msink@permonline.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Apr 2012 13:39:30 +0200
Message-ID: <1333453170.18626.65.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-03 at 16:58 +0600, Mike Sinkovsky wrote:
> Based on original driver from chip manufacturer, but nearly full rewite.
> Tested and used in production with Blackfin BF531 embedded processor.
> 
> Signed-off-by: Mike Sinkovsky <msink@permonline.ru>
> ---
> v6:
>  - remove (S0_TX_FSR < skb->len) check in TX handler, it doesn't work
>    anyway. Chip can transmit only one frame with MTU 1500 at a time,
>    and tx buffer size is bigger.

So what happens if XXX frames are given to start_xmit() in a flood ?

You removed any flow control, how can this work ?

Device has an infinite queue ?


