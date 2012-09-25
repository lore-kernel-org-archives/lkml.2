Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab2IYKie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:38:34 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39488 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754766Ab2IYKic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:38:32 -0400
Message-ID: <1348569508.2457.28.camel@dabdike>
Subject: Re: [SCSI PATCH] sd: max-retries becomes configurable
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 25 Sep 2012 14:38:28 +0400
In-Reply-To: <50613F72.4000302@pobox.com>
References: <20120924210049.GA18527@havoc.gtf.org>
	 <1348546019.2457.3.camel@dabdike> <50613F72.4000302@pobox.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 01:21 -0400, Jeff Garzik wrote:
> On 09/25/2012 12:06 AM, James Bottomley wrote:
> > On Mon, 2012-09-24 at 17:00 -0400, Jeff Garzik wrote:
> >>
> >>   drivers/scsi/sd.c |    4 ++++
> >>   drivers/scsi/sd.h |    2 +-
> >>   2 files changed, 5 insertions(+), 1 deletion(-)
> >
> > I'm not opposed in principle to doing this (except that it should be a
> > sysfs parameter like all our other controls), but what's the reasoning
> > behind needing it changed?
> 
> <vendor hat on>
> 
> Periodically turns up as a useful field sledgehammer for solving 
> problems, until the real problem is found and fixed.  Got tired of a 
> very similar patch manually bouncing around the "hey, pssst, this worked 
> for me" backchannel IT network.
> 
> </red hat>

I'm asking because the general consensus from the device guys is that we
should never retry unless the device or the transport tells us to (and
then we shouldn't count the retries).  A long time ago we used to get
spurious command failures from retry exhaustion on QUEUE_FULL or BUSY,
but since we switched those to being purely timeout based, I thought the
problem had gone away and I'm curious to know what guise it resurfaced
in.

> Can you be more specific about sysfs location?  A runtime-writable (via 
> sysfs!) module parameter for a module-wide default seemed appropriate.

Well, if it's really important, the same thing should happen with
retries as happened with timeout (it became a request_queue property),
but it could be hacked as a struct scsi_disk one with a corresponding
entry in sd_dis_attrs.

James


