Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2DMRKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 13:10:04 -0400
Received: from mail.vyatta.com ([76.74.103.46]:47326 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548Ab2DMRJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 13:09:58 -0400
Date: Fri, 13 Apr 2012 10:09:54 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: mlindner@marvell.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: sky2: in free_buffers() do proper checks before call of
 rx_clean()
Message-ID: <20120413100954.6fdc0f5c@nehalam.linuxnetplumber.net>
In-Reply-To: <20120403001327.GB10227@Neptun>
References: <20120403001327.GB10227@Neptun>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2012 02:13:27 +0200
Lino Sanfilippo <LinoSanfilippo@gmx.de> wrote:

> In sky2_open() free_buffers() is called in case that alloc_buffers() failed.
> Here we do the check for sky2->rx_le too late, since we already called
> rx_clean() which accessed rx_le. Furthermore we lack a check for sky2->rx_ring
> which is also accessed by rx_clean().
> 
> With this patch both sky2->rx_le and sky2->rx_ring are checked before
> alloc_buffers() is called.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

Looking at sky2_alloc_buffers, it really needs to change to have
proper unwind instead. If some portion of the memory required isn't available
everything needs to be undone.
