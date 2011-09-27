Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab1I0AxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 20:53:04 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:39100 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765Ab1I0AxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 20:53:02 -0400
X-Sasl-enc: ks09a4hJ98D+dTYclsag6dq07llB2Ngpi/Va8NxraGw6 1317084781
Date: Mon, 26 Sep 2011 17:49:12 -0700
From: Greg KH <greg@kroah.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20110927004912.GB10408@kroah.com>
References: <20110922131232.56210b544f587210621ae339@canb.auug.org.au>
 <4E7B2E43.3080609@infradead.org>
 <20110922201909.GA13347@kroah.com>
 <4E7C9736.30707@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7C9736.30707@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 11:27:02AM -0300, Mauro Carvalho Chehab wrote:
> Em 22-09-2011 17:19, Greg KH escreveu:
> > On Thu, Sep 22, 2011 at 09:46:59AM -0300, Mauro Carvalho Chehab wrote:
> >> Em 22-09-2011 00:12, Stephen Rothwell escreveu:
> >>> Hi Mauro,
> >>>
> >>> After merging the v4l-dvb tree, today's linux-next build (x86_64
> >>> allmodconfig) failed like this:
> >>>
> >>> drivers/staging/dt3155v4l/dt3155v4l.c: In function 'dt3155_start_acq':
> >>> drivers/staging/dt3155v4l/dt3155v4l.c:210:2: error: implicit declaration of function 'vb2_dma_contig_plane_paddr'
> >>> drivers/staging/dt3155v4l/dt3155v4l.c: At top level:
> >>> drivers/staging/dt3155v4l/dt3155v4l.c:321:2: warning: initialization from incompatible pointer type
> >>> drivers/staging/dt3155v4l/dt3155v4l.c:325:2: warning: initialization from incompatible pointer type
> >>>
> >>> Casued by commit ba7fcb0c9549 ("[media] media: vb2: dma contig allocator:
> >>> use dma_addr instread of paddr").
> >>>
> >>> I have used the v4l-dvb tree from next-20110921 for today.
> >>
> >> Hi Stephen,
> >>
> >> I think that the right thing to do is to disable the building of this
> >> staging driver, if it is not using the current media core API's.
> >>
> >> Greg,
> >>
> >> If possible, I prefer to merge those staging drivers for the media
> >> subsystem via my tree, as it helps me to solve in advance conflicts
> >> like that. Maybe we could add a drivers/staging/media tree or
> >> drivers/media/staging, and move those beasts to there.
> >>
> >> What do you think?
> > 
> > Yes, I would _LOVE_ a drivers/staging/media/ directory so that I know
> > which drivers I am supposed to be ignoring and leaving to you :)
> 
> :)
> 
> If you receive any new drivers like the dt3155v4l that include
> one of those files:
> 	linux/videodev2.h
> 	media/*.h
> 	linux/dvb/*.h
> They're dependent on the media core. So, could you please let me know about
> its addition at staging, by either forwarding it to me or adding it at the 
> new staging/media c/c me on your reply?
> 
> > Just let me know which ones I should move into there and I will do that
> > today and let you maintain them all and just forward any emails to you.
> > Which will keep issues like this from happening in the future.
> 
> At the current linux-next tree, the drivers are media stuff:
> 	staging/easycap
> 	staging/go7007
> 	staging/solo6x10
> 	staging/cx25821
> 	staging/lirc
> 	staging/cxd2099
> 	staging/altera-stapl
> 	staging/dt3155v4l
> 
> >From the above:
> 	 staging/tm6000 can be moved to /drivers/media/video, after a final checkpatch
> cleanup patch I've made. However, I have some changesets for it on my -next tree,
> so it is probably wiser if I move it on my tree instead on yours.
> 
> 	staging/cx25281 can also be moved to drivers/media/video after some codingstyle
> fixups. I think you're received some such patches recently. Not sure if they cover the
> remaining checkpatch.pl significative complains.
> 
> 	staging/cxd2099 has one problem: it exposes a wrong DVB API for the conditional
> access module, due to the lack of a proper API definition. It is a driver optionally used 
> by some DVB cards, so moving it may require some include fixups. I don't want to move it
> out of staging while we don't have a solution for the API issue. I'm planning to discuss 
> it during the media KS workshop in Plague.
> 
> 	staging/altera-stapl can be moved to drivers/misc. One include needs to be fixup
> when moving it, as one DVB driver uses it for a couple boards that come with this
> companion chipset.
> 
> If you prefer, I can do the git mv patches for those weird stuff.

That would be easiest, if you want to create drivers/staging/media/ and
move what you want to maintain into it, please do so.

thanks,

greg k-h
