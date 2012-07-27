Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab2G0RKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 13:10:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:24440 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab2G0RKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 13:10:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="178406144"
Date: Fri, 27 Jul 2012 10:10:11 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Daniel J Blueman <daniel@quora.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Add Etron XHCI quirk to avoid warning spam
Message-ID: <20120727171011.GF11608@xanatos>
References: <1343361824-11417-1-git-send-email-daniel@quora.org>
 <20120727061430.GC11608@xanatos>
 <CAMVG2sv1vDe-jmS+U-6QCLX67S57zxkAk-jYiFX59jcOEEGfPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMVG2sv1vDe-jmS+U-6QCLX67S57zxkAk-jYiFX59jcOEEGfPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 02:40:56PM +0800, Daniel J Blueman wrote:
> On 27 July 2012 14:14, Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:
> > On Fri, Jul 27, 2012 at 12:03:44PM +0800, Daniel J Blueman wrote:
> >> When various USB3 devices with Etron XHCI controllers, we see a bunch of
> >> warnings:
> >> xhci_hcd 0000:02:00.0: WARN Successful completion on short TX: needs
> >> XHCI_TRUST_TX_LENGTH quirk?
> >>
> >> Acknowledge the issue by adding the quirk.
> >>
> >> Signed-off-by: Daniel J Blueman <daniel@quora.org>
> []
> > I already have a patch in my queue for this.  However, it keys off the
> > PCI_DEVICE_ID_ASROCK_P67 PCI device ID.  Do you have another Etron
> > device with a different device ID that needs this quirk?
> 
> Yes, the subsystem ID is different [1] (but Zotac program it the same
> as the vendor and device IDs here), however what you say suggests the
> problem is general to this Etron XHCI controller (1b6f:7023), as we'd
> suspect anyway.
> 
> Thus the more general patch I posted makes better sense perhaps?

I'd really like to keep this quirk specific to the particular PCI vendor
and device ID.  It's possible that their next chip version will have the
opposite issue (short TX completion code and bad untransferred length).

Your patch turned it on for all Etron hosts, so I would rather keep my
version:

http://git.kernel.org/?p=linux/kernel/git/sarah/xhci.git;a=commit;h=12751f75720391bb2b607acdb2537f02e313251e

I also added a second patch to rate limit the messages for other hosts
that have this issue but don't have the quirk turned on:

http://git.kernel.org/?p=linux/kernel/git/sarah/xhci.git;a=commit;h=5de3270101d30a4a8023815f8010eef2d2d40613

Sarah Sharp
