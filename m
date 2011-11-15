Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab1KOWlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 17:41:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:49976 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001Ab1KOWln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 17:41:43 -0500
Message-ID: <1321396889.3170.13.camel@pasglop>
Subject: Re: [RFC PATCH 00/17] powerpc/e500: separate e500 from e500mc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Timur Tabi <B04825@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 16 Nov 2011 09:41:29 +1100
In-Reply-To: <4A0007C2-1C2C-4162-98E8-ACCA4E673AFE@boeing.com>
References: <4E42AB6F.1050900@freescale.com>
	 <1320883399-15911-1-git-send-email-Kyle.D.Moffett@boeing.com>
	 <FF2BF3F3-1158-4747-AEEC-03D6A7C462D9@kernel.crashing.org>
	 <C0DED343-76A8-457E-BF54-E52DFCAC83A8@boeing.com>
	 <58FDDDA5-26C4-493B-A00D-81DD94A5C26A@kernel.crashing.org>
	 <20111110165455.GE11983@schlenkerla.am.freescale.net>
	 <15AB1C61-181F-4454-AF99-772B73DE0AA5@boeing.com>
	 <1320986410.21206.48.camel@pasglop>
	 <4A0007C2-1C2C-4162-98E8-ACCA4E673AFE@boeing.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-14 at 20:36 -0600, Moffett, Kyle D wrote:
> So when you are clearing a whole page, there are only 2 things you can do
> wrong with "dcbz":
> 
>   (1) Call "dcbz" with an address outside of the page you want to zero.
> 
>   (2) Omit calls "dcbz" to dcbz for some physical cachelines in the page.
> 
> Now, that's a totally different story from the userspace memset() calls
> that caused the problem originally, because they were frequently given
> memory much smaller than a page to clear, and if you didn't know exactly
> how many bytes a "dcbz" was going to clear you couldn't use it at all.

Right. That's why we pass the cache line sizes to userspace via the elf
AUX table so they don't do stupid things like that :-)

> But the kernel doesn't do that anywhere, it just uses it for page clears. 

Right, so we could easily precalc the count & increment and use a "soft"
loop.

Cheers,
Ben.


