Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab0KIIDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 03:03:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43671 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab0KIIDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 03:03:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: fadvise DONTNEED implementation (or lack thereof)
Cc: kosaki.motohiro@jp.fujitsu.com, Ben Gamari <bgamari.foss@gmail.com>,
        linux-kernel@vger.kernel.org, rsync@lists.samba.org,
        linux-mm@kvack.org
In-Reply-To: <20101109162525.BC87.A69D9226@jp.fujitsu.com>
References: <87lj597hp9.fsf@gmail.com> <20101109162525.BC87.A69D9226@jp.fujitsu.com>
Message-Id: <20101109170303.BC90.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Nov 2010 17:03:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I've recently been trying to track down the root cause of my server's
> > persistent issue of thrashing horribly after being left inactive. It
> > seems that the issue is likely my nightly backup schedule (using rsync)
> > which traverses my entire 50GB home directory. I was surprised to find
> > that rsync does not use fadvise to notify the kernel of its use-once
> > data usage pattern.
> > 
> > It looks like a patch[1] was written (although never merged, it seems)
> > incorporating fadvise support, but I found its implementation rather
> > odd, using mincore() and FADV_DONTNEED to kick out only regions brought
> > in by rsync. It seemed to me the simpler and more appropriate solution
> > would be to simply flag every touched file with FADV_NOREUSE and let the
> > kernel manage automatically expelling used pages.
> > 
> > After looking deeper into the kernel implementation[2] of fadvise() the
> > reason for using DONTNEED became more apparant. It seems that the kernel
> > implements NOREUSE as a noop. A little googling revealed[3] that I not
> > the first person to encounter this limitation. It looks like a few
> > folks[4] have discussed addressing the issue in the past, but nothing
> > has happened as of 2.6.36. Are there plans to implement this
> > functionality in the near future? It seems like the utility of fadvise
> > is severely limited by lacking support for NOREUSE.
> 
> btw, Other OSs seems to also don't implement it.
> example,

I've heared other OSs status of fadvise() from private mail.

NetBSD: no-op (as linux)
FreeBSD/DragonflyBSD/OpenBSD: don't exist posix_fadvise(2)



