Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1FAMzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 08:55:33 -0400
Received: from defer-dn03.ocn.ad.jp ([125.170.100.156]:34193 "EHLO
	defer-dn03.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab1FAMzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 08:55:31 -0400
X-Greylist: delayed 1168 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jun 2011 08:55:30 EDT
Date: Wed, 01 Jun 2011 21:34:24 +0900 (JST)
Message-Id: <20110601.213424.80025869.anemo@mba.ocn.ne.jp>
To: James.Bottomley@HansenPartnership.com, Jens Axboe <axboe@kernel.dk>
Cc: greg@kroah.com, mjt@tls.msk.ru, jslaby@suse.cz, stable@kernel.org,
        jejb@parisc-linux.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] apparent regression (crash) - 2.6.38.6
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1305776367.2576.0.camel@mulgrave.site>
References: <20110511193451.GC26010@kroah.com>
	<20110519002505.GB8697@kroah.com>
	<1305776367.2576.0.camel@mulgrave.site>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011 07:39:27 +0400, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Wed, 2011-05-18 at 17:25 -0700, Greg KH wrote:
> > On Wed, May 11, 2011 at 12:34:51PM -0700, Greg KH wrote:
> > > On Wed, May 11, 2011 at 02:19:17PM -0500, James Bottomley wrote:
> > > > > > [  106.994628] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
> > > > > > [  106.994755] IP: [<ffffffff811bec1b>] elv_queue_empty+0x1b/0x30
> > > > 
> > > > Hmm, it's another missing elevator guard, like this patch:
> > > > 
> > > > http://marc.info/?l=linux-scsi&m=130348673628282
> > > > 
> > > > I think the bug here is that q->elevator is null, so dereferencing
> > > > elevator->ops gives the bug.
> > > 
> > > Is this patch going to Linus anytime soon?
> > 
> > Ping?
> 
> I pinged Jens about it yesterday; he said it should be on its way to
> Linus.

The patch in above URL ("block: add proper state guards to
__elv_next_request") is in mainline and stable-queues now, but how
about a similar fix for elv_queue_empty()?

The elv_queue_empty() is removed in mainline, but it seems
stable-2.6.38.x and prior stable-branches still need the fix for
elv_queue_empty().

---
Atsushi Nemoto
