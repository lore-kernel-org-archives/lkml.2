Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab1KFWCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 17:02:55 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:44725 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752252Ab1KFWCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 17:02:54 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18+zwNHW9Q+rw3Fu6+q5juVRuYrTk+BkhtB5RfGjW
	gDKxLNTHr8N7Z1
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging/xgifb: Convert pci_table entries to PCI_DEVICE (if PCI_ANY_ID is used)
Date: Sun, 6 Nov 2011 23:02:50 +0100
User-Agent: KMail/1.13.5 (Linux/3.1.0; KDE/4.4.5; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <1320613517-3086-1-git-send-email-peterhuewe@gmx.de> <59D8A47D-7B28-48CA-82D3-BCB50619D683@iki.fi>
In-Reply-To: <59D8A47D-7B28-48CA-82D3-BCB50619D683@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111062302.51332.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 06 November 2011, 22:37:53 schrieb Aaro Koskinen:
> > -	{PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_20, PCI_ANY_ID, PCI_ANY_ID,
> > -	 0, 0, 0},
> > +	{PCI_DEVICE(PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_20), 0, 0, 0},
> I think the correct way would be
> 
> 	{PCI_DEVICE(PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_20), .driver_data = 0},

I was thinking about this, but I guess it's not that better than 0,0,0)

> or
> 
> 	{PCI_VDEVICE(PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_20), 0},

Greg hates this macro, that's why I did not use this ;)
He once wrote:
GKH> The main reason I hate this [PCI_VDEVICE] macro, is that it now makes it 
GKH> almost  impossible to grep for any users of the PCI_VENDOR_DIGI pci
GKH> vendor id. I much prefer the PCI_DEVICE() macro instead, and as such, I'm 
GKH> not willing to take any of these patches, sorry.

> But I don't see the driver_data even being used anywhere, so then you
> could
> just simply say:
> 
> 	{PCI_DEVICE(PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_20)},

Good catch, it seems so, so  I'll create a v2

Peter

