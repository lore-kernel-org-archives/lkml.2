Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab2JSJ1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:27:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45750 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810Ab2JSJ1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:27:23 -0400
Date: Fri, 19 Oct 2012 10:27:14 +0100
From: Will Deacon <will.deacon@arm.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RESEND PATCH 4/4] net: smc91x: use io{read,write}*_rep
 accessors instead of string functions
Message-ID: <20121019092714.GC4582@mudshark.cambridge.arm.com>
References: <1350488704-3711-1-git-send-email-will.deacon@arm.com>
 <1350488704-3711-5-git-send-email-will.deacon@arm.com>
 <50810E8C.5010806@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50810E8C.5010806@imgtec.com>
Thread-Topic: [RESEND PATCH 4/4] net: smc91x: use io{read,write}*_rep
 accessors instead of string functions
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 09:25:48AM +0100, James Hogan wrote:
> On 17/10/12 16:45, Will Deacon wrote:
> > The {read,write}s{b,w,l} operations are not defined by all architectures
> > and are being removed from the asm-generic/io.h interface.
> > 
> > This patch replaces the usage of these string functions in the default
> > SMC accessors with io{read,write}{8,16,32}_rep calls instead, which are
> > defined for all architectures.
> 
> Hi,
> 
> Should this patch (and the mmc one) precede patch 1?

Yup, I can reorder that easily enough.

> Also there appear to be some other places that it's used (e.g.
> smsc911x.c and smc911x.h). I guess these should be fixed up first too?

I could have a look if you like, but I'm wary of changing the I/O accessors
in anything but a mechanical fashion given that I can't test any of my
changes.

Will
