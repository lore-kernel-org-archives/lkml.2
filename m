Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab0KDN0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 09:26:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:35249 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab0KDN0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 09:26:43 -0400
Date: Thu, 4 Nov 2010 06:17:32 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Dr. Werner Fink" <werner@suse.de>,
        Al Viro <viro@ZenIV.linux.org.uk>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] console: add /proc/consoles
Message-ID: <20101104131732.GA10390@suse.de>
References: <1288798509-23550-1-git-send-email-jslaby@suse.cz> <20101103161342.GA4942@suse.de> <4CD18ACB.4060108@suse.cz> <20101103162251.GA5404@suse.de> <4CD18CFC.7080100@suse.cz> <20101103173944.GA6589@suse.de> <4CD1C01E.1010309@gmail.com> <20101103211237.GA2105@suse.de> <4CD2836E.4090908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD2836E.4090908@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 10:57:02AM +0100, Jiri Slaby wrote:
> On 11/03/2010 10:12 PM, Greg KH wrote:
> > On Wed, Nov 03, 2010 at 09:03:42PM +0100, Jiri Slaby wrote:
> >> On 11/03/2010 06:39 PM, Greg KH wrote:
> >>> On Wed, Nov 03, 2010 at 05:25:32PM +0100, Jiri Slaby wrote:
> >>>> Actually where this code should be in fs/proc/? Most of the /proc/* is
> >>>> handled elsewhere (fs/ mm/ kernel/). The rest is handled in specialized
> >>>> fs/proc/FILE.c.
> >>>
> >>> What's wrong with putting it into fs/proc/proc_tty.c?  That seems like
> >>> the most logical thing to me...
> >>
> >> consoles have little to do with ttys. Except ttys can be consoles.
> > 
> > And all consoles are ttys :)
> 
> Oh, they are not. Or maybe I'm missing something?

No, you are correct, I was wrong.

> >> To me
> >> it seems illogical to have info about netconsole, parallel consoles or
> >> early serials somewhere in /proc/tty/. That's why I moved the info from
> >> /proc/tty/ to /proc and the code from fs/proc/proc_tty.c to
> >> kernel/printk.c where consoles are managed.
> > 
> > Ok, how about fs/proc/proc_console.c instead?
> 
> Yes, this sounds good.

Great.

thanks,

greg k-h
