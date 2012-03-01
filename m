Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab2CAUIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:08:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:37031 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098Ab2CAUIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:08:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="116665152"
Date: Thu, 1 Mar 2012 12:07:50 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-usb@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] usb, PCI: split quirk for usb host controller to
 three
Message-ID: <20120301200750.GB5155@xanatos>
References: <1330622227-4209-1-git-send-email-yinghai@kernel.org>
 <20120301172435.GA8505@kroah.com>
 <20120301190323.GA5155@xanatos>
 <CAE9FiQXPi2VY+cVOxaQr=MBy_m3Dr0BKG6DRTCP1TrbuDcMCfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQXPi2VY+cVOxaQr=MBy_m3Dr0BKG6DRTCP1TrbuDcMCfg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 11:19:06AM -0800, Yinghai Lu wrote:
> On Thu, Mar 1, 2012 at 11:03 AM, Sarah Sharp
> <sarah.a.sharp@linux.intel.com> wrote:
> > On Thu, Mar 01, 2012 at 09:24:35AM -0800, Greg Kroah-Hartman wrote:
> >> On Thu, Mar 01, 2012 at 09:17:07AM -0800, Yinghai Lu wrote:
> >> > so we avoid checking class again and again in that quirk.
> >> >
> >> > need to be applied after pci/linux-next and usb/usb-next
> >>
> >> As those are two independant trees, this needs to wait until after
> >> 3.4-rc1 is out.
> >>
> >> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >> >
> >> > ---
> >> >  drivers/usb/host/pci-quirks.c |   42 ++++++++++++++++++++++++++++--------------
> >> >  1 file changed, 28 insertions(+), 14 deletions(-)
> >>
> >> Is this really helping anything here?  You added code overall :(
> >
> > I agree with Greg.  Why change this?  Does it shave off any boot time?
> > Please show hard numbers for what improvements this makes.  I really
> > don't want to change PCI init and break people's systems.
> 
> but your code make pci init change to call disable/enable for non-xhci
> for fixing xhci problem.

We discussed this, and agreed it was safe to do so for all USB host
controllers.  It's possible some other BIOS will disable the PCI host
controller before handing it off to the OS, so we have to handle that
case.  So it's fine that we enable/disable the device for all USB host
controllers.  I tried to make sure we weren't enabling/disabling for
non-USB PCI devices.

Sarah Sharp
