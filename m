Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab1FXWsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 18:48:50 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:25900 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab1FXWss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 18:48:48 -0400
Subject: Re: [PATCH] sparse: Fix BUILD_BUG_ON_{ZERO,NULL} definitions
From: Ben Hutchings <bhutchings@solarflare.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <20110624152853.6fd65f41.rdunlap@xenotime.net>
References: <1308951912.3034.23.camel@bwh-desktop>
	 <20110624152853.6fd65f41.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Fri, 24 Jun 2011 23:48:44 +0100
Message-ID: <1308955724.3034.28.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2011 22:48:47.0845 (UTC) FILETIME=[E117E150:01CC32C0]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18218.005
X-TM-AS-Result: No--27.864100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-24 at 15:28 -0700, Randy Dunlap wrote:
> On Fri, 24 Jun 2011 22:45:12 +0100 Ben Hutchings wrote:
> 
> > Commit 903c0c7cdc21f2ccb7562a7bbc70289c0c2b16ad ('sparse: define dummy
> > BUILD_BUG_ON definition for sparse') left these two broken.  The ZERO
> > or NULL suffix specifies what the macro should expand to, not the
> > value that would indicate a bug.
> > 
> > Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
> > ---
> > sparse currently reports a syntax error and no useful warnings for any
> > source file which uses one of these macros.  Since module_param() uses
> > BUILD_BUG_ON_ZERO(), that's a lot of source files.
> > 
> > Ben.
> 
> This patch from 2011-MAY-30 also fixes these warnings, but the typecasting
> in yours is probably better.  :)
>
> http://marc.info/?l=linux-kernel&m=130677145629121&w=2
> 
> Wait, 3.0-rc4 already has the above patch.  Is yours still needed?
[...]

Sorry, my baseline was a little out of date.

I'm not sure whether the type of BUILD_BUG_ON_ZERO() should be size_t;
that's just what the non-sparse definition works out as.  In some cases
it could make a difference whether it's signed or not.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

