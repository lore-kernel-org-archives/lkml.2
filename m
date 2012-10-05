Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab2JEItj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:49:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab2JEItg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:49:36 -0400
Date: Fri, 5 Oct 2012 01:50:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Chris Zankel <chris@zankel.net>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [patch 0/3] Turn CONFIG_HOTPLUG always on.
Message-Id: <20121005015036.0d0b7ebd.akpm@linux-foundation.org>
In-Reply-To: <20120906202815.GA6732@kroah.com>
References: <20120904234803.554552301@clark.kroah.org>
	<20120906202815.GA6732@kroah.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Sep 2012 13:28:16 -0700 Greg KH <gregkh@linuxfoundation.org> wrote:

> On Tue, Sep 04, 2012 at 05:01:05PM -0700, Greg Kroah-Hartman wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > 
> > The CONFIG_HOTPLUG variable is tough to turn off, and almost all arches
> > default to it on.
> > 
> > If you turn it off, it saves you a big 200 or so bytes, and then starts
> > to cause all sorts of problems as the code paths if the option is
> > disabled is never really tested, and memory segments start to get thrown
> > away that driver authors assume will always be present.
> > 
> > So, as part of trying to get rid of the option entirely, let's just turn
> > the option always on.
> > 
> > Note, to do this properly, I found two duplicate definitions of the
> > option, in the Tile and Xtensa arch files, this patch series removes
> > those duplicates first.
> > 
> > Anyone object to me just taking these three patches through my
> > driver-core tree for 3.7?  After this set, I'll start unwinding the
> > places where CONFIG_HOTPLUG is used and remove the parts that are not
> > used anymore now that the option can not be turned off.
> 
> Given the lack of objection, I've now queued these up for 3.7 and will
> start unwinding the CONFIG_HOTPLUG mess.
> 

I wonder if this has had sufficient consideration.

It isn't just 200 bytes, is it?  It's all memory which is marked
__devinit* and __devexit* - that's a tremendous amount of stuff.  We
should quantify it.

It wouldn't surprise me if there are organizations who are using
CONFIG_HOTPLUG=n effectively.  We regularly bust a gut to save a few
bytes and for people who really care about this we're here sending them
backwards a lot further than that.

Tim, do you know?
