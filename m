Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab0JAHSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:18:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53578 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751102Ab0JAHSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:18:52 -0400
Date: Fri, 1 Oct 2010 00:19:06 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: max8649 - fix setting extclk_freq
Message-ID: <20101001071906.GC20529@opensource.wolfsonmicro.com>
References: <1285912587.12422.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285912587.12422.2.camel@mola>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 01:56:27PM +0800, Axel Lin wrote:
> The SYNC bits are BIT6 and BIT7 of MAX8649_SYNC register.
> pdata->extclk_freq could be [0|1|2].
> (MAX8649_EXTCLK_26MHZ|MAX8649_EXTCLK_13MHZ|MAX8649_EXTCLK_19MHZ)
> It requires to left shift 6 bits to properly set extclk_freq.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Are there existing users of the driver?  It's not always 100% clear if
people are expecting bitfield values that will be shifted in or values
that can be ored directly in.  I don't really mind either way but I'd
rather be careful.
