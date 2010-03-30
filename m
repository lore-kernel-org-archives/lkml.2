Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab0C3Gni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:43:38 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:56692 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755585Ab0C3Gnh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:43:37 -0400
Subject: Re: [git pull] drm fixes
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
In-Reply-To: <alpine.DEB.2.00.1003300530150.5127@skynet.skynet.ie>
References: <alpine.DEB.2.00.1003300530150.5127@skynet.skynet.ie>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 30 Mar 2010 08:43:31 +0200
Message-ID: <1269931411.5480.152.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.92.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 05:34 +0100, Dave Airlie wrote: 
> 
> Original pull req below + reverts the fallback placement change which had 
> a side effect of causing more lockups on some AGP systems (this is a bug in 
> the AGP drivers that needs to be tracked down), [...]

While I was able to work around the lockups by making the AGP driver
never unbind a GTT entry, I think it's rather a radeon issue - how is
the AGP driver supposed to know when it's safe to unbind an entry?

That change had lots of other issues anyway, thanks for reverting it.


> [...] and I've merged Jerome's GPU recovery code, as I'd much rather
> users had some of hope of recovering from their GPU locking up than a
> dead box. It seems to work for quite a lot of people that have tested
> it, and it won't make a GPU lockup problem worse.

Unfortunately, that's not true in all cases. The change itself mentions
that the new reset code is unreliable for R3xx generation GPUs, and
indeed with my RV350 it now turns my box into a brick immediately on a
GPU lockup most of the time whereas previously it was usually able to
recover at least in some cases, e.g. falling back to PCI mode after
trying to use a non-working AGP transfer mode.


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
