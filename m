Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1IVSNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 14:13:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33503 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753013Ab1IVSNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 14:13:16 -0400
Date: Thu, 22 Sep 2011 19:13:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@nvidia.com>, Ben Dooks <ben-linux@fluff.org>,
        Arnd Bergmann <arnd@arndb.de>, Colin Cross <ccross@google.com>,
        Olof Johansson <olof@lixom.net>, Erik Gilling <konkers@android.com>,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dilan Lee <dilee@nvidia.com>
Subject: Re: [PATCH v2] i2c-tegra: Use the suspend_noirq/resume_noirq not
 suspend/resume
Message-ID: <20110922181313.GG5173@opensource.wolfsonmicro.com>
References: <1316713892-357-1-git-send-email-swarren@nvidia.com>
 <20110922180335.GQ17168@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110922180335.GQ17168@ponder.secretlab.ca>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 12:03:35PM -0600, Grant Likely wrote:
> On Thu, Sep 22, 2011 at 11:51:32AM -0600, Stephen Warren wrote:

> > * Implement an explicit dependency management system within the kernel for
> >   device suspend/resume, such that I2C bus would not be suspended before
> >   the sound card that requires it. It is reported that Linus rejected this
> >   proposal since he wanted suspend ordering to be based on probe ordering.

> This really should be revisted.  That was in the context of full
> system suspend, but we're now in a world of runtime suspend which
> absolutely does need dependency tracking or reference counting to get
> the ordering right.

FWIW this was one of the bigger issues in the PM miniconference in Santa
Rosa, though a lot of the discission involved explaining the issues to
some of the x86 guys and there wasn't mssive progress on solutions.

> > * Enhance device probing such that the ASoC sound card device could defer
> >   its probing until all required resources were available. This would
> >   then cause the overall sound card suspend to occur at an appropriate early
> >   time. Grant Likely was reported to have been working towards this goal.

> Yes, I'll send you my current patch for you to look at.  One of the
> engineers from Linaro is going to be pushing that patch set forward.
> However, I don't know if it helps with this problem because I believe
> that the suspend order is based on the implicit probe order of
> devices, but my patch allows drivers to cause the probe order to get
> rearranged at runtime.  I don't believe there is a global list showing
> the order that devices successfully got probed, but I may be wrong
> here.

Yes, I'm not convinced it'll change anything here.  Though I guess it
should be a simple matter of programming to move devices around the list
depending on when they probe.
