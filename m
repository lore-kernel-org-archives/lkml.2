Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab2DBRVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:21:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54990 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab2DBRVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:21:48 -0400
Date: Mon, 2 Apr 2012 18:21:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] clkdev: Implement managed clk_get()
Message-ID: <20120402172133.GH24211@n2100.arm.linux.org.uk>
References: <1333279960-8497-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1333279960-8497-2-git-send-email-broonie@opensource.wolfsonmicro.com> <4F787392.5040308@codeaurora.org> <20120401153450.GC8971@opensource.wolfsonmicro.com> <4F79D85F.4020909@codeaurora.org> <20120402165242.GC24211@n2100.arm.linux.org.uk> <4F79DC03.7020503@codeaurora.org> <20120402170858.GG24211@n2100.arm.linux.org.uk> <4F79DED3.4070007@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F79DED3.4070007@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 10:16:03AM -0700, Stephen Boyd wrote:
> On 04/02/12 10:08, Russell King - ARM Linux wrote:
> > Utter crap.  Deleting them makes the non-common clock implementations
> > unsafe.  If a struct clk is provided by a module (and we do have some
> > which are) then the module reference count has to be held.  That's
> > what these hooks do.
> >
> > When these platforms get converted over to the common clock, and the
> > issues surrounding dynamically registered and removed clocks are sane,
> > these hooks have to be used by the common clock to deal with the
> > refcounting so that common code knows when the structures can be freed.
> 
> I'm saying that when every platform is using the common clock code we
> would only have one __clk_get() implementation and we should be able to
> delete clkdev.h entirely.

No you did not, you said quite clearly that clkdev should go away and
be replaced by something else, because you see clkdev as just another
"platform specific implementation" (your words).  You were definitely
not talking about _just_ the backends for clkdev's clk_get().
