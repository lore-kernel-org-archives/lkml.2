Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab2DNSJs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 14:09:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36365 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab2DNSJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 14:09:24 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 14 Apr 2012 20:08:55 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, Adrian Chadd <adrian@freebsd.org>,
        Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120414200855.7be0b212@stein>
In-Reply-To: <CAMP44s2jLv=VPgjiocmzzyUqzUYp4b7nFEU_XV6nT=n+OZ3RNw@mail.gmail.com>
References: <20120412011313.GA23764@kroah.com>
	<CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
	<20120412144626.GA14868@kroah.com>
	<CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
	<CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com>
	<CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
	<20120413105746.10ffb120@stein>
	<CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com>
	<20120413154216.476a02ac@stein>
	<CAMP44s10KVwL5pY=Q5hWfyUtU6CvvZZ4Bcg-fEY9dAhSL306aQ@mail.gmail.com>
	<20120413230525.GA13995@burratino>
	<CAMP44s0OdVBTwVtCoru-xvB=LVtO56jgku7X-0a7mUz1=iVCzw@mail.gmail.com>
	<20120414111044.4930a5f3@stein>
	<CAMP44s2jLv=VPgjiocmzzyUqzUYp4b7nFEU_XV6nT=n+OZ3RNw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 14 Felipe Contreras wrote:
> On Sat, Apr 14, 2012 at 12:10 PM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
> > On Apr 14 Felipe Contreras wrote:
> 
> >> Of course, although the difference with the stable kernel would be
> >> very small if the only thing added is an extra rule for acceptance:
> >> "It reverts an earlier patch to 'stable'."
> >
> > It looks like a small difference on the surface, but it isn't.  It would
> > mean "yes, we /do/ forward ports in -stable too in some cases".
> 
> How? There's a lot reverts in mainline, where do they come from? Are
> they forward ports from some ghost trees?

Indeed, reverts that go into mainline can often be called forward-ports:
A subsystem developer applied the revert to his subsystem tree, Linus
merges that tree, and the merge result is technically a forward-port
(except if the pull resulted in a fast-forward instead of a merge).

However, "fix it in stable before mainline" requires to allow forward-ports
in stable for a different reason:  If the fix in mainline gets delayed
until after stable's next branch point, the stable fix needs to be
forward-ported from 3.M.y to 3.N.y.

> If you drop a patch from the stable review queue before it gets into a
> stable release, and then that patch is reverted from mainline, is that
> also a "forward port"?

There is just one fix of one bug, not a fix plus a port of the fix to a
similarly buggy tree.
-- 
Stefan Richter
-=====-===-- -=-- -===-
http://arcgraph.de/sr/
