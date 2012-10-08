Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab2JHMq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 08:46:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:7975 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab2JHMq4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:46:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,554,1344236400"; 
   d="scan'208";a="231976994"
Message-ID: <1349700409.10584.118.camel@smile>
Subject: Re: [PATCHv3 5/7] dmaengine: dw_dmac: add PCI part of the driver
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@linux.intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Mon, 08 Oct 2012 15:46:49 +0300
In-Reply-To: <CAKohpokGsAv2cPjj2EMvmTmN1Q+LOU7mN0H9YZcGzs95mm6c-w@mail.gmail.com>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348731121-2515-6-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348735450.1648.5.camel@vkoul-udesk3> <1348739022.13371.157.camel@smile>
	 <1348740071.1648.25.camel@vkoul-udesk3>
	 <CAOh2x=ntwp22Z3sHf9QehVwab--ZayF-kmTpZsjbkyQYVxrzpw@mail.gmail.com>
	 <1349691428.10584.95.camel@smile>
	 <CAKohpokGsAv2cPjj2EMvmTmN1Q+LOU7mN0H9YZcGzs95mm6c-w@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-08 at 16:19 +0530, Viresh Kumar wrote: 
> On 8 October 2012 15:47, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > This approach has the significant differences to proposed before.
> 
> I am afraid i didn't get your mail completely. Still i will try based on my
> understanding.
Ok, let me try again.

> > First of all it will export IP-block relevant functions to the kernel
> > namespace. I think it is not a good idea to pollute kernel more.
> 
> So, few routines which are required to be called from probe,
> suspend/resume and exit would be made non-static... This is what you
> wanted to say? Hopefully most of the routines would still be declared
> static in the core file. So IMHO, the simplicity or clarity that new approach
> gives has more advantages than this aspect.
The probe (core part), remove, shutdown, suspend, and resume will be
exported. Practically each generic function which will be used in
drivers outside of core. Why do we need them in the kernel namespace?

> > Moreover the API dependencies disallow transparent build and usage of
> > the drivers. For example, you can't built-in platform driver and leave
> > core part as a module.
> Obviously... Should be done this way only...
I could not agree. I don't see any reason why this is the only way.

> What if core driver isn't inserted
> and platform's probe is already called.
Nothing will happen in my case until user loads all necessary bits.

> That's why depends-on should not
> allow you to make core part as module alone...
> I couldn't get the issue completely. What's the problem in this approach?

Why we need to do this if we could avoid it? I see nothing to prevent us
to build parts as modules, or otherwise, or mixed style.
In other words one approach provides weak dependency and the other -
hard dependency between pieces of code.



-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
