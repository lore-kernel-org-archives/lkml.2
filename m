Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1EYL2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 07:28:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:45203 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab1EYL2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 07:28:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,266,1304319600"; 
   d="scan'208";a="7292657"
Subject: Re: [PATCH] dmaengine: Add API documentation for slave dma usage
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <BANLkTinbSAxozR6NivY6wddre1nRF5RmZA@mail.gmail.com>
References: <1306238657-30089-1-git-send-email-vinod.koul@intel.com>
	 <BANLkTikDPeEFWdsVQ=Ak8jXEXsC-+uoOaw@mail.gmail.com>
	 <1306253171.30236.9.camel@vkoul-udesk3>
	 <BANLkTikjxECNAK5eS5hSu2bbEKpZX341Dw@mail.gmail.com>
	 <BANLkTikAm=D_YNFt0Regeas6AX8116L0-A@mail.gmail.com>
	 <1306312009.30236.110.camel@vkoul-udesk3>
	 <BANLkTikn3BBeNyuUeZ9BhG5QLj-dmcGjTg@mail.gmail.com>
	 <1306316082.30236.137.camel@vkoul-udesk3>
	 <BANLkTinbSAxozR6NivY6wddre1nRF5RmZA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 16:25:23 +0530
Message-ID: <1306320923.30236.158.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 16:21 +0530, Per Forlin wrote:
> On 25 May 2011 11:34, Koul, Vinod <vinod.koul@intel.com> wrote:

> I would like to ask a question on usage of DMA_CTRL_ACK while we're at it.
> In ste_dma40 I added support to reuse descriptors if DMA_CTRL_ACK is
> clear. The purpose of DMA_CTRL_ACK is to set up dependency but is it
> also a valid to reuse it?
> I mean submit the same descriptor again and again without having to
> call prepare_slave_sg.
> Example:
> desc = prepare_slave_sg()
> submit(desc)
> issue_pending(desc)
> 
> wait_for_callback()
> 
> submit(desc)
> issue_pending(desc)
> 
I think your question is answered in dmaengine.h. Quoting here:
* @DMA_CTRL_ACK - if clear, the descriptor cannot be reused until the 
* client acknowledges receipt, i.e. has has a chance to establish any
* dependency chains

The DMA driver recycles the descriptors which it returns for the
transfer APIs. The DMA_CTRL_ACK flag would tell driver explicitly not to
reuse this descriptor until the client clears this flag.
Since the descriptor is still valid after callback notification it can
be reused by client in the way you described.

Again, Dan can you please confirm if my interpretation is correct.


-- 
~Vinod

