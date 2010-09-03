Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab0ICHdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:33:12 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:36566 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806Ab0ICHdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 03:33:11 -0400
Date: Fri, 3 Sep 2010 04:17:15 -0400
From: Andres Salomon <dilinger@queued.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        cjb@laptop.org, Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        grant.likely@secretlab.ca,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: Re: [PATCH 1/9] of: move phandle/ihandle into types.h
Message-ID: <20100903041715.573471e4@debxo>
In-Reply-To: <20100830050627.GA12153@merkur.ravnborg.org>
References: <20100628215407.2017bf2f@debian>
	<20100829235100.6dcedcb8@debxo>
	<20100829235352.1744e7e3@debxo>
	<20100830050627.GA12153@merkur.ravnborg.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010 07:06:27 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Sun, Aug 29, 2010 at 11:53:52PM -0400, Andres Salomon wrote:
> > 
> > We need phandle for some exported sparc headers; of.h isn't an
> > exported header, and it would be silly to export it when all we
> > really need is one or two types from it.  So, move the
> > phandle/ihandle definitions into types.h.
> > 
> > diff --git a/include/linux/types.h b/include/linux/types.h
> > index 01a082f..26526ea 100644
> > --- a/include/linux/types.h
> > +++ b/include/linux/types.h
> > @@ -219,6 +219,10 @@ struct ustat {
> >  	char			f_fpack[6];
> >  };
> >  
> > +/* Basic openboot/openfirmware types */
> > +typedef u32 phandle;
> > +typedef u32 ihandle;
> > +
> >  #endif	/* __KERNEL__ */
> 
> The above is inside #ifdef __KERNEL__ / #endif
> so it is not exported as we drop code protected
> by __KERNEL__ when we prepare for export.



At least for me, that's fine; I don't need phandle/ihandle to be
available to userspace.  The folks who work on the userspace fdt code
may feel differently, however.

(I'm not sure if you're suggesting it be outside the __KERNEL__ ifdef
or not..)

> 
> Id addition "phandle" and "ihandle" needs to have
> two underscores apended as we cannot just add the above
> to the userspace namespace and expect it to be OK.
> 
> We do this for many other typers already, see __u32 for example.
> 
> 	Sam

