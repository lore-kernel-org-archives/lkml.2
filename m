Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab0JEQQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:16:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49714 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab0JEQQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=nykcWSsHOEOAgUA7qpghGWdWPL53+8h6fk/9SsGOKohA6sVWK5CxQxxp1gNuM4/Plx
         iELWICt77A7zp9r9AEVEFPwI3Cg5BXL1Bjm8vENhzYM9ecKQ4gEinceOCc30ymjCMcjr
         O9mt2HljjRtS+TrHQVIcJb+BqJ9yyR5RSyZx8=
Date: Tue, 5 Oct 2010 09:16:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-arm-kernel@lists.infradead.org, vapier@gentoo.org,
        khilman@deeprootsystems.com, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2] Input: Make ADS7846 independent on regulator
Message-ID: <20101005161608.GD19730@core.coreip.homeip.net>
References: <1280560182-7071-1-git-send-email-marek.vasut@gmail.com>
 <4C862EB3.4080006@compulab.co.il>
 <20100907125335.GD25830@sirena.org.uk>
 <201009091027.18176.marek.vasut@gmail.com>
 <20100909094120.GB1988@rakim.wolfsonmicro.main>
 <4CAACA63.6090202@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CAACA63.6090202@compulab.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 08:49:07AM +0200, Igor Grinberg wrote:
>  On 09/09/10 12:41, Mark Brown wrote:
> > On Thu, Sep 09, 2010 at 10:27:17AM +0200, Marek Vasut wrote:
> >> Dne Út 7. září 2010 14:53:35 Mark Brown napsal(a):
> >>> From a regulator API usage point of view a separate implementation of
> >>> the same thing was nacked - there are regulator API facilties for hiding
> >>> missing regulators from drivers when needed to get systems going, unless
> >>> the device genuinely can cope without supplies it should be relying on
> >>> those.
> 
> I actually, don't see why ads7846 is strictly relying on the regulator
> and I don't understand, why ads7846 driver has to bail out if the regulator
> is not found? Why shouldn't the driver try to continue?
> I think it should bail out only in case communicating with the device failed.
> 
> >> Maybe these platforms should have been fixed prior to applying the patch adding 
> >> regulator goo into ads7846 driver then. What's the way to go now then ?
> > Fix the platforms and use the dummy regulators to keep them going until
> > that happens.  It's trivial to do the hookup in the platforms.
> 
> You want each platform, that does not have a special regulated power supply
> for the ads7846, to define a dummy regulator just to cope with that artificial
> dependency of the device driver?
> I think it is a waste and big code duplication in each platform
> that does not have that special regulator.
>

I tend to agree, however I think that original patch that simply ignored
failures from regulator_get() is not the best option either. Can we have
a flag in platform data indicating that the board does not employ a
regulator? Then we could retain the hard failure in cases when we expect
regulator to be present while allowing to continue on boards that do not
have it.

-- 
Dmitry
