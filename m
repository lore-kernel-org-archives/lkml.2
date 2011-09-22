Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1IVUTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 16:19:19 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37250 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753841Ab1IVUTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 16:19:16 -0400
X-Sasl-enc: XyViYWrJLEPkIT64KpWTk1itRXrgDfHtvkBT9rUD2vBC 1316722756
Date: Thu, 22 Sep 2011 13:19:09 -0700
From: Greg KH <greg@kroah.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20110922201909.GA13347@kroah.com>
References: <20110922131232.56210b544f587210621ae339@canb.auug.org.au>
 <4E7B2E43.3080609@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7B2E43.3080609@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 09:46:59AM -0300, Mauro Carvalho Chehab wrote:
> Em 22-09-2011 00:12, Stephen Rothwell escreveu:
> > Hi Mauro,
> > 
> > After merging the v4l-dvb tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> > 
> > drivers/staging/dt3155v4l/dt3155v4l.c: In function 'dt3155_start_acq':
> > drivers/staging/dt3155v4l/dt3155v4l.c:210:2: error: implicit declaration of function 'vb2_dma_contig_plane_paddr'
> > drivers/staging/dt3155v4l/dt3155v4l.c: At top level:
> > drivers/staging/dt3155v4l/dt3155v4l.c:321:2: warning: initialization from incompatible pointer type
> > drivers/staging/dt3155v4l/dt3155v4l.c:325:2: warning: initialization from incompatible pointer type
> > 
> > Casued by commit ba7fcb0c9549 ("[media] media: vb2: dma contig allocator:
> > use dma_addr instread of paddr").
> > 
> > I have used the v4l-dvb tree from next-20110921 for today.
> 
> Hi Stephen,
> 
> I think that the right thing to do is to disable the building of this
> staging driver, if it is not using the current media core API's.
> 
> Greg,
> 
> If possible, I prefer to merge those staging drivers for the media
> subsystem via my tree, as it helps me to solve in advance conflicts
> like that. Maybe we could add a drivers/staging/media tree or
> drivers/media/staging, and move those beasts to there.
> 
> What do you think?

Yes, I would _LOVE_ a drivers/staging/media/ directory so that I know
which drivers I am supposed to be ignoring and leaving to you :)

Just let me know which ones I should move into there and I will do that
today and let you maintain them all and just forward any emails to you.
Which will keep issues like this from happening in the future.

thanks,

greg k-h
