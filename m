Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab1G2ODq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 10:03:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34525 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755541Ab1G2ODp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:03:45 -0400
Date: Fri, 29 Jul 2011 15:03:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] regulator: tps65023: Added support for the similiar
 TPS65020 chip
Message-ID: <20110729140342.GB19118@opensource.wolfsonmicro.com>
References: <marcus.folkesson@gmail.com>
 <1311762767-20263-1-git-send-email-marcus.folkesson@gmail.com>
 <1311762767-20263-4-git-send-email-marcus.folkesson@gmail.com>
 <20110729123420.GB22042@sirena.org.uk>
 <CAM8FrKL4-hn2rrazsCLrRoVY5zVkgR8A245ScfS48=O41jtffg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM8FrKL4-hn2rrazsCLrRoVY5zVkgR8A245ScfS48=O41jtffg@mail.gmail.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 03:08:54PM +0200, Marcus Folkesson wrote:
> 2011/7/29 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> > On Wed, Jul 27, 2011 at 12:32:47PM +0200, Marcus Folkesson wrote:

> >> +static struct tps_driver_data tps65020_drv_data = {
> >> +             .info = (struct tps_info *) tps65020_regs,

> > Why do you need the cast here?  I see it's in the original driver too
> > but it looks like something that should be fixed.

> I also thought about the line, It's only for avoiding warnings from gcc.
> But I don't really understand why gcc is warning.

> gcc output:  "warning: initialization discards qualifiers from pointer
> target type".

It's complaining because the declaration of tps65020_regs doesn't match
up with that of .info.  Probably the struct member needs to be a const
pointer.
