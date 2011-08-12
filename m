Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab1HLASX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 20:18:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56964 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754523Ab1HLASV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 20:18:21 -0400
Subject: RE: [PATCH] i2c/tegra: I2C driver uses the
 suspend_noirq/resume_noirq
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Colin Cross <ccross@google.com>, Ben Dooks <ben-linux@fluff.org>,
        Dilan Lee <dilee@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04AEA24D09@HQMAIL01.nvidia.com>
References: <1312586102-27907-1-git-send-email-swarren@nvidia.com>
	 <CAMbhsRScgMaTZ2e3a__OgOrrA6HN9_dkGuuNGaEfP+iqRdjyNQ@mail.gmail.com>
	 <20110806084805.GA18098@sirena.org.uk>
	 <74CDBE0F657A3D45AFBB94109FB122FF04AEA24CC8@HQMAIL01.nvidia.com>
	 <CAMbhsRR2+bhpjhGfUSt9M5tDk1EW2d70yC-tZy27zEgVqtkfSg@mail.gmail.com>
	 <74CDBE0F657A3D45AFBB94109FB122FF04AEA24D09@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Wolfson Microelectronics
Date: Fri, 12 Aug 2011 09:18:16 +0900
Message-ID: <1313108296.19990.10.camel@finisterre.wolfsonmicro.main>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 14:09 -0700, Stephen Warren wrote:
> Colin Cross wrote at Thursday, August 11, 2011 2:51 PM:

> Mark Brown wrote:
> > Unfortunately it's the only tool Linux has for dealing with this sort of
> > issue right now.  We were supposed to be getting support for telling the
> > PM core about dependencies but Linus didn't like that,

> Mark, can you fill in a little more detail; did Linus not like the concept
> of drivers registering dependencies on each-other, or was there a problem
> with the specific implementation that was proposed? I assume we're still a

He didn't like either, I think - he felt that probe ordering should be
sufficient. Which is true within the device model, in that devices can't
probe until all their resources are ready. This is coming up for ASoC
because that mechanism just doesn't work at all for us an we have to
work around it.

> long way away from anything like that working. You also mentioned Grant's
> device registration retry stuff, but doesn't that only solve the initial
> probing, not shutdown/suspend dependencies, or do devices take locks on
> each-other to handle that too?

Our current mechanism is based entirely on the order in which things get
instantiated so depending on the implementation of deferred binding we
may be able to change the ordering of the dpm_list.

