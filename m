Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049Ab0IXQvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:51:07 -0400
Received: from kroah.org ([198.145.64.141]:52223 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595Ab0IXQvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:51:00 -0400
Date: Fri, 24 Sep 2010 09:46:09 -0700
From: Greg KH <greg@kroah.com>
To: Mat <jackdachef@gmail.com>
Cc: Gabriel C <nix.or.die@googlemail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jkosina@suse.cz>,
        Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>,
        Alan Ott <alan@signal11.us>, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, Andreas Bombe <aeb@debian.org>,
        Alex Riesen <raa.lkml@gmail.com>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st
 insert, ignored on 2nd insert, lsusb stuck at usbdev_open
Message-ID: <20100924164609.GB16655@kroah.com>
References: <Pine.LNX.4.44L0.1009211013460.1644-100000@iolanthe.rowland.org>
 <4C98C70B.3080407@turmel.org>
 <4C98D892.7030605@googlemail.com>
 <AANLkTinQVNy4yOSW=aEbuYh6b_F8nKBLxsjxBDk8zq8O@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinQVNy4yOSW=aEbuYh6b_F8nKBLxsjxBDk8zq8O@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 11:47:09AM +0200, Mat wrote:
> On Tue, Sep 21, 2010 at 6:08 PM, Gabriel C <nix.or.die@googlemail.com> wrote:
> > On 21.09.2010 16:54, Phil Turmel wrote:
> >
> >> On 09/21/2010 10:30 AM, Alan Stern wrote:
> >>> On Tue, 21 Sep 2010, Jiri Kosina wrote:
> >>>
> >>>> I have just found out that it's actually CONFIG_USB_DYNAMIC_MINORS which
> >>>> makes the difference. When unset, the problem doesn't trigger, and
> >>>> usb_find_interface() always returns the proper interface. When
> >>>> CONFIG_USB_DYNAMIC_MINORS is being used, the oops happen.
> >>>>
> >>>> I'll look into that.
> >>>
> >>> Apparently the problem is that intf->minors doesn't get initialized
> >>> properly.  This patch should fix it.  Everybody, please try it out.
> >>
> >> Yes, this works for me.  (as did Jiri's version.)
> >
> >
> > Both versions of the patch are working fine for me too also.
> >
> >>
> >> Thank you both for the support.
> >>
> >> Feel free to add my:
> >>
> >> Tested-by: Philip J. Turmel <philip@turmel.org>
> >
> >
> > And mine if you wish.
> > Tested-by: Gabriel Craciunescu  <nix.or.die@googlemail.com>
> >
> >
> 
> confirmed !
> 
> I also tested both and it works fine so far :)
> 
> I don't know if it's too late already:
> Tested-by: Matthias Bayer <jackdachef@gmail.com>

Nope, not to late, I've added this to the patch as well, thanks for
letting us know.

greg k-h
