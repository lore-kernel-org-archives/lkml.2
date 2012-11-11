Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab2KKUrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 15:47:20 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:60744 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2KKUrT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 15:47:19 -0500
Date: Sun, 11 Nov 2012 14:47:13 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
In-Reply-To: <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com>
	(from grant.likely@secretlab.ca on Fri Nov  9 10:28:59 2012)
X-Mailer: Balsa 2.4.11
Message-Id: <1352666833.20434.5@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

               On 11/09/2012 10:28:59 AM, Grant Likely wrote:
> On Tue, Nov 6, 2012 at 10:37 PM, Stephen Warren  
> <swarren@wwwdotorg.org> wrote:
> > On 11/05/2012 01:40 PM, Grant Likely wrote:
> I'm not actually opposed to it, but it needs to be done in an elegant
> way. The DT data model already imposes more of a conceptual learning
> curve than I wish it did and I don't want to make that worse with a
> versioning model that is difficult to get ones head around.

Speaking of which...

I want to poke at board emulation in qemu, from scratch. Specifically,  
I want to start with an unpopulated board (just the processor), add a  
block of physical memory and a serial device, and boot an initramfs in  
there with stdin/stdout. Then I want to incrementally add an RTC,  
network card, and three block devices.

I'd like to define this board by giving qemu and the kernel the same  
device tree they can parse, and I'd like to _build_ this device tree so  
I understand what's in it. I'd like to repeat this exercize for arm,  
mips, ppc, x86, x86-64, sparc, sh4, and maybe other boards.

And I'd like to write up an article on doing it as a learning exercise.

Last time I checked, doing this wasn't possible. (qemu couldn't define  
a board by parsing a device tree, the kernel used the device tree as a  
guideline but it only really read data the drivers you linked in were  
expecting, the only documentation about what any of the nodes were was  
was read the other device trees as examples or read the source code of  
the drivers looking for data in the tree...)

Is it a more realistic project now? If so, where would I start? (Once  
upon a time I read the booting-without-of document, back when it lived  
in the ppc directory. It didn't really say what should go in any of the  
nodes.)

Rob