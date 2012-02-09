Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab2BIL2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 06:28:54 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52288 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab2BIL2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 06:28:53 -0500
Date: Thu, 9 Feb 2012 11:28:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: "David S. Miller" <davem@davemloft.net>, Danny Kukawka <dkukawka@suse.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steve Glendinning <steve.glendinning@smsc.com>
Subject: Re: [PATCH 20/50] smsc911x: use dev_hw_addr_random() instead of
 random_ether_addr()
Message-ID: <20120209112848.GA2590@sirena.org.uk>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
 <1328735457-29986-21-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328735457-29986-21-git-send-email-danny.kukawka@bisect.de>
X-Cookie: Being ugly isn't illegal.  Yet.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 10:10:27PM +0100, Danny Kukawka wrote:

> +	if (dev->addr_assign_type & NET_ADDR_RANDOM)
> +		dev->addr_assign_type ^= NET_ADDR_RANDOM;

It would be clearer to just write

		dev->addr_assign_type &= ~NET_ADDR_RANDOM;

to clear the bit - the ^ takes more thinking.
