Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab0JEIVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:21:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35059 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924Ab0JEIVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:21:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=kjhRlmEjIkQoIiF5UX5zOfXs58Ck9eYyOwQtlxTfZbewH1hMHeo33lTVFxrwmCmvCw
         qRMZAukpQYclhIBFGEp2ACwpPSk4JK7HnlzNJEE9vjar9gVPHZ2lPgZDz387BrYiEwMz
         z7ONrgOHGHSgN3VRHV24sgnRygxqFhm8EP7Es=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Igor Grinberg <grinberg@compulab.co.il>
Subject: Re: [PATCH v2] Input: Make ADS7846 independent on regulator
Date: Tue, 5 Oct 2010 10:21:30 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, vapier@gentoo.org,
        khilman@deeprootsystems.com, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, pavel@ucw.cz,
        linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
References: <1280560182-7071-1-git-send-email-marek.vasut@gmail.com> <20100909094120.GB1988@rakim.wolfsonmicro.main> <4CAACA63.6090202@compulab.co.il>
In-Reply-To: <4CAACA63.6090202@compulab.co.il>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010051021.30496.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Út 5. října 2010 08:49:07 Igor Grinberg napsal(a):
>  On 09/09/10 12:41, Mark Brown wrote:
> > On Thu, Sep 09, 2010 at 10:27:17AM +0200, Marek Vasut wrote:
> >> Dne Út 7. září 2010 14:53:35 Mark Brown napsal(a):
> >>> From a regulator API usage point of view a separate implementation of
> >>> the same thing was nacked - there are regulator API facilties for
> >>> hiding missing regulators from drivers when needed to get systems
> >>> going, unless the device genuinely can cope without supplies it should
> >>> be relying on those.
> 
> I actually, don't see why ads7846 is strictly relying on the regulator
> and I don't understand, why ads7846 driver has to bail out if the regulator
> is not found? Why shouldn't the driver try to continue?
> I think it should bail out only in case communicating with the device
> failed.

Well, I can't but agree ... it's unnecessary crud indeed.
> 
> >> Maybe these platforms should have been fixed prior to applying the patch
> >> adding regulator goo into ads7846 driver then. What's the way to go now
> >> then ?
> > 
> > Fix the platforms and use the dummy regulators to keep them going until
> > that happens.  It's trivial to do the hookup in the platforms.
> 
> You want each platform, that does not have a special regulated power supply
> for the ads7846, to define a dummy regulator just to cope with that
> artificial dependency of the device driver?

You can enable some option in the regulator stuff that automagically shoves in a 
dummy regulator, but it's still additional crud.

> I think it is a waste and big code duplication in each platform
> that does not have that special regulator.

Indeed
