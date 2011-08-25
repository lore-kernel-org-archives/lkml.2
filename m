Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1HYSsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 14:48:38 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38944 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755214Ab1HYSs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 14:48:29 -0400
X-Sasl-enc: uQKwMuQ2I11zuOf1DcdJQkAzsjxburahfG7LNRW+SpFc 1314298108
Date: Thu, 25 Aug 2011 11:46:55 -0700
From: Greg KH <greg@kroah.com>
To: Timur Tabi <timur@freescale.com>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] tty/powerpc: fix build break with ehv_bytechan.c on
 allyesconfig
Message-ID: <20110825184655.GB1891@kroah.com>
References: <1314289245-14946-1-git-send-email-timur@freescale.com>
 <20110825163234.GA31629@kroah.com>
 <4E568E19.405@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E568E19.405@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 01:02:01PM -0500, Timur Tabi wrote:
> Greg KH wrote:
> > tested doesn't mean that it shouldn't still build properly for other
> > platforms, right?
> 
> The problem is the dependency on MSR_GS, which is defined only for Book-E
> PowerPC chips, not all PowerPC.
> 
> So I gave it some more thought, and technically ePAPR extends beyond Book-E, so
> it's wrong for the driver to depend on anything specific to Book-E.  I've
> removed the code that breaks:
> 
> 	/* Check if we're running as a guest of a hypervisor */
> 	if (!(mfmsr() & MSR_GS))
> 		return;

But don't you really want this type of check at runtime?  What happens
if you load this driver on a machine that is not a guest?  Will things
break?  Shouldn't you still refuse to load somehow?

thanks,

greg k-h
