Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab0K2TdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:33:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52432 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab0K2TdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:33:06 -0500
Date: Mon, 29 Nov 2010 19:32:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI BUS
Message-ID: <20101129193246.GB20761@n2100.arm.linux.org.uk>
References: <1290860675-15453-1-git-send-email-ulli.kroll@googlemail.com> <201011282056.17389.arnd@arndb.de> <4CF3CF33.20407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF3CF33.20407@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 06:05:07PM +0200, Paulius Zaleckas wrote:
> No he really should NOT use readl/writel. The ONLY difference
> between readl/writel and __raw_readl/__raw_writel is endianess
> conversion. __raw_*l is not doing it. Which to use depend only
> on HW.

Wrong.  readl/writel have barriers too to guarantee ordering between
device accesses and memory accesses.  (device accesses are already
ordered with respect to themselves.)  __raw variants do not
guarantee the relative ordering between memory accesses and device
accesses.
