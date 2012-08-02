Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab2HBSAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 14:00:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33686 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754969Ab2HBSAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 14:00:54 -0400
Date: Thu, 2 Aug 2012 19:00:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: Add intermediate cast to uintptr_t
 before casting to pointer
Message-ID: <20120802180051.GI4537@opensource.wolfsonmicro.com>
References: <1343605633.11323.1.camel@phoenix>
 <20120730153309.GK4468@opensource.wolfsonmicro.com>
 <1343701316.7557.1.camel@phoenix>
 <20120731154153.GI4468@opensource.wolfsonmicro.com>
 <1343750888.5463.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1343750888.5463.5.camel@phoenix>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 12:08:08AM +0800, Axel Lin wrote:
> 於 二，2012-07-31 於 16:41 +0100，Mark Brown 提到：

> > So the above cast probably isn't right...  you shouldn't need a double
> > cast here.

> The issue of original warning is: ( I compile the kernel on x86_64 )
>         warning: cast to pointer from integer of different size

> What this patch does is:
> cast best_val to uintptr_t, which is an unsigned integer large enough to
> hold a void* pointer.

> And then cast it to (void *).

> Thus I did (void *)(uintptr_t)best_val.

Perhaps we need a temporary variable here.  The double cast just looks
too horrible.
