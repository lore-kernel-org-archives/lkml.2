Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab1DVSGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 14:06:23 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49463 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756476Ab1DVSGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 14:06:22 -0400
Subject: Re: Strange block/scsi/workqueue issue
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Steven Whitehouse <swhiteho@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110422180158.GB21902@mtj.dyndns.org>
References: <1302638216.2604.35.camel@mulgrave.site>
	 <1302640226.2661.34.camel@dolmen> <1302641036.2604.40.camel@mulgrave.site>
	 <20110413051846.GD24161@mtj.dyndns.org>
	 <20110413060651.GA27823@mtj.dyndns.org> <1302686454.2613.4.camel@dolmen>
	 <1302703208.2613.18.camel@dolmen> <1302714080.2597.29.camel@mulgrave.site>
	 <4DA603AF.9090202@fusionio.com> <1302725866.2597.33.camel@mulgrave.site>
	 <20110422180158.GB21902@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 13:06:18 -0500
Message-ID: <1303495578.2590.33.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 20:01 +0200, Tejun Heo wrote:
> Hello, guys.
> 
> On Wed, Apr 13, 2011 at 03:17:46PM -0500, James Bottomley wrote:
> > On Wed, 2011-04-13 at 22:12 +0200, Jens Axboe wrote:
> > > This patch looks pretty clean. Shouldn't you serialize that ->queuedata
> > > = NULL assignment with the queue lock, though?
> > 
> > pointer assignment is atomic, isn't it?  As in on a 32 bit arch, it
> > definitely is, and I thought on 64 bits it also was.  So a simultaneous
> > reader either sees previous value or NULL.
> 
> What was the conclusion of this thread?  James' fix seems minimal and
> good for this cycle but I don't see it there yet.  Jens, James?

Sorry, forgot to cc you.

I've proposed the minimal fixes for this cycle here:

http://marc.info/?l=linux-scsi&m=130348665328233
http://marc.info/?l=linux-scsi&m=130348673628282
http://marc.info/?l=linux-scsi&m=130348680328356

And I'll merge at least the scsi one.

But there's been no long term conclusion yet.

James


