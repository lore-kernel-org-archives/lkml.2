Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab1IESWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 14:22:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58703 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752869Ab1IESWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:22:31 -0400
Date: Mon, 5 Sep 2011 11:22:27 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/8] regmap: Add the indexed cache support
Message-ID: <20110905182226.GA30333@opensource.wolfsonmicro.com>
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1314978375-11539-3-git-send-email-dp@opensource.wolfsonmicro.com>
 <4E613986.4040007@metafoo.de>
 <20110905095519.GC30114@opensource.wolfsonmicro.com>
 <4E64A102.4060902@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E64A102.4060902@metafoo.de>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 12:14:26PM +0200, Lars-Peter Clausen wrote:

> In my opinion we should work towards having rbtree as the only cache type, but
> with optional lzo compression on the rbtree node blocks.

If we are going to do something like that we should probably just go by
block size to decide if we should do the compression and do the thing
with keeping the most recently used LZO block (or perhaps a few)
uncompressed in RAM for speed.  Probably also look at the compression we
get when we decide to compress and not bother doing the compression if
it's a small saving, though we will have burned CPU.
