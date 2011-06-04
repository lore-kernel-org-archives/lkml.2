Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab1FDLkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 07:40:13 -0400
Received: from defer-dn04.ocn.ad.jp ([125.170.100.158]:49874 "EHLO
	defer-dn04.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab1FDLkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 07:40:07 -0400
Date: Sat, 04 Jun 2011 20:38:28 +0900 (JST)
Message-Id: <20110604.203828.193685667.anemo@mba.ocn.ne.jp>
To: mjt@tls.msk.ru
Cc: James.Bottomley@HansenPartnership.com, axboe@kernel.dk, greg@kroah.com,
        jslaby@suse.cz, stable@kernel.org, jejb@parisc-linux.org,
        linux-kernel@vger.kernel.org, wolfgang.walter@stwm.de
Subject: Re: [stable] apparent regression (crash) - 2.6.38.6
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <4DE886D1.8090807@msgid.tls.msk.ru>
References: <1305776367.2576.0.camel@mulgrave.site>
	<20110601.213424.80025869.anemo@mba.ocn.ne.jp>
	<4DE886D1.8090807@msgid.tls.msk.ru>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Jun 2011 11:01:37 +0400, Michael Tokarev <mjt@tls.msk.ru> wrote:
> Something like this?  (run-tested but I haven't seen the problem
> in this place)
> 
> commit 2e8532e0a9ee1d25b279ac78ee8ce31701e2aa15
> Author: Michael Tokarev <mjt@tls.msk.ru>
> Date:   Fri Jun 3 10:50:49 2011 +0400
> 
>     block: add proper state guards to elv_queue_empty()

Yes, that's exactly what I mean.

>     Like in 0a58e077eb600d1efd7e54ad9926a75a39d7f8ae (backported to
>     stable 2.6.38 as 0a58e077eb600d1efd7e54ad9926a75a39d7f8ae) which
>     fixes this for __elv_next_request(), as reported by Atsushi Nemoto,
>     elv_queue_empty() also needs to check for dead queue condition
>     before touchin elevator.
> 
>     elv_queue_empty() has been removed upstream so this is only applicable
>     for versions prior to 2.6.39, including 2.6.32-longterm.

Yes, Wolfgang Walter reported same crash on 2.6.32.40 so
2.6.32-longterm would need this fix.

I suppose all stable branches which have backport of 86cbfb56 ("put
stricter guards on queue dead checks") need this fix.

---
Atsushi Nemoto
