Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab1DLVIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 17:08:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155Ab1DLVIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:08:41 -0400
Date: Wed, 13 Apr 2011 07:08:27 +1000
From: NeilBrown <neilb@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, "hch@infradead.org" <hch@infradead.org>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110413070827.11b2a71d@notabene.brown>
In-Reply-To: <20110412143452.GH31057@dastard>
References: <20110411223623.4278fad1@notabene.brown>
	<4DA2F8AD.1060605@fusionio.com>
	<20110412011255.GA29236@infradead.org>
	<4DA40F0E.1070903@fusionio.com>
	<20110412122248.GC31057@dastard>
	<4DA4456F.3070301@fusionio.com>
	<20110412124134.GD31057@dastard>
	<4DA44C86.3090305@fusionio.com>
	<20110412133117.GE31057@dastard>
	<4DA45790.2010109@fusionio.com>
	<20110412143452.GH31057@dastard>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 00:34:52 +1000 Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Apr 12, 2011 at 03:45:52PM +0200, Jens Axboe wrote:
> Not until you
> > schedule() or call blk_finish_plug(), both of which are events that you
> > can control.
> 
> Well, not really - now taking any sleeping lock or waiting on
> anything can trigger a plug flush where previously you had to
> explicitly issue them. I'm not saying what we had is better, just
> that there are implicit flushes with your changes that are
> inherently uncontrollable...

It's not just sleeping locks - if preempt is enabled a schedule can happen at
any time - at any depth.  I've seen a spin_unlock do it.

NeilBrown
