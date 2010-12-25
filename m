Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab0LYOXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 09:23:40 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33526 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab0LYOXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 09:23:39 -0500
Date: Sat, 25 Dec 2010 14:23:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Daniel Drake <dsd@laptop.org>,
        Paul Fox <pgf@laptop.org>, linux-kernel@vger.kernel.org
Subject: Re: MFD cell structure and sharing of resources
Message-ID: <20101225142329.GA25641@sirena.org.uk>
References: <AANLkTinrF-dxiw7OQ=dMhQPgKSqS6yYfDzdcnHfhMtyf@mail.gmail.com> <20101216103550.GA5946@sortiz-mobl> <AANLkTi=ypose5day4=ypV8_SsiFq4vf9vqZh-OWret0x@mail.gmail.com> <20101224104518.GB27832@sortiz-mobl> <20101224224851.61942d75@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101224224851.61942d75@queued.net>
X-Cookie: To err is human, to forgive unusual.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 10:48:51PM -0800, Andres Salomon wrote:

> Having looked at the twl4030 driver, I do like that approach.  Is this
> something you want to see for cs5535 only, or are enough other mfd
> drivers doing this that you'd like the mfd framework itself to define
> hooks for cell/resource sharing?

This is extremely common - all the I2C/SPI attached embedded PMICs have
register access functions like this.  We have some factored out code for
this in ASoC but I'm not sure how worthwhile it is pulling that out into
something more generic as there's often a lot of special tweaks needed
for the register maps in PMICs (for things like locked registers),
though things like read/modify/write are quite common.
