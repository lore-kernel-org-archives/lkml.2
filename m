Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab2E1Msh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 08:48:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40118 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab2E1Msg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 08:48:36 -0400
Date: Mon, 28 May 2012 13:48:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH 12/13] backlight: tosa_bl: use devm_ functions
Message-ID: <20120528124831.GA18592@sirena.org.uk>
References: <001701cd3a1e$69c59a00$3d50ce00$%han@samsung.com>
 <CALT56yMro+2KPHPNdT4F+DdAjiK2e3QRUrx3CV8dVaoLhXa1Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALT56yMro+2KPHPNdT4F+DdAjiK2e3QRUrx3CV8dVaoLhXa1Rw@mail.gmail.com>
X-Cookie: Please go away.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 10:43:07AM +0400, Dmitry Eremin-Solenikov wrote:
> On Fri, May 25, 2012 at 6:30 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> > The devm_ functions allocate memory that is released when a driver
> > detaches. This patch uses devm_kzalloc of these functions.

> Strictly speaking I see no point in this changes. There are no
> 'missing free' problems
> in these drivers, the code path is clean enough. Is devm_kzalloc usage some kind
> of policy, or it is just a future-proof change?

It does provide robustness against future changes and it's also the more
current style; if nothing else it helps anyone who wants to go and audit
for leaks.
