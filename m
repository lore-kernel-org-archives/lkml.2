Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab2IUWU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 18:20:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:1524 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105Ab2IUWU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 18:20:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,464,1344236400"; 
   d="scan'208";a="210072815"
Date: Sat, 22 Sep 2012 00:20:53 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 15/19] mfd: Don't convert just one IRQ using irqdomain if
 a range is provided
Message-ID: <20120921222053.GC28670@sortiz-mobl>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
 <201209071337.26587.arnd@arndb.de>
 <20120907134259.GJ29601@gmail.com>
 <201209071357.27779.arnd@arndb.de>
 <20120917134550.GU3647@sortiz-mobl>
 <20120917141105.GE6777@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917141105.GE6777@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, Sep 17, 2012 at 03:11:07PM +0100, Lee Jones wrote:
> On Mon, Sep 17, 2012 at 03:45:50PM +0200, Samuel Ortiz wrote:
> > Hi Lee, Arnd,
> > 
> > On Fri, Sep 07, 2012 at 01:57:27PM +0000, Arnd Bergmann wrote:
> > > On Friday 07 September 2012, Lee Jones wrote:
> > > > On Fri, Sep 07, 2012 at 01:37:26PM +0000, Arnd Bergmann wrote:
> > > > > On Friday 07 September 2012, Lee Jones wrote:
> > > > > > On Fri, Sep 07, 2012 at 12:35:41PM +0000, Arnd Bergmann wrote:
> > > > >
> > > > > The examples I had seen before were all just ranges of two interrupts,
> > > > > and in those cases it was clear that splitting them would be best.
> > > > > 
> > > > > In the exampled of the ab8500-gpio driver, it looks like the resource is
> > > > > not actually being used, and the gpio driver implements its own irq_chip,
> > > > > so maybe we can get away with not solving this problem for now.
> > > > 
> > > > Understood. I'd still feel more comfortable if we didn't trash the
> > > > range. I think it would be best to show the warning, and leave the
> > > > range for its target driver to take care - hence the patch.
> > > > 
> > > > ... but it's your call.
> > > 
> > > I'm fine with whatever Samuel sees fit here.  My personal opinion is
> > > that leaving the range alone for the child driver to do the conversion
> > > would be too inconsistent and only lead to confusion with driver authors.
> > Although I agree modifying the range is not very nice from the MFD core, I
> > also think that the actual mapping should always be handled by MFD and not
> > depend on wether the range is a singleton or not. Moreover the semantics of
> > leaving the range untouched meaning that we haven't done the mappings is
> > obscure.
> > So I'm not taking this patch, sorry Lee.
> 
> No problem.
> 
> Would it be better if we _did_ support ranges, and map all of the
> IRQs in the range instead?
I think that would be a reasonable solution, unless Arnd or Mark see a serious
problem with that.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
