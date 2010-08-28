Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab0H1Qaw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:30:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65109 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab0H1Qau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=LeBRlF1vcH1C3knlIkMd4vI/hNRx4Mh2q19v49WZneZuFHekBnOIhUX2RfaLZe2A7z
         NIHMs4ZD97BZhRM49CPdFzoan0C8RLUgrmBcpL9JqDYXOdmlyBoXlbOy9x7CQinQOBe2
         F5aW80gVIPOqqvCR85FbVd74aa5QK8VcO2sko=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 3/3 v2] dmaengine: Add Freescale i.MX SDMA support
Date: Sat, 28 Aug 2010 18:30:05 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        "Uwe =?iso-8859-15?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de> <201008281727.10913.marek.vasut@gmail.com> <20100828161858.GI1473@pengutronix.de>
In-Reply-To: <20100828161858.GI1473@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008281830.05208.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne So 28. srpna 2010 18:18:58 Sascha Hauer napsal(a):
> On Sat, Aug 28, 2010 at 05:27:10PM +0200, Marek Vasut wrote:
> > Dne So 28. srpna 2010 17:18:17 Linus Walleij napsal(a):
> > > 2010/8/23 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> > > >> +     evt = readl(SDMA_H_EVTOVR);
> > > >> +     mcu = readl(SDMA_H_HOSTOVR);
> > > >> +     dsp = readl(SDMA_H_DSPOVR);
> > > > 
> > > > __raw_readl?
> > > 
> > > Sorry I never understood this __raw_[read|write][b|w|l] vs.
> > > plain read[b|w|l] proliferation in some drivers and code.
> > > 
> > > What's the reason for?
> > 
> > Hey,
> > 
> > this trick is, if you create the VA<->PA mapping at the kernel start (eg.
> > see how pxa_map_io() is replacedon some devices for instance), you then
> > use the VA address you specified and use __raw_{read,write}[b,w,l](). So
> > use __raw_{read,write}[b,w,l]() on drivers specific for certain device
> > and use {read,write}[b,w,l]() on ioremap()ed memory areas, aka. in
> > common drivers.
> 
> Nope, this has nothing to do with static mappings vs. ioremap. The
> difference is that read[b,w,l] do little endian accesses suitable for
> PCI whereas the __raw_* functions do accesses in CPU endianess.
> Peripherals integrated into a SoC like the SDMA engine here are
> normally accessible in native endianess and thus need the __raw_*
> functions. An external network controller (for example a LAN9117) will
> probably need the non raw functions. Note that 99% of the arm users use
> little endian only and thus cpu_to_le* is a noop, so both types will work
> for most people.

Sorry, you got me here. Why do we have io{read,write} then btw. ? That's for 
x86's io space, right ?

Thanks, cheers and sorry for the confusion
> 
> Sascha
