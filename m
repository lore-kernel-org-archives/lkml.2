Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab1CNUyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:54:37 -0400
Received: from kroah.org ([198.145.64.141]:45868 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab1CNUyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:54:36 -0400
Date: Mon, 14 Mar 2011 13:13:46 -0700
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Subject: Re: [PATCH v2 11/12] driver: Google EFI SMI
Message-ID: <20110314201346.GA1084@kroah.com>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
 <20110312014353.6133.94204.stgit@mike.mtv.corp.google.com>
 <20110314154713.GF31340@kroah.com>
 <AANLkTikhhYv2=memo-Rkhh1pG3v4-edrUROTgLoc6cbd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikhhYv2=memo-Rkhh1pG3v4-edrUROTgLoc6cbd@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 01:01:50PM -0700, Mike Waychison wrote:
> On Mon, Mar 14, 2011 at 8:47 AM, Greg KH <greg@kroah.com> wrote:
> > On Fri, Mar 11, 2011 at 05:43:53PM -0800, Mike Waychison wrote:
> >> The "gsmi" driver bridges userland with firmware specific routines for
> >> accessing hardware.
> >
> > As with the other driver in this series, what keeps this driver from
> > being loaded on hardware that does not support this functionality?  If
> > it is loaded, will it cause bad things to happen?
> 
> gsmi itself is better guarded than the memconsole driver that the x86
> maintainers objected to.
> 
> It relies on keying off of a couple different strings, looking for
> "GOOGLE" as either the OEM ID in the  FADT table, or "Google, Inc." as
> the board vendor.  We further discriminate whether the driver should
> load (it doesn't apply to all of our boards) with a couple other
> checks.  See gsmi_system_valid().  I've added a comment to the patch
> description indicating this for the upcoming v3 send-out.

Ok, fair enough.  I'm guessing that you have tried testing the module by
loading it in a machine where this doesn't work?

> > Also, what causes it to be loaded on hardware that needs it?  There
> > should be some MODULE_DEVICE_TABLE somewhere in this thing to cause it
> > to be autoloaded?
> 
> I don't know if there is a good way to have this guy autoloaded, but
> that's probably fine. We will likely compile it in as a built-in or
> adjust our userland to have the module loaded.  We use it on all
> machines we've been building for the last 4-5 years, and a table of
> device IDs would just contain a list of a bunch of parts that aren't
> really google-specific.

What's wrong with using DMI strings?  Are there going to be that many
different ones of them here?

thanks,

greg k-h
