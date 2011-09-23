Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab1IWO1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:27:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:34127 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab1IWO1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:27:17 -0400
Message-ID: <4E7C9736.30707@infradead.org>
Date: Fri, 23 Sep 2011 11:27:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
References: <20110922131232.56210b544f587210621ae339@canb.auug.org.au> <4E7B2E43.3080609@infradead.org> <20110922201909.GA13347@kroah.com>
In-Reply-To: <20110922201909.GA13347@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 22-09-2011 17:19, Greg KH escreveu:
> On Thu, Sep 22, 2011 at 09:46:59AM -0300, Mauro Carvalho Chehab wrote:
>> Em 22-09-2011 00:12, Stephen Rothwell escreveu:
>>> Hi Mauro,
>>>
>>> After merging the v4l-dvb tree, today's linux-next build (x86_64
>>> allmodconfig) failed like this:
>>>
>>> drivers/staging/dt3155v4l/dt3155v4l.c: In function 'dt3155_start_acq':
>>> drivers/staging/dt3155v4l/dt3155v4l.c:210:2: error: implicit declaration of function 'vb2_dma_contig_plane_paddr'
>>> drivers/staging/dt3155v4l/dt3155v4l.c: At top level:
>>> drivers/staging/dt3155v4l/dt3155v4l.c:321:2: warning: initialization from incompatible pointer type
>>> drivers/staging/dt3155v4l/dt3155v4l.c:325:2: warning: initialization from incompatible pointer type
>>>
>>> Casued by commit ba7fcb0c9549 ("[media] media: vb2: dma contig allocator:
>>> use dma_addr instread of paddr").
>>>
>>> I have used the v4l-dvb tree from next-20110921 for today.
>>
>> Hi Stephen,
>>
>> I think that the right thing to do is to disable the building of this
>> staging driver, if it is not using the current media core API's.
>>
>> Greg,
>>
>> If possible, I prefer to merge those staging drivers for the media
>> subsystem via my tree, as it helps me to solve in advance conflicts
>> like that. Maybe we could add a drivers/staging/media tree or
>> drivers/media/staging, and move those beasts to there.
>>
>> What do you think?
> 
> Yes, I would _LOVE_ a drivers/staging/media/ directory so that I know
> which drivers I am supposed to be ignoring and leaving to you :)

:)

If you receive any new drivers like the dt3155v4l that include
one of those files:
	linux/videodev2.h
	media/*.h
	linux/dvb/*.h
They're dependent on the media core. So, could you please let me know about
its addition at staging, by either forwarding it to me or adding it at the 
new staging/media c/c me on your reply?

> Just let me know which ones I should move into there and I will do that
> today and let you maintain them all and just forward any emails to you.
> Which will keep issues like this from happening in the future.

At the current linux-next tree, the drivers are media stuff:
	staging/easycap
	staging/go7007
	staging/solo6x10
	staging/cx25821
	staging/lirc
	staging/cxd2099
	staging/altera-stapl
	staging/dt3155v4l

>From the above:
	 staging/tm6000 can be moved to /drivers/media/video, after a final checkpatch
cleanup patch I've made. However, I have some changesets for it on my -next tree,
so it is probably wiser if I move it on my tree instead on yours.

	staging/cx25281 can also be moved to drivers/media/video after some codingstyle
fixups. I think you're received some such patches recently. Not sure if they cover the
remaining checkpatch.pl significative complains.

	staging/cxd2099 has one problem: it exposes a wrong DVB API for the conditional
access module, due to the lack of a proper API definition. It is a driver optionally used 
by some DVB cards, so moving it may require some include fixups. I don't want to move it
out of staging while we don't have a solution for the API issue. I'm planning to discuss 
it during the media KS workshop in Plague.

	staging/altera-stapl can be moved to drivers/misc. One include needs to be fixup
when moving it, as one DVB driver uses it for a couple boards that come with this
companion chipset.

If you prefer, I can do the git mv patches for those weird stuff.

> 
> thanks,
> 
> greg k-h

Thanks,
Mauro
