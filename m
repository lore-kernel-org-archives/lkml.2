Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab2IJMwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:52:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38883 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757849Ab2IJMwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 08:52:22 -0400
Date: Mon, 10 Sep 2012 13:51:37 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 02/31] arm64: Kernel booting and initialisation
Message-ID: <20120910125137.GC27042@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-3-git-send-email-catalin.marinas@arm.com>
 <20120909172046.GB31430@game.jcrosoft.org>
 <alpine.LFD.2.02.1209091923180.28681@xanadu.home>
 <20120910055339.GC31430@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910055339.GC31430@game.jcrosoft.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 06:53:39AM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 19:29 Sun 09 Sep     , Nicolas Pitre wrote:
> > On Sun, 9 Sep 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > > On 17:26 Fri 07 Sep     , Catalin Marinas wrote:
> > > > +The image must be placed at the specified offset (currently 0x80000)
> > > > +from the start of the system RAM and called there. The start of the
> > > > +system RAM must be aligned to 2MB.
> > > can we drop this
> > 
> > Drop what?
> > And why?
> This contrain the must be loadable at any address

You can't easily load the kernel image at any address, unless it can
relocate itself and you have a way to specify PHYS_OFFSET. We don't want
a compile-time PHYS_OFFSET, the kernel detects it at boot time based on
the load address.

-- 
Catalin
