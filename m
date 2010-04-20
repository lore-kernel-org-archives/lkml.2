Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab0DTQcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 12:32:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38787 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751672Ab0DTQcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 12:32:39 -0400
Date: Wed, 21 Apr 2010 01:32:42 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mc13783-regulator: fix a memory leak in
 mc13783_regulator_remove
Message-ID: <20100420163241.GA30625@opensource.wolfsonmicro.com>
References: <h2t427d64721004181858s4c01a195ma70d3ce96ee2d343@mail.gmail.com>
 <20100419170059.GB29819@opensource.wolfsonmicro.com>
 <s2y427d64721004192234x96d286e4teab6f32323d2b291@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s2y427d64721004192234x96d286e4teab6f32323d2b291@mail.gmail.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 01:34:18PM +0800, Axel Lin wrote:
> 2010/4/20 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> > On Mon, Apr 19, 2010 at 09:58:02AM +0800, Axel Lin wrote:

> >> +       platform_set_drvdata(pdev, NULL);
> >> +

> > This is completely unrelated to what your description says (and is not
> > needed).

> In the probe function , the driver uses platform_set_drvdata(pdev,
> priv) to store a pointer to the priv data structure.
> To avoid leaving a dangling pointer behind, the driver should clear
> the pointer to priv before freeing priv.

All of which is totally unrelated to the description of the patch.  One
of the things that I do when I'm reviewing is look to see if the patch
does what the description says - unrelated changes are normally a red
flag that something is wrong and there are mistakes or unintended side
effects lurking in the code.

The dangling pointer isn't really a problem in any case; if a driver
is relying on the behaviour of the pointer between bindings it's in
trouble anyway since there aren't any guarantees about what happens.
See the recent discussion about the same issue for I2C.
