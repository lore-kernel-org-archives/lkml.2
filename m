Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979Ab2KWDqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 22:46:18 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:50162 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757574Ab2KWDqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 22:46:16 -0500
Date: Fri, 23 Nov 2012 09:15:58 +0530
From: Shiraz Hashim <shiraz.hashim@st.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, Lee Jones <lee.jones@linaro.org>
Cc: <sameo@linux.intel.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <spear-devel@list.st.com>,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH V2 2/2] mfd: stmpe: Extend DT support in stmpe driver
Message-ID: <20121123034557.GB5384@localhost.localdomain>
References: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
 <b81641051dad9660b72b0028d001e5620d901160.1353560936.git.viresh.kumar@linaro.org>
 <20121122112451.GE4328@gmail.com>
 <CAKohpo=F91sZ7St3XVXqwAEgmSWXjAxxXwRs1RD5qPyW99P1vA@mail.gmail.com>
 <20121122154612.GC10986@gmail.com>
 <CAKohpok6v65TH5yZAthyxcH7bCVgF8A8m2bY_mp3yS_Y_yH1Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKohpok6v65TH5yZAthyxcH7bCVgF8A8m2bY_mp3yS_Y_yH1Xw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 10:31:48PM +0530, Viresh Kumar wrote:
> On 22 November 2012 21:16, Lee Jones <lee.jones@linaro.org> wrote:
> > The STMPE GPIO controller can't be used by Device Tree yet in
> > any case, because it doesn't have an IRQ domain. This is
> > compulsory, or it won't work. Have you tried to test this
> > functionality yet?
> 
> I don't have SPEAr board to test it anymore. I have moved out of
> ST now and working in linaro as ARM asignee. Just pushing these
> as an part time activity.
> 
> Though ST guys would have tested stmpe, but stmpe-gpio, i am not
> sure about.

Let me bring some more information here. I totally understand
Jones concerns, but the way stmpe (and may be other mfd devices)
are handled is this that the parent block (i.e. stmpe) decides on
the variants (say by probing device itself) and then prepares
associated data for the (probed) variant and creates a platform
device for the same.

For the interrupts case also, it is stmpe which registers the
irq domain. This is because, stmpe driver probes variant and
populates its platform data and stmpe-gpio may not be aware of the
variant it serves. At the same time, it (stmpe) needs few of the
(virtual) interrupts for its internal purpose also.

Hence stmpe passes irq_base to the stmpe-gpio driver while
allocating and registering irq domain by itself.

With this approach we have tested the functionality on SPEAr
platform.

--
regards
Shiraz
