Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384Ab1G2Qef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 12:34:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44381 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab1G2Qee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 12:34:34 -0400
Date: Fri, 29 Jul 2011 17:34:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: viresh kumar <viresh.linux@gmail.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>, linus.walleij@linaro.org,
        Viresh Kumar <viresh.kumar@st.com>, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com
Subject: Re: [PATCH 04/18] dmaengine/amba-pl08x: Remove redundant comment
	and rewrite original
Message-ID: <20110729163404.GN25640@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com> <e2c1bd6941e88f8988b1942c13c20cf436b3a963.1311936524.git.viresh.kumar@st.com> <1311941355.1536.529.camel@vkoul-udesk3> <CAOh2x=kqa0GxRH9o=8faPhuyyLcqxH8+AOowBTK_gMaDgJyeVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOh2x=kqa0GxRH9o=8faPhuyyLcqxH8+AOowBTK_gMaDgJyeVA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 08:47:06AM -0700, viresh kumar wrote:
> On 7/29/11, Koul, Vinod <vinod.koul@intel.com> wrote:
> > On Fri, 2011-07-29 at 16:19 +0530, Viresh Kumar wrote:
> >>  /*
> >> - * Autoselect a master bus to use for the transfer this prefers the
> >> - * destination bus if both available if fixed address on one bus the
> >> - * other will be chosen
> >> + * Autoselect a master bus to use for the transfer
> >> + * - prefers the destination bus if both available
> >> + * - if fixed address on one bus the other will be chosen
> > Not sure I get it, English is not my first language :)
> 
> Nor mine either. :)
> 
> Will give some more explanation.
> 
> But before that i wanted to know the exact purpose of this
> master-slave concept here.
> Probably it is for choosing the victim for reduction of width, in case
> src and dest addresses
> are misaligned to each other.
> @Russell and Linus: Is this correct?

No idea - most of the LLI code that's in this driver came from within
ARM Ltd, and I've dared not change its behaviour in case the original
author knew something that isn't public.

In addition, as the ARM platforms I have with a PL080 on seem to have
their DMA support buggered beyond belief (that's putting it mildly),
I've not really been able to test anything more complex than single
byte DMA to a UART.  Linus W has one of the rare ARM platforms which
has a working implementation.

I'm not sure why the function is named in terms of master/slave because
those terms don't seem to have much to do with what its actually doing
(which is selecting either the source or destination to handle alignment
issues with.)  And it's not really about busses either.

If the LLI creation code can be greatly simplified and that function
killed off, that'd certainly be a great step forward.  In the mean time
I'd suggest leaving that comment as-is as long as the function exists.
