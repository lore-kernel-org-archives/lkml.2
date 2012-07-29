Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab2G2VEO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 17:04:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55908 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753589Ab2G2VEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 17:04:13 -0400
Date: Sun, 29 Jul 2012 22:04:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 2/3] regmap: implement irq chip suspend/resume operations
Message-ID: <20120729210410.GM4384@opensource.wolfsonmicro.com>
References: <1343415716-27134-1-git-send-email-swarren@wwwdotorg.org>
 <1343415716-27134-2-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343415716-27134-2-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 01:01:55PM -0600, Stephen Warren wrote:

> When suspending, we set up the wake mask registers as required. Some
> chips don't have separate wake mask registers, so they set mask_base
> equal to wake_base. In that case, when resuming, we re-program the

No, they shouldn't be doing that at all - that's at best confused.  The
two registers do different things and if the two ranges are set the same
then I'd not expect things to work.  Supporting that would make the code
more complex and I'm not sure what benefit we might gain from it.
