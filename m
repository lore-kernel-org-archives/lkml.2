Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab1CNOyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 10:54:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51138 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1CNOyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 10:54:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: RFC: Platform data for onboard USB assets
Date: Mon, 14 Mar 2011 15:54:28 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: andy.green@linaro.org, Andy Green <andy@warmcat.com>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <4D79F068.2080009@linaro.org> <AANLkTi=+6cp=F1ZDiH1vFwqvseU-Punwpq99P1j-U4Q1@mail.gmail.com>
In-Reply-To: <AANLkTi=+6cp=F1ZDiH1vFwqvseU-Punwpq99P1j-U4Q1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103141554.28515.arnd@arndb.de>
X-Provags-ID: V02:K0:1gg+RXoJfupa3BkwPHyi2gwrgS/GIZFH7FZOqLxaJ/0
 i8oxYp7dU+/FtCEjBhpwrDfnBaruefoOXU00pqMjoA3Ys1rf1C
 ZjSqrnb0qs/aPOsZPRgVwgftDlIxV7dZh2de3418hWB/XCTK2z
 qJnQzzjojs0c5N3/bY/1eoliSOMJdF0rL4CqbjNKfmFP1+otg/
 QmXIqrranu8XcsCdma5qA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 March 2011, Grant Likely wrote:
> On Fri, Mar 11, 2011 at 2:50 AM, Andy Green <andy@warmcat.com> wrote:
> > Hi -
> >
> > platform_data is a well established way in Linux to pass configuration data
> > up to on-board assets from a machine file like mach-xyz.c.  It's also
> > supported to pass platform_data up to devices that are probed asynchronously
> > from busses like i2c as well, which is very handy.
> >
> > However AFAIK it's not possible to bind platform_data to probed USB devices
> > as it stands.
> 
> Oh, please no.
> 
> platform_data is an ugly non-type-checked anonymous pointer.  If you
> need to pass data to a driver, use something better designed.  A
> device tree fragment would work, or provide some kind of query api.
> platform_data is definitely the wrong approach.

I'd still hope that we could do without either for hotpluggable
devices, but a device tree object fits better here, because
we already have ways to associate the data in the device node
with any device, not just platform devices, and the key/value
pairs make it much more flexible than platform data.

	Arnd
