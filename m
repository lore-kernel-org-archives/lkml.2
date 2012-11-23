Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082Ab2KWJeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:34:01 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50901 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759018Ab2KWJd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:33:58 -0500
Date: Fri, 23 Nov 2012 09:33:52 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Shiraz Hashim <shiraz.hashim@st.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH V2 2/2] mfd: stmpe: Extend DT support in stmpe driver
Message-ID: <20121123093352.GC17471@gmail.com>
References: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
 <b81641051dad9660b72b0028d001e5620d901160.1353560936.git.viresh.kumar@linaro.org>
 <20121122112451.GE4328@gmail.com>
 <CAKohpo=F91sZ7St3XVXqwAEgmSWXjAxxXwRs1RD5qPyW99P1vA@mail.gmail.com>
 <20121122154612.GC10986@gmail.com>
 <CAKohpok6v65TH5yZAthyxcH7bCVgF8A8m2bY_mp3yS_Y_yH1Xw@mail.gmail.com>
 <20121123034557.GB5384@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121123034557.GB5384@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2012, Shiraz Hashim wrote:

> On Thu, Nov 22, 2012 at 10:31:48PM +0530, Viresh Kumar wrote:
> > On 22 November 2012 21:16, Lee Jones <lee.jones@linaro.org> wrote:
> > > The STMPE GPIO controller can't be used by Device Tree yet in
> > > any case, because it doesn't have an IRQ domain. This is
> > > compulsory, or it won't work. Have you tried to test this
> > > functionality yet?
> > 
> > I don't have SPEAr board to test it anymore. I have moved out of
> > ST now and working in linaro as ARM asignee. Just pushing these
> > as an part time activity.
> > 
> > Though ST guys would have tested stmpe, but stmpe-gpio, i am not
> > sure about.
> 
> Let me bring some more information here. I totally understand
> Jones concerns, but the way stmpe (and may be other mfd devices)
> are handled is this that the parent block (i.e. stmpe) decides on
> the variants (say by probing device itself) and then prepares
> associated data for the (probed) variant and creates a platform
> device for the same.

I realise this, but now we're using Device Tree, there's no need
to stuff pdata in the parent driver now. It's better that the
child devices are self sufficient.

> For the interrupts case also, it is stmpe which registers the
> irq domain. This is because, stmpe driver probes variant and
> populates its platform data and stmpe-gpio may not be aware of the
> variant it serves. At the same time, it (stmpe) needs few of the
> (virtual) interrupts for its internal purpose also.

I know. I wrote the IRQ domain for STMPE. ;)

STMPE needs its own one too, which I will work on now.

STMPE-GPIO doesn't need to be aware of anything, the device
which wishes to use its GPIOs/IRQs will reference it from
Device Tree in the manor previously explained.

> Hence stmpe passes irq_base to the stmpe-gpio driver while
> allocating and registering irq domain by itself.

Not anymore it doesn't. There are no irq_base:s with DT. All
IRQs are dynamic, hence why STMPE requires its own domain to
play with. I can fix that.

> With this approach we have tested the functionality on SPEAr
> platform.

You'll need to test it again with the new DT approach too. :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
