Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab1J3FEs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 01:04:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:46040 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab1J3FEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 01:04:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,425,1315206000"; 
   d="scan'208";a="68452528"
Date: Sun, 30 Oct 2011 06:04:43 +0100
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: USB list <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        v4mp <gaigo88@hotmail.it>
Subject: Re: Question about error from xhci-hcd
Message-ID: <20111030050443.GC4535@xanatos>
References: <4EAC3C5C.5000209@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EAC3C5C.5000209@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 12:48:12PM -0500, Larry Finger wrote:
> Sarah,
> 
> Pardon the intrusion, but I'm trying to fix a problem for v4mp, a
> user of the rtl8192cu driver on an Alfa AWUS036NHR. I have one of
> the devices, and it works on a USB 2.0 hub, but fails with 3.0
> hardware with lots of
> 
> xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> 
> messages logged.

The xHCI driver allocates a fixed-size endpoint ring, and only so much
data can fit on it.  If the driver is allocating many URBs or many URBs
with a lot of data, then you will see these messages and the URBs will
fail to be submitted.  Now if neither of those conditions are true, then
it's possible we just have a bug in the xHCI driver.

There is a patchset in the works to dynamically expand the endpoint
rings, but it's still going through revisions:

http://marc.info/?l=linux-usb&m=131918645424329&w=2

It might be done for the 3.3 kernel, but until then the driver is just
going to be broken, sorry. :(

> The device works with an out-of-kernel driver available from the
> Alfa or Realtek web sites, but I want to fix rtl8192cu.
> 
> What condition leads to the above message? The user's dmesg buffer
> has wrapped, thus I don't see the beginning of the failure. He is
> using a canned distro kernel, thus he cannot include any extra
> debugging info such as a stack dump when the errors occur. As he
> uses the compat-wireless package, I think I can incorporate a new
> copy of xhci-hcd with it, but I have not done so yet.

Which distro?  Several of the distros are based on 2.6.32, which only
had minimal support for xHCI.  Updating just the xHCI driver with a
more recent one isn't going to be possible with that old of a kernel,
since later changes also touched the USB core as well.

Sarah Sharp
