Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab1JHAN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 20:13:29 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45416 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752563Ab1JHAN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 20:13:28 -0400
X-Sasl-enc: 0/DDXr41+r0cXXTbjPWCUsL+Clc+ZeEEYYqDUHJXLJ11 1318032807
Date: Fri, 7 Oct 2011 17:12:37 -0700
From: Greg KH <greg@kroah.com>
To: Valdis.Kletnieks@vt.edu
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "G, Manjunath Kondaiah" <manjugk@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/5] drivercore: add new error value for deferred probe
Message-ID: <20111008001237.GA30551@kroah.com>
References: <1317963790-29426-1-git-send-email-manjugk@ti.com>
 <1317963790-29426-2-git-send-email-manjugk@ti.com>
 <20111007064349.GD27508@kroah.com>
 <CACxGe6uOmrLwJSPw4JHuOmt5B2wsukdDgVUr01pryq5Z9BFadw@mail.gmail.com>
 <32004.1318030113@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <32004.1318030113@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 07:28:33PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 07 Oct 2011 16:12:45 MDT, Grant Likely said:
> > On Fri, Oct 7, 2011 at 12:43 AM, Greg KH <greg@kroah.com> wrote:
> > > On Fri, Oct 07, 2011 at 10:33:06AM +0500, G, Manjunath Kondaiah wrote:
> 
> > >> +#define EPROBE_DEFER 517     /* restart probe again after some time */
> > >
> > > Can we really do this?
> 
> > According to Arnd, yes this is okay.
> 
> > >  Isn't this some user/kernel api here?
> 
> > > What's wrong with just "overloading" on top of an existing error code?
> > > Surely one of the other 516 types could be used here, right?
> 
> > overloading makes it really hard to find the users at a later date.
> 
> Would proposing '#define EPROBE_DEFER EAGAIN' be acceptable to everybody? That
> would allow overloading EAGAIN, but still make it easy to tell the usages apart
> if we need to separate them later...

Yes, please do that, it is what USB does for it's internal error code
handling.

greg k-h
