Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab2AXUnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:43:22 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:41756 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab2AXUnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:43:20 -0500
Date: Tue, 24 Jan 2012 15:43:11 -0500 (EST)
Message-Id: <20120124.154311.1857537203481263793.davem@davemloft.net>
To: rubini@gnudd.com
Cc: linux-kernel@vger.kernel.org, peppe.cavallaro@st.com,
        netdev@vger.kernel.org, giancarlo.asnaghi@st.com
Subject: Re: [PATCH 0/3] stmmac patches
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1327394750.git.rubini@gnudd.com>
References: <cover.1327394750.git.rubini@gnudd.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 24 Jan 2012 12:43:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alessandro Rubini <rubini@gnudd.com>
Date: Tue, 24 Jan 2012 10:08:45 +0100

> The following three patches add support for the STA2X11 device in the
> stmmac driver. The device is a PCI-e bridge, so I need just to
> add my identifiers.  The identifiers being added are already in pci_ids
> of linux-next.

This patch is fine.

> The second patch is a cleanup, already acked by both authors.

I'm not applying this, instead if you want to make changes in this
area then fix this driver so that it can properly support multiple
device instances.

I can't even imagine ever writing a driver where from the start
it can handle only one device instance, this is pure insanity
especially for a PCI device driver.

> As for the third, I noted that there is "#ifndef MODULE" adding
> __setup directives, but the module parameters already work, and I
> successfully use stmmac.phy_id=1 to boot my system, so the __setup
> adre just duplicates. This has not been acked by Giuseppe Cavallaro
> but I offer it here nonetheless.

You're breaking things for anyone using 'stmmaceth='.  So I'm not
applying this patch either.
