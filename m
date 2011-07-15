Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964881Ab1GOG5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 02:57:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59503 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab1GOG5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 02:57:37 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mcp23s08: isolate spi specific parts
References: <1310673568-30577-1-git-send-email-jacmet@sunsite.dk>
	<1310673568-30577-3-git-send-email-jacmet@sunsite.dk>
	<20110715025358.GZ2927@ponder.secretlab.ca>
Date: Fri, 15 Jul 2011 08:57:24 +0200
In-Reply-To: <20110715025358.GZ2927@ponder.secretlab.ca> (Grant Likely's
	message of "Thu, 14 Jul 2011 20:53:58 -0600")
Message-ID: <87aacgav57.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Grant" == Grant Likely <grant.likely@secretlab.ca> writes:

 Grant> On Thu, Jul 14, 2011 at 09:59:27PM +0200, Peter Korsgaard wrote:
 >> Change spi member of struct mcp23s08 to be a ops-specific opaque data
 >> pointer, and move spi specific knowledge out of mcp23s08_probe_one().
 >> 
 >> No functional change, but is needed to add i2c support.
 >> 
 >> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
 >> ---
 >> drivers/gpio/mcp23s08.c |   75 ++++++++++++++++++++++++++++++++--------------
 >> static int __init mcp23s08_init(void)
 >> {
 >> -	return spi_register_driver(&mcp23s08_driver);
 >> +	int ret = 0;

 Grant> '= 0' is redundant.

Will fix.

 >> +
 >> +#ifdef CONFIG_SPI_MASTER
 >> +	ret = spi_register_driver(&mcp23s08_driver);
 >> +	if (ret)
 >> +		return ret;
 >> +#endif /* CONFIG_SPI_MASTER */
 >> +
 >> +	return ret;

 Grant> This change really belongs in the 3rd patch that adds the i2c
 Grant> registration.

You can argue for both ways. With my approach the 3rd patch doesn't
touch any of the spi stuff, but OK - I'll change.


-- 
Bye, Peter Korsgaard
