Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1DOJPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 05:15:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46578 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab1DOJPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 05:15:50 -0400
Date: Fri, 15 Apr 2011 10:15:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: viresh kumar <viresh.kumar@st.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        amitgoel <amit.goel@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: dmaengine: Can we schedule new transfer from dma callback
	routine??
Message-ID: <20110415091529.GJ1611@n2100.arm.linux.org.uk>
References: <4DA2B3D8.6060707@st.com> <20110411085603.GA13041@n2100.arm.linux.org.uk> <4DA7E997.3080402@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA7E997.3080402@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 12:15:43PM +0530, viresh kumar wrote:
> There is one more issue in the current DW_DMAC driver.
> As most of interrupt processing is done in tasklet, spin_lock_bh() is used
> in almost every routine.

As you can't use spin_lock_bh() from IRQ context (you'll get a lockdep
warning) these need to be converted to being the irqsave versions.
That's probably the easiest fix.
