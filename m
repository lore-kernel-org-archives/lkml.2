Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964884Ab2B1KMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:12:54 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:43488 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab2B1KMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:12:52 -0500
X-IronPort-AV: E=Sophos;i="4.73,495,1325462400"; 
   d="scan'208";a="10977242"
Message-ID: <1330423970.31269.45.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH-WIP 01/13] xen/arm: use r12 to pass the hypercall number
 to the hypervisor
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Peter Maydell <peter.maydell@linaro.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 28 Feb 2012 10:12:50 +0000
In-Reply-To: <CAFEAcA8PzT9mfnEz60CYvwQWX1OEvejrZvkpuPL2LpTPosp8cA@mail.gmail.com>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
	 <1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <1330360043.8557.302.camel@zakaz.uk.xensource.com>
	 <CAFEAcA8PzT9mfnEz60CYvwQWX1OEvejrZvkpuPL2LpTPosp8cA@mail.gmail.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 21:05 +0000, Peter Maydell wrote:
> On 27 February 2012 16:27, Ian Campbell <Ian.Campbell@citrix.com> wrote:
> > R12 is not accessible from the 16 bit "T1" Thumb encoding of mov
> > immediate (which can only target r0..r7).
> >
> > Since we support only ARMv7+ there are "T2" and "T3" encodings available
> > which do allow direct mov of an immediate into R12, but are 32 bit Thumb
> > instructions.
> >
> > Should we use r7 instead to maximise instruction density for Thumb code?
> 
> r7 is (used by gcc as) the Thumb frame pointer; I don't know if this
> makes it worth avoiding in this context.

I think it does.

It actually sounds as if using r12 is fine here, the impact on code
density should be pretty small -- there aren't really all that many call
sites which involve hypercalls.

By way of an example I measured an x86 kernel which should be using more
hypercalls due to pv paging etc and found that 0.014% of the lines in
"objdump -d" contained a call to the hypercall_page. (I know not all
lines of objdump -d output are instructions but it's a reasonable approx
IMHO).

So I think using 3 16 bit instructions slots instead of 2 won't make
much impact in practice.

Thanks,
Ian.

