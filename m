Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab1JCMxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 08:53:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35943 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab1JCMxi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 08:53:38 -0400
MIME-Version: 1.0
In-Reply-To: <20111003124044.GF3731@opensource.wolfsonmicro.com>
References: <20110927182636.GR4289@opensource.wolfsonmicro.com>
	<CAMLZHHR0rMZct2E91X8k+Lhv_y-pY_5+vshZw6dj194o9vSCJQ@mail.gmail.com>
	<20110927183832.GS4289@opensource.wolfsonmicro.com>
	<CAMLZHHRvr-diYGwZ2Kg647Ht7NNb8LEku0pCW8EujRuUeOW5yQ@mail.gmail.com>
	<20110928123154.GG3279@opensource.wolfsonmicro.com>
	<CAMLZHHRFY_MazF_MOzPrS06z-48-ohORTtbANMxUT=mjevXhhQ@mail.gmail.com>
	<20111003102846.GA23811@sirena.org.uk>
	<CAMLZHHTMP+DJA35bUswXPbTv_U0DAWY_h_-Eg53-_4RuC3bx7A@mail.gmail.com>
	<20111003121655.GB3731@opensource.wolfsonmicro.com>
	<CAMLZHHS+fFzuWtwOwt-g2y38g93uaZFyUGsooZyYLMT=mdWQFQ@mail.gmail.com>
	<20111003124044.GF3731@opensource.wolfsonmicro.com>
Date: Mon, 3 Oct 2011 13:53:37 +0100
X-Google-Sender-Auth: QPdDY3kZoUnKbvuJy1jeW-YRjDc
Message-ID: <CAMLZHHQMf7hOnDb+SNvH7qFmbA+rypJ_p7SJw64ZqtG3xq+GMg@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: allow mfd_cell association with device tree node
From: Daniel Drake <dsd@laptop.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 1:40 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> So, I made two suggestions above and it sounds like you want the second
> one but you've only responded to the first one without commenting on the
> second.  My second suggestion was that if the block is sufficiently
> isoltated from the core we should be able instantiate it from the device
> tree without requiring explicit code in the core driver.

Sorry, hadn't quite grasped what you meant there. I understand now.

It is an interesting idea but leaves me with some questions/problems:

The GPIO controller needs to find its register space by looking at the
PCI device (the ISA bridge). So probing it independently could maybe
be viewed by some as a hierarchy violation as it would have to then
hunt around for its PCI dev.

According to Grant's hard rule, the parent device needs to be the
thing that passes the of_node to the child.
So we would still need a driver for the parent ISA bridge
instantiating the child GPIO controller. Wouldn't that bring us
straight back to the same problem (that the "core" needs code to
instantiate the child)?

Also, not an argument against the direction, but an outstanding
problem that would need to be resolved: the x86 device tree
implementation doesn't seem to follow Grant's design for how things
should work (or maybe I misunderstood something), so work would be
needed there first. See the unfinished discussion at
http://lists.ozlabs.org/pipermail/devicetree-discuss/2011-July/006853.html

Thanks,
Daniel
