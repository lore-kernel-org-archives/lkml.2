Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab0IAVqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 17:46:49 -0400
Received: from void.printf.net ([89.145.121.20]:50195 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab0IAVqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 17:46:47 -0400
Date: Wed, 1 Sep 2010 22:46:44 +0100
From: Chris Ball <cjb@laptop.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCH 0/3] mmc_test: show test results via sysfs
Message-ID: <20100901214644.GA4436@void.printf.net>
References: <cover.1283276161.git.ext-andriy.shevchenko@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1283276161.git.ext-andriy.shevchenko@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Wed, Sep 01, 2010 at 09:26:44AM +0300, Andy Shevchenko wrote:
> There is a patchset which brings possibility to get test results via sysfs. It
> helps to do tests non-interactively.

Thanks for the patchset.  It doesn't apply to 2.6.36-rc3 without some
(trivial) merge conflicts -- could you rebase with your next version?

Tested-by: Chris Ball <cjb@laptop.org>

Unrelated to this patch, I'm hitting:

  drivers/mmc/core/core.c:174:
    BUG_ON(mrq->data->blocks * mrq->data->blksz > host->max_req_size);

when running the transfer tests under 2.6.36-rc3.  The request that
fires the BUG() has blocks=8192 * blksz=512 > max_req_size=524288,
on a Ricoh Co Ltd R5C822/1180:0822 in a Dell M6300 laptop.  Anyone
have any experience with that bug, before I dig deeper?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
