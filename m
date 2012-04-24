Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab2DXI1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 04:27:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44812 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2DXI1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 04:27:08 -0400
Date: Tue, 24 Apr 2012 09:26:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        spear-devel <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "jgarzik@redhat.com" <jgarzik@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 4/9] ata/sata_mv: Remove conditional compilation of
	clk code
Message-ID: <20120424082652.GQ24211@n2100.arm.linux.org.uk>
References: <20120424070426.GA24089@lunn.ch> <4F9650B3.9030406@st.com> <20120424072653.GB24089@lunn.ch> <20120424074202.GO24211@n2100.arm.linux.org.uk> <4F965D1C.2010203@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F965D1C.2010203@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 01:28:20PM +0530, Viresh Kumar wrote:
> On 4/24/2012 1:12 PM, Russell King - ARM Linux wrote:
> > If you don't have the clk API configured, you have no clocks to control.
> > So, why not make clk_get() return NULL, and make the rest of the API
> > calls do nothing?  That's what you'll end up codifying in the drivers
> > anyway.
> 
> Ok. We can return NULL from calls that return clk *. What about other
> routines that return integers. Like, clk_enable().
> 
> Is returning 0 correct? Which would mean we were able to enable clk, but
> actually we haven't.

Think about this case: if you don't have the means to control the clock
inputs to a device (for example, you don't support the clk API on your
CPU arch) then for the device to be functional, it must be supplied with
all its necessary clocks.  Therefore, the clock is already enabled.  It
makes sense for the clk API to stub-out to be completely transparent and
non-error inducing to the driver.

The problem comes with clk_get_rate().  I'd suggest merely returning zero
for that in this case.  If the clock rate is really required by a driver,
then the clk API would need to be enabled.
