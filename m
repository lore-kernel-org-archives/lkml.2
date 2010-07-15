Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934786Ab0GOVHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 17:07:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:34160 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934734Ab0GOVHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 17:07:40 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+nlxduwYSnD/Fd4rqLu2/ROfPa+z0BdZA+7vTcGa
	/tZzpmH+VveUT2
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 12/25] char: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 23:07:34 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
        "Digi International, Inc" <Eng.Linux@digi.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
References: <201007152052.38060.PeterHuewe@gmx.de> <20100715204540.GB24463@suse.de>
In-Reply-To: <20100715204540.GB24463@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007152307.35062.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 15 Juli 2010 22:45:40 schrieb Greg KH:
> The main reason I hate this macro, is that it now makes it almost
> impossible to grep for any users of the PCI_VENDOR_DIGI pci vendor id.
> I much prefer the PCI_DEVICE() macro instead, and as such, I'm not
> willing to take any of these patches, sorry.

No problem ;)
Patches are just proposals - nothing else.

The only  question that remains is, do you see any point in converting the 
patches to use PCI_DEVICE?
Since you have to address/set the .driver_data explicitly I guess there's no 
point in doing it.

It's
{ PCI_VENDOR_DIGI, PCI_DEVICE_XRJ, PCI_ANY_ID, PCI_ANY_ID, 0, 0, brd_xrj },
vs.
 { PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_XR), .driver_data=brd_xrj },
and I guess it isn't really an improvement.

Maybe there should be a version of PCI_DEVICE that addresses this issue? 
But I have to admit, something like:
{ PCI_DEVICE_DD(PCI_VENDOR_ID_DIGI, PCI_DEVICE_XR), brd_xrj }, 
doesn't look that much better.

Thanks,
Peter
