Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab2EUQRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 12:17:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51531 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab2EUQRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 12:17:14 -0400
Date: Mon, 21 May 2012 13:17:07 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Minho Ban <mhban@samsung.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Fix null pointer dereference in
 l2cap_chan_send
Message-ID: <20120521161707.GD16942@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Minho Ban <mhban@samsung.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <4FB9932B.9070101@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB9932B.9070101@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minho,

* Minho Ban <mhban@samsung.com> [2012-05-21 09:58:19 +0900]:

> If l2cap_chan_send is called will null conn it will cause kernel Oops.
> This patch checks if conn is valid before entering l2cap_chan_send.

chan->conn should be always valid, and if not we have a bug somewhere else in
the code and not in l2cap_chan_send(). It could be a locking problem maybe.
Also check if you can reproduce this with latest bluetooth-next.

	Gustavo
