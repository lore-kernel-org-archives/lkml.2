Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab2HaVbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 17:31:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43897 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755089Ab2HaVbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 17:31:08 -0400
Date: Fri, 31 Aug 2012 14:31:04 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: ams-delta: fix card initalization
 failure
Message-ID: <20120831213103.GC5495@opensource.wolfsonmicro.com>
References: <1346102910-8610-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <3048168.EXxi4fR4e7@acer>
 <20120828181338.GB8796@opensource.wolfsonmicro.com>
 <1809544.cvZPIRmRr5@acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1809544.cvZPIRmRr5@acer>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 07:04:48AM +0200, Janusz Krzysztofik wrote:
> On Tue, 28 Aug 2012 11:13:39 Mark Brown wrote:

> > The above looks like you already have a platform driver?  All I'm
> > suggesting is changing the above to use platform rather than driver
> > data.

> The ams-delta asoc driver doesn't use snd_soc_register_card() so far, 
> but relays solely on soc_probe() doing this for it, which in turn 
> expects to find a snc_soc_card structure in drvdata. How is it supposed 
> to find that structure if I pass it over platform data instead? Am I 
> missing something?

s/drvdata/platdata/ in the code.  If you can't do this then just
referencing the data directly in the code would be better than this
bodge, it'd be much less fragile.
