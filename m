Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab2HFXTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 19:19:40 -0400
Received: from gloria.sntech.de ([95.129.55.99]:41755 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab2HFXTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 19:19:39 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: regulator: Policy for setting current limits
Date: Tue, 7 Aug 2012 01:19:34 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Axel Lin <axel.lin@gmail.com>
References: <201208060127.57074.heiko@sntech.de> <20120806115632.GB16861@opensource.wolfsonmicro.com>
In-Reply-To: <20120806115632.GB16861@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201208070119.35129.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 6. August 2012, 13:56:33 schrieb Mark Brown:
> On Mon, Aug 06, 2012 at 01:27:56AM +0200, Heiko Stübner wrote:
> > 500). Therefore if 500mA are the upper limit but the regulator also
> > supports lower values, these lower values always get selected (100mA in
> > my case). In contrast pda_power sets the target current as both lower
> > and upper limit.
> 
> This isn't good, it means that the regulator has to be able to deliver
> exactly the limit requested.
> 
> > (a) let the gpio-regulator select the max current (in contrast to the
> > minimum voltage)
> > (b) change gpio-vbus to also use the target current as min and max value
> > (c) something else
> 
> Regulators should be tending to the maximum in the available range and
> consumers should specify the widest range possible so both a and b.

Is this true for all regulators (i.e. voltage and currency regulators)?

Because 4dbd8f63f07a (regulator: gpio-regulator: Set the smallest 
voltage/current in the specified range) implemented the exact oposite.

Thanks
Heiko
