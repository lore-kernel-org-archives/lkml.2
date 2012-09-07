Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab2IGNTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:19:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34477 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752162Ab2IGNT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:19:27 -0400
Date: Fri, 7 Sep 2012 21:19:20 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "lrg@ti.com" <lrg@ti.com>,
        "rabin.vincent@gmail.com" <rabin.vincent@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] regulator: disable supply regulator if it is enabled
 for boot-on
Message-ID: <20120907131918.GC4438@opensource.wolfsonmicro.com>
References: <1346682339-13322-1-git-send-email-ldewangan@nvidia.com>
 <20120907015900.GC6827@opensource.wolfsonmicro.com>
 <5049EDCD.4050805@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5049EDCD.4050805@nvidia.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 06:21:25PM +0530, Laxman Dewangan wrote:
> On Friday 07 September 2012 07:29 AM, Mark Brown wrote:

> >  I think what we need to
> >do here is always take a reference to the supply if the child is enabled
> >during boot, then in the initcall we can just disable the parent
> >regulator as normal.

> My second patch was similar but Rabin has some issue to handle the
> case when is_regulator_enable() is not implementd by regulator
> device driver.

So let's fix that...  if it's causing an issue in this case it's likely
to affect other areas too, coding in custom hacks in different bits of
the code isn't going to help maintainability.  What was the issue?
