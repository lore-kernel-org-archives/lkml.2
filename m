Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab1JMWMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 18:12:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43186 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754409Ab1JMWMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 18:12:35 -0400
Date: Thu, 13 Oct 2011 23:12:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rajendra Nayak <rnayak@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, lrg@ti.com, b-cousson@ti.com, patches@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111013221232.GB2866@opensource.wolfsonmicro.com>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
 <1318263578-7407-4-git-send-email-rnayak@ti.com>
 <20111010172222.GG3607@opensource.wolfsonmicro.com>
 <4E93DB41.2080900@ti.com>
 <20111013183821.GN18574@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111013183821.GN18574@ponder.secretlab.ca>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 12:38:21PM -0600, Grant Likely wrote:

> These *sound* like flags that the driver would set based on its own
> capabilities; in which case it is something that would be encoded
> directly into the driver.

They're almost entirely a combination of system specifics and software
capabilities - it's not even reliably one or the other.  For example the
ability to switch regulator modes is going to depend on a combination of
the modes a specific regulator offers, the set of things connected to
the regulator in the current system (not all of which will be software
visible), how good all the connected consumer drivers are at providing
accurate information about what they're going to need from the system in
terms of quality of regulation and current draw and how good the board
design is in making these things reality.

For robustness (for some of these things if you get it wrong we're
talking catastrophic hardware failure) the Linux regulator API is
extremely conservative and won't touch the hardware unless explicitly
told that a specific thing is OK on a given board.
