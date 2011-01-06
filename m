Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab1AFIAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:00:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:62760 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab1AFIA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:00:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,282,1291622400"; 
   d="scan'208";a="694101293"
Date: Thu, 6 Jan 2011 00:00:25 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Linux-usb <linux-usb@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Sleeping function called from invalid context in 2.6.37
 xhci_hcd
Message-ID: <20110106080025.GA27255@xanatos>
References: <4D250B2B.8090901@gmail.com>
 <20110106003003.GA3337@suse.de>
 <AANLkTi=a=ARbmr6e9KvuNdtLWkQyfecrQOPeTHze5=Xf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=a=ARbmr6e9KvuNdtLWkQyfecrQOPeTHze5=Xf@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 06:59:59PM -0600, Robert Hancock wrote:
> On Wed, Jan 5, 2011 at 6:30 PM, Greg KH <gregkh@suse.de> wrote:
> > On Wed, Jan 05, 2011 at 06:22:03PM -0600, Robert Hancock wrote:
> >> Just saw this on booting up on the latest Fedora Rawhide kernel
> >> based on 2.6.37. Looks like we were trying to do a runtime suspend
> >> on the xHCI USB controller and it disabled MSI-X while interrupts
> >> were disabled?
> >
> > Known issue, patches came in too late to make it for .37, hopefully will
> > show up in .38-rc and then get backported to .37.  They are on the
> > linux-usb mailing list if you need them now.
> 
> Not sure if it's related to this issue or not, but I also noticed the
> USB 3.0 card wasn't detecting any connected devices until I disabled
> USB autosuspend on the controller through sysfs (which is enabled by
> default in that Fedora Rawhide kernel)..

There's a couple more patches to deal with some issues with
disconnecting a USB device (or safely removing a USB mass storage
device) when the bus is suspended.  See the patches starting in this
thread:

http://marc.info/?l=linux-usb&m=129421308020494&w=2

Try applying the first five patches and let me know if you still see any
issues.  The fourth patch has a known compile warning (it will get fixed
shortly) but you shouldn't run into that particular error path.

Sarah Sharp
