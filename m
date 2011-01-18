Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab1ARJzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 04:55:31 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:56959 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab1ARJz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 04:55:28 -0500
Date: Tue, 18 Jan 2011 18:53:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
Cc: sfr@canb.auug.org.au, "'Arnd Bergmann'" <arnd@arndb.de>, gregkh@suse.de,
        jbarnes@virtuousgeek.org, dmitry.torokhov@gmail.com, dtor@mail.ru,
        rubini@cvml.unipv.it, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: Request for unicore32 architecture codes to merge into linux-next
Message-ID: <20110118095309.GA18773@linux-sh.org>
References: <004901cbb4d5$b9bb1370$2d313a50$@mprc.pku.edu.cn> <20110118043323.GF2122@linux-sh.org> <01b501cbb6ef$3299f2a0$97cdd7e0$@mprc.pku.edu.cn> <20110118091032.GA18525@linux-sh.org> <01bf01cbb6f2$cdba4a70$692edf50$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01bf01cbb6f2$cdba4a70$692edf50$@mprc.pku.edu.cn>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 05:33:44PM +0800, Guan Xuetao wrote:
> > -----Original Message-----
> > From: linux-next-owner@vger.kernel.org [mailto:linux-next-owner@vger.kernel.org] On Behalf Of Paul Mundt
> > Sent: Tuesday, January 18, 2011 5:11 PM
> > To: Guan Xuetao
> > Cc: sfr@canb.auug.org.au; 'Arnd Bergmann'; gregkh@suse.de; jbarnes@virtuousgeek.org; dmitry.torokhov@gmail.com; dtor@mail.ru;
> > rubini@cvml.unipv.it; linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org; linux-fbdev@vger.kernel.org; linux-
> > next@vger.kernel.org
> > Subject: Re: Request for unicore32 architecture codes to merge into linux-next
> > 
> > On Tue, Jan 18, 2011 at 05:07:41PM +0800, Guan Xuetao wrote:
> > > IMO, the whole architecture specific codes need to be merged first, and only some
> > > necessary drivers are included under staging. Then, I could split the staging drivers
> > > into corresponding mail-list, and then, additional drivers.
> > > Otherwise, there are no architecture basic for drivers review.
> > >
> > That's of course fine so long as the driver changes are reasonably
> > self-contained. The situation we want to avoid is that you end up with
> > drivers that depend on some private infrastructure of API where not
> > enough context is provided when the two are decoupled.
> > 
> > In any event, the architecture bits are the most self-contained and have
> > had the most review of anything in this series of patches, so it probably
> > makes sense to work on getting those bits integrated and then dealing
> > with the rest incrementally.
> Then, I should:
> 1. merge reviewed arch dir and reviewed drivers (for now, i8042)
> 2. submit staging drivers to review
> Am I right?
> 
That would at least make it easier to get parts of it merged while the
drivers get reviewed and reworked. If enough people are content with the
state of the architecture patches then there is no reason why they can't
be pulled in to -next once it's open for .39 changes. The drivers can
then gradually find their way in to -next via subsystem trees.

>From my point of view (though I don't believe I'm a minority in this),
staging/ in general should be a last resort for new drivers. Since you
are at least actively replying and making changes that have been
requested, there should really be no need to go the staging route for
any of the drivers at all.

On the other hand, if it turns out you have a big chunk of crazed and
incomprehensible infrastructure like an interpreter or something equally
perverse in the middle somewhere that everything depends on, that does of
course complicate things and limit your options somewhat, but those sorts
of things are hopefully corner cases (I admit the fact that you're
linking libc in to the kernel has rather scared me away from reviewing
the rest of the patches under closer scrutiny). Your goal in general
should be to avoid staging completely and submit small logically isolated
components that can be reviewed and merged wholly independently of
anything else.
