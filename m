Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab1JMK0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:26:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50077 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab1JMK0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:26:05 -0400
Date: Thu, 13 Oct 2011 11:26:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        alsa-devel <alsa-devel@alsa-project.org>, lrg@ti.com,
        kuninori.morimoto.gx@renesas.com,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [alsa-devel] [PATCH 7/9] ASoC: da7210: Add support for ALC and
 Noise suppression
Message-ID: <20111013102602.GH1098@sirena.org.uk>
References: <1318432070.12107.426.camel@matrix>
 <20111012150404.GT3647@opensource.wolfsonmicro.com>
 <1318497345.12107.443.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318497345.12107.443.camel@matrix>
X-Cookie: Drilling for oil is boring.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 02:45:45PM +0530, Ashish Chavan wrote:
> On Wed, 2011-10-12 at 16:04 +0100, Mark Brown wrote:

> > No, don't go peering directly into the register cache.  This is going to
> > explode if the board configures a different cache style and means you
> > can't change the cache type later.  Just read the register and trust
> > that the cache will do something sane.

> Will update the code to directly read the register. I thought of saving
> some io bandwidth and if I remember correctly, I saw few exiting drivers
> doing this.

The whole point of having the register cache is that reads don't result
in any actual I/O, if there's any I/O happening we need to fix the
register cache code.
