Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab0JFFI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 01:08:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46110 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab0JFFI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 01:08:28 -0400
Date: Wed, 6 Oct 2010 06:08:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Igor Grinberg <grinberg@compulab.co.il>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Walleij <linus.ml.walleij@gmail.com>
Subject: Re: [PATCH] regulator: Add option for machine drivers to enable
	the dummy regulator
Message-ID: <20101006050825.GA17998@sirena.org.uk>
References: <1286331512-4608-1-git-send-email-broonie@opensource.wolfsonmicro.com> <201010060609.17412.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010060609.17412.marek.vasut@gmail.com>
X-Cookie: Yow!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 06:09:17AM +0200, Marek Vasut wrote:

> This still solves nothing ... This leaves boards broken and the granularity is 
We've already got a compatibility option which allows this to be enabled
with a config change, and the actual code update required has been
reduced to a single line.  This does not seem terribly onerous.

> too big. Consider there are boards that use regulator for MMC, but not for 
> ADS7846 for example.

You can't have it both ways.  Either drivers just ignore missing
regulators and just run as though everything is fine (which is what
you've been requesting enthusiastically) or they trust that they can get
accurate information about what is and isn't mapped.  All this is doing
is providing a way to enable the former behaviour in the core.
