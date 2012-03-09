Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab2CIQU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 11:20:26 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49817 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab2CIQUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 11:20:24 -0500
Date: Fri, 9 Mar 2012 11:20:20 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Dave Martin <dave.martin@linaro.org>
cc: Richard Earnshaw <Richard.Earnshaw@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH-WIP 01/13] xen/arm: use r12 to pass the hypercall number
 to the hypervisor
In-Reply-To: <CA+wbFdfF5c+Bw6RrxCm3YThqCRDuDYzanq+HV8a6LyXaBqWrQA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1203091112050.24151@xanadu.home>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop> <1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com> <1330360043.8557.302.camel@zakaz.uk.xensource.com> <20120227180355.GB2023@linaro.org> <1330371219.10008.34.camel@dagon.hellion.org.uk>
 <20120228102040.GB2063@linaro.org> <1330426133.31269.70.camel@zakaz.uk.xensource.com> <alpine.DEB.2.00.1202281149210.23091@kaball-desktop> <20120229093436.GA2077@linaro.org> <1330509362.4270.20.camel@zakaz.uk.xensource.com> <20120229125826.GC2077@linaro.org>
 <alpine.LFD.2.02.1203021528150.31242@xanadu.home> <4F5882BF.1030104@arm.com> <alpine.LFD.2.02.1203081041340.24151@xanadu.home> <4F58FEC0.8080706@arm.com> <CA+wbFdfF5c+Bw6RrxCm3YThqCRDuDYzanq+HV8a6LyXaBqWrQA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2012, Dave Martin wrote:

> Register variables feel like a red herring though.  We're only using
> those because we can't do the needful thing and actually desscribe
> these constraints in the asm constraints (which would seem to be the
> right place).  We specifically don't care where those values are
> except at the boundaries of the asm block itself.

Absolutely.

> Is there a reason why ARM gcc doesn't provide the ability to specify
> such exact-register constraints, or is this more for historical
> reasons?  It is possible?

I don't know how much things have changed since I last looked at the gcc 
code, but implementing this seemed to be pretty trivial at the time.  
The problem would be to determine a good letter scheme to map to actual 
registers.


Nicolas
