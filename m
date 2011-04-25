Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab1DYOAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 10:00:50 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:48545 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754957Ab1DYOAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 10:00:49 -0400
Date: Mon, 25 Apr 2011 16:00:35 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: =?iso-8859-1?Q?Germ=E1n?= Sanchis <eaglecros@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: yenta cardbus problem
Message-ID: <20110425140035.GA27159@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	=?iso-8859-1?Q?Germ=E1n?= Sanchis <eaglecros@gmail.com>,
	linux-kernel@vger.kernel.org
References: <BANLkTinSOZH=9uD_9uXcVnH-1Yw5K-K3yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinSOZH=9uD_9uXcVnH-1Yw5K-K3yg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Apr 25, 2011 at 02:36:15PM +0200, Germán Sanchis wrote:
> In my old laptop I had a PCMCIA Creative SoundBlaster Audigy2 ZS
> notebook card in order to get my external speakers working. When I
> bought a new laptop, I found out that my old PCMCIA card did not fit
> in any hole any more... damn! So, I decided to buy a PCMCIA to
> ExpressCard adapter. Specifically, I bought DuelAdapter, but I don't
> seem to be able to get it working. It does work properly in the Vista
> installation my laptop has since I bought it, so a hardware problem is
> out of question. I have been doing quite a lot of googleing, but I am
> puzzled and don't know what the issue might be. Here a couple of
> things which I think could be related.

First of all, does passing "override_bios=1" as a module parameter
to the yenta_socket module help?

> lspci reports:
> ""
> ...
> 05:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200(A) PCI
> Express-to-PCI Bridge (rev 03)
> 06:00.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
> ""
> 
> (no sound card!)

What does "lspci -vvv" report?

> Note that the adapter has a switch, which is intended to be in
> "position A" for MacOS, and in "position B" for Windows XP (although
> my Vista system recognised it perfectly in position A). Under linux,
> lspci reports the above devices with the switch in A position, and in
> B the devices do not show up.

Could you send us a full "dmesg" with the switch in the A and one with the
switch in the B position, preferrably with ddebug_query="module yenta_socket +p"
added as boot parameter?

> In addition, yenta seems not to be very happy with the setup:
> 
> ""
> $ dmesg | grep yenta
> [   21.098659] yenta_cardbus 0000:05:00.0: No cardbus resource!
> ""

Was this with or without the "pci=assign-busses" parameter?

Best,
	Dominik
 
