Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab1JCKjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 06:39:55 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64381 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab1JCKjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 06:39:49 -0400
MIME-Version: 1.0
In-Reply-To: <20111003102846.GA23811@sirena.org.uk>
References: <20110927150555.GF20588@ponder.secretlab.ca>
	<CAMLZHHQU-eMAtvBQJj6+WrMjkWWA+ET=z5NdQCEgXxh=m10d3Q@mail.gmail.com>
	<20110927181420.GQ4289@opensource.wolfsonmicro.com>
	<CAMLZHHSuoeAJ-AC9daxb83+EANV=YGK-aiYpQ_j2wFiyQa5ytw@mail.gmail.com>
	<20110927182636.GR4289@opensource.wolfsonmicro.com>
	<CAMLZHHR0rMZct2E91X8k+Lhv_y-pY_5+vshZw6dj194o9vSCJQ@mail.gmail.com>
	<20110927183832.GS4289@opensource.wolfsonmicro.com>
	<CAMLZHHRvr-diYGwZ2Kg647Ht7NNb8LEku0pCW8EujRuUeOW5yQ@mail.gmail.com>
	<20110928123154.GG3279@opensource.wolfsonmicro.com>
	<CAMLZHHRFY_MazF_MOzPrS06z-48-ohORTtbANMxUT=mjevXhhQ@mail.gmail.com>
	<20111003102846.GA23811@sirena.org.uk>
Date: Mon, 3 Oct 2011 11:39:47 +0100
X-Google-Sender-Auth: tOF5ZpmbkIFqQ4CyOVLk6mVXz2g
Message-ID: <CAMLZHHTMP+DJA35bUswXPbTv_U0DAWY_h_-Eg53-_4RuC3bx7A@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: allow mfd_cell association with device tree node
From: Daniel Drake <dsd@laptop.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 11:28 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> I'd really expect that if we're adding stuff to the framework then it
> should be suitable for random drivers to use.

It is suitable. If other drivers would otherwise run into the data
reuse problem you have described, they can use the kmemdup solution
you have described.

> To be honest I don't
> really understand why you're changing the framework at all here, the
> child driver is entirely specific to the parent as far as I can see.

Because I'm trying to get devicetree-driven HDD LED support driven,
and Grant stated that doing it this way is a hard rule:

"What is a hard rule is that the code creating the children needs to
know what the binding is and populate the child's of_node
appropriately."

I also confirmed that extending the mfd_cell layer is exactly what
Grant was suggesting:
http://lists.ozlabs.org/pipermail/devicetree-discuss/2011-September/008480.html

And Grant is undoubtedly a source of authority on device tree
implementation stuff.

So I seem to be stuck between two people giving me conflicting
requirements for merge of my work (which commenced in July, and has
already seen several discussions and rounds of patches). Any help
appreciated - I'm just trying to make a HDD LED blink.

Thanks,
Daniel
