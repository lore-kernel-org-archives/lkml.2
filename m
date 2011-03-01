Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab1CAU0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:26:37 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39809 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153Ab1CAU0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:26:36 -0500
Date: Tue, 1 Mar 2011 20:26:11 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stuart Menefy <stuart.menefy@st.com>,
        Peppe CAVALLARO <peppe.cavallaro@st.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH (sh-2.6) 1/4] clksource: Generic timer infrastructure
Message-ID: <20110301202611.GC27107@n2100.arm.linux.org.uk>
References: <1298369864-24429-1-git-send-email-peppe.cavallaro@st.com> <201102241820.55873.arnd@arndb.de> <4D6D0EA3.9000504@st.com> <201103011743.19847.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103011743.19847.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 05:43:19PM +0100, Arnd Bergmann wrote:
> On Tuesday 01 March 2011, Stuart Menefy wrote:
> > On 24/02/11 17:20, Arnd Bergmann wrote:
> > > Also, what is the difference between this and clkdev?
> > 
> > clkdev can be used to find a struct clk, which is fine if you just want to
> > read the time. In this instance we want to get interrupts from the timer
> > hardware, which isn't supported by the clk infrastructure.
> 
> (adding Russell to Cc)
> 
> Is this something that could sensibly be added to clk/clkdev?

I don't understand - why would anyone want to use clk/clkdev for timers.
clk/clkdev is all about those signals on the SoC which wiggle at regular
intervals between logic 0 and logic 1.  It's not about things which count,
which seems to be an entirely separate problem, and hence why there's
nothing to deal with interrupts or setting timeouts etc.
