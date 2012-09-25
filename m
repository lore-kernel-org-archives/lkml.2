Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab2IYFf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 01:35:57 -0400
Received: from londo.lunn.ch ([80.238.139.98]:44503 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab2IYFf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 01:35:56 -0400
Date: Tue, 25 Sep 2012 07:35:42 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] ARM: dove: Remove watchdog from DT
Message-ID: <20120925053542.GK14266@lunn.ch>
References: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1348531338-16624-6-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348531338-16624-6-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 02:02:17AM +0200, Sebastian Hesselbarth wrote:
> The watchdog on dove requires an interrupt that is not yet
> available on DT. Therefore, the watchdog DT node is removed
> until the corresponding chained intc is available.

Hi Sebastian

Just for my understanding: Is the problem here:

	/* Clear watchdog timer interrupt */
	reg = readl(BRIDGE_CAUSE);
	reg &= ~WDT_INT_REQ;
	writel(reg, BRIDGE_CAUSE);

I ask, because there is no need to pass an interrupt in the DT node.

It is clear to me that bit of code above needs cleaning up sometime
soon.

	Thanks
		Andrew
