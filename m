Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab0ICRug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 13:50:36 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64070 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab0ICRuf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 13:50:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xQ35QxXv/IAyUs+baQyuFZdhwDP9Tf93AV1Xmbi3AizHWeINNoMZUQtygQurudSZ/3
         rNWrY0PwPYgN2bMHBLEmmsl9vcIRGJ8UuaqfgcSZwqOx1yi/uV4fHgkEQR7MBfx8Uhcz
         +1wR01dHHBL5e1kNrrk6dGd/SrAAJ00GRxHHQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTinYypWdty1eLH1LTyOEZPt-k=cEDGu_coyWVa2t@mail.gmail.com>
References: <4C80E2D5.1020104@dsn.okisemi.com>
	<AANLkTinYypWdty1eLH1LTyOEZPt-k=cEDGu_coyWVa2t@mail.gmail.com>
Date: Fri, 3 Sep 2010 19:50:33 +0200
Message-ID: <AANLkTinpLeJzYjAh2bUngWD4ZvOyy44t9+4Zs9rm2=xQ@mail.gmail.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: meego-dev@meego.com, LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com, gregkh@suse.de,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/3 Grant Likely <grant.likely@secretlab.ca>:
> 2010/9/3 Masayuki Ohtak <masa-korg@dsn.okisemi.com>:
>> SPI driver of Topcliff PCH

> Instead, the majority of the code should be structured to handle one
> and only one spi bus instance.  Only at the top level pci probe,
> remove and PM code should there be for() loops for setting up or
> tearing down each spi bus instance one at a time.

I guess an elegant way to achieve this is to have the
PCI driver spawn a simple platform device for each bus.
Then you can even break the driver for that platform device
into its own file and all.

In the MFDs we spawn child platform devices all the time,
it's great fun!

Yours,
Linus Walleij
