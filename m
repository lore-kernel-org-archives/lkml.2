Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315Ab1HEE3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 00:29:54 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51407 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014Ab1HEE3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 00:29:53 -0400
X-Sasl-enc: g5jUUeF1/dwiNUb9TEdW+4xzzmuiMf4N6Dx6R6kRq5/e 1312518592
Date: Thu, 4 Aug 2011 21:27:30 -0700
From: Greg KH <greg@kroah.com>
To: Wouter Verhelst <w@uter.be>
Cc: paul.clements@steeleye.com, linux-kernel@vger.kernel.org
Subject: Re: [Nbd] [PATCH v2] nbd: nbd sysfs framework
Message-ID: <20110805042730.GA25389@kroah.com>
References: <4e3b190f.NjLPBhXLsVSgFxi+%paul.clements@steeleye.com>
 <20110805014752.GJ4109@grep.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805014752.GJ4109@grep.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 03:47:52AM +0200, Wouter Verhelst wrote:
> On Thu, Aug 04, 2011 at 06:11:27PM -0400, paul.clements@steeleye.com wrote:
> > diff --git a/Documentation/ABI/testing/sysfs-block-nbd b/Documentation/ABI/testing/sysfs-block-nbd
> > new file mode 100644
> > index 0000000..3728d9f
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-block-nbd
> > @@ -0,0 +1,8 @@
> > +What:		/sys/block/nbd<id>/nbd/pid
> > +Date:		August 2011
> > +Contact:	Paul Clements <paul.clements@steeleye.com>
> > +Description:
> > +		The pid file is read-only and specifies the pid of the
> > +		caller of NBD_DO_IT ioctl (normally this is the nbd-client).
> > +		The pid will be zero if the nbd connection is not
> > +		currently established.
> 
> That's different from current behaviour: in the current implementation,
> the absense of a connection is signalled by the absense of the PID file,
> rather than the contents being zero. Dunno whether that change is
> intentional, but I thought I'd check before changing nbd-client code...

The current behavior should not change, so that would be a bug and yet
another reason to reject this patch :)
