Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab2GXJOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 05:14:54 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3584 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab2GXJOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 05:14:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Jul 2012 02:09:39 -0700
Date: Tue, 24 Jul 2012 12:13:58 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>
Subject: Re: [PATCH 5/5] i2c: tegra: convert normal suspend/resume to
 *_noirq
Message-ID: <20120724091358.GK12034@tbergstrom-lnx.Nvidia.com>
References: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com>
 <1341919244-23327-6-git-send-email-ldewangan@nvidia.com>
 <500D96E6.4060507@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <500D96E6.4060507@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 08:24:38PM +0200, Stephen Warren wrote:
> On 07/10/2012 05:20 AM, Laxman Dewangan wrote:
> > To provide the late suspend and early resume for i2c
> > driver, convert the suspend/resume as
> > 	suspend-> suspend_noirq
> > 	resume -> resume_noirq
> > 
> > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> 
> Why do we need this change?
> 
> IIRC, I proposed it before solely to solve some suspend/resume ordering
> issues, and Colin Cross NAKd it. These days, deferred probe should make
> this change unnecessary.
> 

How does deferred probe solve this? Iirc the problem is that i2c is needed to
talk to the PMIC, so we need to make sure i2c is shutdown last because drivers
might want to do regulator control in the suspend function.

Cheers,

Peter.
