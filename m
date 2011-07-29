Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab1G2NDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:03:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48048 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab1G2NDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 09:03:04 -0400
Date: Fri, 29 Jul 2011 14:02:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Viresh Kumar <viresh.kumar@st.com>, linus.walleij@linaro.org,
        pratyush.anand@st.com, rajeev-dlh.kumar@st.com, bhupesh.sharma@st.com,
        shiraz.hashim@st.com, linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh.linux@gmail.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 09/18] dmaengine/amba-pl08x: Schedule tasklet in case
	of error interrupt
Message-ID: <20110729130245.GM25640@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com> <9c81beb9cd84f84b58abbd24ebfae85dfe8d8ee1.1311936524.git.viresh.kumar@st.com> <1311941799.1536.532.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311941799.1536.532.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 05:46:39PM +0530, Koul, Vinod wrote:
> On Fri, 2011-07-29 at 16:19 +0530, Viresh Kumar wrote:
> > +	/* check & clear - ERR & TC interrupts */
> > +	err = readl(pl08x->base + PL080_ERR_STATUS);
> > +	if (err) {
> > +		dev_err(&pl08x->adev->dev, "%s error interrupt, register value"
> > +				"0x%08x\n", __func__, err);
> again this looks convoluted, and the stuff is quotes can be in single
> line :)

And it shows the danger of wrapping quoted strings.  This will print
the following message:

...: pl08x_irq error interrupt, register value0xNNNNNNNN

So it may want a space between 'value' and '0x%08x' - and it may want a
':' after '%s' too.
