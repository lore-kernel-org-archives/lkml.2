Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab1JROq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:46:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52089 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199Ab1JROqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:46:55 -0400
Date: Tue, 18 Oct 2011 07:38:57 -0700
From: Greg KH <gregkh@suse.de>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 2/6] drivers/base: add bus for System-on-Chip devices
Message-ID: <20111018143857.GA19561@suse.de>
References: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
 <20111017161854.GB5108@suse.de>
 <4E9D5FAB.2080605@linaro.org>
 <201110181605.12512.arnd@arndb.de>
 <20111018141520.GA10054@totoro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111018141520.GA10054@totoro>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 03:15:20PM +0100, Jamie Iles wrote:
> Hi Arnd,
> 
> On Tue, Oct 18, 2011 at 04:05:12PM +0200, Arnd Bergmann wrote:
> > On Tuesday 18 October 2011, Lee Jones wrote:
> > > On 17/10/11 17:18, Greg KH wrote:
> > > > On Mon, Oct 17, 2011 at 12:52:54PM +0100, Lee Jones wrote:
> > > >> +
> > > >> +	bus_unregister(&soc_bus_type);
> > > > 
> > > > What happens if you have more than one SOC device?  I think you just
> > > > oopsed.
> > > 
> > > I think you're right.
> > > 
> > > When to you suggest we unregister the bus?
> > 
> > Do it in the same way as registering it, as a module_exit() function
> > below the initcall that instantiates it. These interfaces usually come
> > in pairs, so if something does not look symmetric, you should better
> > have another look.
> 
> I can't think of a system where it make sense to have this as a loadable 
> module so can't we just register the bus_type and never unregister it 
> like the platform and spi busses for example?
> 
> Also, (and I'm right at the edge of my knowledge here!) wouldn't you 
> also need to add reference counting of the module when 
> creating/destroying a soc device to prevent the module and bus 
> disappearing whilst you had devices with a reference to it?

Yes, that is why your register function should take a module pointer,
like USB, PCI, and other bus functions do.

greg k-h
