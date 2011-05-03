Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab1ECVjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:39:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48875 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752886Ab1ECVjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:39:16 -0400
Date: Tue, 3 May 2011 22:39:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/23] intel_sst: Save audio state across D3 on Medfield
Message-ID: <20110503213925.GA7453@opensource.wolfsonmicro.com>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
 <20110503163128.24853.15446.stgit@bob.linux.org.uk>
 <20110503174254.GA6545@kroah.com>
 <20110503222903.4200a6bd@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503222903.4200a6bd@lxorguk.ukuu.org.uk>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 10:29:03PM +0100, Alan Cox wrote:

> I see the problem - Mark Brown took a patch in staging via the ASoC tree
> which clashes with this.

> fa880004682cf0d10e7a7c71dc8d56bbd67ac3d5

> which is not only a staging patch but also breaks compilation of the code
> because the sst_drv_ctx symbol isn't even exported or visible to the
> intelmid module, which suggests it wasn't even compile tested.

I am assured that this patch is essential to build with the Intel
drivers that are currently upstream in ASoC, though I've not personally
verified that.  I'd not be surprised if the tests whoever submitted it
did had only been done with the module built in, though I'd have
expected whatever tests people do on -next to pick that up since x86
seems to be a popular target there.

> In general we have a bigger problem here, the ASoC driver appears to be
> violating rule #1 of staging - nothing outside of staging should be using
> or depending upon staging code in the first place.

To recap the previous discussion: staging is just not in the slightest
bit viable for ASoC stuff, code that does anything non-trivial is going
to get broken between releases.  Especially with something like this
where the drivers are for unreleased hardware that has no current end
users it's just not a problem for the core if drivers do stuff like this
so long as they don't do anything visibly bad or cause problems for the
people who do build test whatever architecture is affected.
