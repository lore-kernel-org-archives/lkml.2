Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab1FVTnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:43:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37830 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758618Ab1FVTnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:43:02 -0400
Date: Wed, 22 Jun 2011 20:42:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 1/8] regmap: Add generic non-memory mapped register
 access API
Message-ID: <20110622194258.GA20340@opensource.wolfsonmicro.com>
References: <20110622184407.GC13847@sirena.org.uk>
 <1308768353-19372-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <4E023C72.3030109@metafoo.de>
 <20110622191145.GA19628@opensource.wolfsonmicro.com>
 <4E024089.9040204@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E024089.9040204@metafoo.de>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 09:20:41PM +0200, Lars-Peter Clausen wrote:

> Well, then the spi regmap driver needs to use read_flag_bit = 7 instead of
> read_flag_bit = 8 and the BUG_ON should also be updated to read_flag_bit >= 8.

Bah, so it should.

> And the current code also disallows to use the first bit as the read_flag. So
> in my opinion using a one-based index here is a good idea.

Disallowing that case was half the intention, the main issue being that
if you're flagging in the bottom bit of the top byte on the bus then
you'll be in the middle of the bitfield used by the register which is
going to confuse things.

If something really needs to use the bottom bit we probably need to add
a second form of mangling which uses the bottom of the register rather
than the top, or allow buses to have bus specific register formatting.

Although come to think of it this doesn't actually help your cases at
all as those are per-device settings and this is a per bus setting so
I'm inclined to just revert back to the original code and say that for a
first pass those devices are being sufficiently odd that we don't
support them, we can add support as an extension later.
