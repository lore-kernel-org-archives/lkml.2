Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1D0IDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 04:03:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52762 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab1D0IDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 04:03:39 -0400
Date: Wed, 27 Apr 2011 08:28:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: viresh kumar <viresh.kumar@st.com>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, amitgoel <amit.goel@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>
Subject: Re: [PATCH 1/6] dmaengine/dw_dmac: Replace spin_lock_bh with
	irqsave variants
Message-ID: <20110427072802.GG17290@n2100.arm.linux.org.uk>
References: <e52c8e679fbf3007cf7e5e4bcfc86ea208a09d7c.1303123511.git.viresh.kumar@st.com> <4DAD2AE9.7060106@st.com> <20110426203306.GC17290@n2100.arm.linux.org.uk> <4DB7B0D5.5050504@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB7B0D5.5050504@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 11:29:49AM +0530, viresh kumar wrote:
> There are two kinds of locks taken in dw_dmac: spin_lock_bh and spin_lock.
> spin_lock_bh is taken from routines called from external drivers and spin_lock
> taken inside tasklet.
> For reasons mentioned earlier, spin_lock_bh has to be replaced with spin_lock_irqsave.
> 
> Now, Is simple spin_lock() sufficient inside tasklet?? As dma API's can be called
> from interrupt context (which will try to take spin_lock_irqsave).

Tasklets can be interrupted, so no.
