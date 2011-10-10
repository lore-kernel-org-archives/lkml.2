Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab1JJBHF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 21:07:05 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51291 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854Ab1JJBHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 21:07:03 -0400
X-Sasl-enc: ggKGe86ydavvXt5ZtH6hvXgBg6v3A06i/wF7UDB0hOvT 1318208821
Date: Sun, 9 Oct 2011 18:06:56 -0700
From: Greg KH <greg@kroah.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Valdis.Kletnieks@vt.edu, "G, Manjunath Kondaiah" <manjugk@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/5] drivercore: add new error value for deferred probe
Message-ID: <20111010010656.GA16537@kroah.com>
References: <1317963790-29426-1-git-send-email-manjugk@ti.com>
 <1317963790-29426-2-git-send-email-manjugk@ti.com>
 <20111007064349.GD27508@kroah.com>
 <CACxGe6uOmrLwJSPw4JHuOmt5B2wsukdDgVUr01pryq5Z9BFadw@mail.gmail.com>
 <32004.1318030113@turing-police.cc.vt.edu>
 <20111008001237.GA30551@kroah.com>
 <CACxGe6t+PfnNGniYUj3pbK22uqjqkbh2+D=7qvvd_-Yd4yR0dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACxGe6t+PfnNGniYUj3pbK22uqjqkbh2+D=7qvvd_-Yd4yR0dw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 09, 2011 at 04:59:31PM -0600, Grant Likely wrote:
> On Fri, Oct 7, 2011 at 6:12 PM, Greg KH <greg@kroah.com> wrote:
> > On Fri, Oct 07, 2011 at 07:28:33PM -0400, Valdis.Kletnieks@vt.edu wrote:
> >> On Fri, 07 Oct 2011 16:12:45 MDT, Grant Likely said:
> >> > On Fri, Oct 7, 2011 at 12:43 AM, Greg KH <greg@kroah.com> wrote:
> >> > > On Fri, Oct 07, 2011 at 10:33:06AM +0500, G, Manjunath Kondaiah wrote:
> >>
> >> > >> +#define EPROBE_DEFER 517     /* restart probe again after some time */
> >> > >
> >> > > Can we really do this?
> >>
> >> > According to Arnd, yes this is okay.
> >>
> >> > >  Isn't this some user/kernel api here?
> >>
> >> > > What's wrong with just "overloading" on top of an existing error code?
> >> > > Surely one of the other 516 types could be used here, right?
> >>
> >> > overloading makes it really hard to find the users at a later date.
> >>
> >> Would proposing '#define EPROBE_DEFER EAGAIN' be acceptable to everybody? That
> >> would allow overloading EAGAIN, but still make it easy to tell the usages apart
> >> if we need to separate them later...
> >
> > Yes, please do that, it is what USB does for it's internal error code
> > handling.
> 
> Really?  When we've only currently used approximately 2^9 of a 2^31
> numberspace?  I'm fine with making sure that the number doesn't show
> up in the userspace headers, but it makes no sense to overload the
> #defines.  Particularly so in this case where it isn't feasible to
> audit every driver to figure out what probe might possibly return.  It
> is well within the realm of possibility that existing drivers are
> already returning -EAGAIN.

I doubt they are, but you are right, it's really hard to tell.

> Besides; linux/errno.h *already* has linux-internal error codes that
> do not get exported out to userspace.  There is an #ifdef __KERNEL__
> block around ERESTARTSYS through EIOCBRETRY which is filtered out when
> exporting headers.  I can't see any possible reason why we wouldn't
> add Linux internal error codes here.

As long as it stays internal, that's fine, I was worried that this would
be exported to userspace.

Alan, still object to this?

greg k-h
