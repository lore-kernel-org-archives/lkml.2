Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab2BHWuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 17:50:09 -0500
Received: from mail.vyatta.com ([76.74.103.46]:58273 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab2BHWuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 17:50:07 -0500
Date: Wed, 8 Feb 2012 14:50:04 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: "David S. Miller" <davem@davemloft.net>, Danny Kukawka <dkukawka@suse.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/50] eth: reset addr_assign_type if eth_mac_addr()
 called
Message-ID: <20120208145004.171e4d54@nehalam.linuxnetplumber.net>
In-Reply-To: <1328735457-29986-2-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
	<1328735457-29986-2-git-send-email-danny.kukawka@bisect.de>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Feb 2012 22:10:08 +0100
Danny Kukawka <danny.kukawka@bisect.de> wrote:

> +	if (dev->addr_assign_type & NET_ADDR_RANDOM)
> +		dev->addr_assign_type ^= NET_ADDR_RANDOM;

Why not just avoid the conditional, or better yet use bitops?

	dev->addr_assign_type &= ~NET_ADDR_RANDOM;

