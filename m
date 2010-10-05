Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab0JETKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:10:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44735 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751822Ab0JETKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:10:47 -0400
Date: Tue, 5 Oct 2010 20:35:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-arm-kernel@lists.infradead.org, vapier@gentoo.org,
        khilman@deeprootsystems.com, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2] Input: Make ADS7846 independent on regulator
Message-ID: <20101005203508.7df590db@lxorguk.ukuu.org.uk>
In-Reply-To: <20101005185942.GA22808@opensource.wolfsonmicro.com>
References: <1280560182-7071-1-git-send-email-marek.vasut@gmail.com>
	<4C862EB3.4080006@compulab.co.il>
	<20100907125335.GD25830@sirena.org.uk>
	<201009091027.18176.marek.vasut@gmail.com>
	<20100909094120.GB1988@rakim.wolfsonmicro.main>
	<4CAACA63.6090202@compulab.co.il>
	<20101005161608.GD19730@core.coreip.homeip.net>
	<20101005164037.GA20555@opensource.wolfsonmicro.com>
	<20101005180703.GD21399@core.coreip.homeip.net>
	<20101005185942.GA22808@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the board doesn't use regulators you can just disable the regulator
> API at which point it compiles out into stubs which report success -
> this has been the case from day one.  There's only an issue if the board
> has a regulator configuration which is partially visible to software.

Which is quite likely on anything complex and means that hardcoding
regulator assumptions is bad.

I actually see two ways of attacking that, one is that the dummy
regulator *and* the compiled in regulator system have a standard
regulator value that can be passed which means "report success, move
along nothing to see" that could be passed into drivers, the other is to
not stick the stuff in drivers.

I suspect the former may be cleaner ?

Alan
