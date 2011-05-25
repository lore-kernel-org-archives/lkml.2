Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab1EYJAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:00:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:35367 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1EYJAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:00:17 -0400
X-ExtLoop1: 1
Subject: Re: [PATCH] dmaengine: Add API documentation for slave dma usage
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <BANLkTikAm=D_YNFt0Regeas6AX8116L0-A@mail.gmail.com>
References: <1306238657-30089-1-git-send-email-vinod.koul@intel.com>
	 <BANLkTikDPeEFWdsVQ=Ak8jXEXsC-+uoOaw@mail.gmail.com>
	 <1306253171.30236.9.camel@vkoul-udesk3>
	 <BANLkTikjxECNAK5eS5hSu2bbEKpZX341Dw@mail.gmail.com>
	 <BANLkTikAm=D_YNFt0Regeas6AX8116L0-A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 13:56:49 +0530
Message-ID: <1306312009.30236.110.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 09:47 +0200, Per Forlin wrote:
> On 24 May 2011 23:03, Dan Williams <dan.j.williams@intel.com> wrote:

> >>> Does submit really start the transfer as well? My interpretation of
> >>> submit is that is only adds desc to a pending queue. When calling
> >>> issue_pending all these descs will be schedule for DMA transfer. Calls
> >>> to submit after this point will added to the pending queue again and
> >>> not be issued until calling issue_pending once more.
> >> For slave dma devices, submit() is used to start the transaction if the
> >> channel is idle. If its already doing a transaction then it will queue
> >> it up and submit once cureent excuting one is completed. It is not
> >> required to call issue_pending once more.
> >> I am not sure if this is true for non slave usage, Dan would that be
> >> correct for you as well?
> >
> > No, ->submit() is just an "add this descriptor to the chain"
> > operation, and ->issue_pending() is always required to make sure the
> > everything submitted previously is actively executing.  This was a
> > holdover from the very first dmaengine implementation where, for
> > efficiency reasons, it could save mmio writes by batching the issuing
> > of requests.
> Thanks Dan for clarifying.
> Vinod, I propose that the submit and issue_pending works the same for
> SLAVE and none SLAVE channels. The API should have the same definition
> independent of DMA_CAP. Please enlighten me if there are things I have
> foreseen on this matter.
I am okay with making this same for the slave devices as well.

That would also require to change few drivers which start the txn in
submit()


-- 
~Vinod

