Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab0JEGtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 02:49:24 -0400
Received: from compulab.co.il ([67.18.134.219]:34003 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab0JEGtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 02:49:22 -0400
Message-ID: <4CAACA63.6090202@compulab.co.il>
Date: Tue, 05 Oct 2010 08:49:07 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.7) Gecko/20100816 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Marek Vasut <marek.vasut@gmail.com>, linux-arm-kernel@lists.infradead.org,
        vapier@gentoo.org, khilman@deeprootsystems.com,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org, pavel@ucw.cz,
        linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2] Input: Make ADS7846 independent on regulator
References: <1280560182-7071-1-git-send-email-marek.vasut@gmail.com> <4C862EB3.4080006@compulab.co.il> <20100907125335.GD25830@sirena.org.uk> <201009091027.18176.marek.vasut@gmail.com> <20100909094120.GB1988@rakim.wolfsonmicro.main>
In-Reply-To: <20100909094120.GB1988@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 09/09/10 12:41, Mark Brown wrote:
> On Thu, Sep 09, 2010 at 10:27:17AM +0200, Marek Vasut wrote:
>> Dne Út 7. září 2010 14:53:35 Mark Brown napsal(a):
>>> From a regulator API usage point of view a separate implementation of
>>> the same thing was nacked - there are regulator API facilties for hiding
>>> missing regulators from drivers when needed to get systems going, unless
>>> the device genuinely can cope without supplies it should be relying on
>>> those.

I actually, don't see why ads7846 is strictly relying on the regulator
and I don't understand, why ads7846 driver has to bail out if the regulator
is not found? Why shouldn't the driver try to continue?
I think it should bail out only in case communicating with the device failed.

>> Maybe these platforms should have been fixed prior to applying the patch adding 
>> regulator goo into ads7846 driver then. What's the way to go now then ?
> Fix the platforms and use the dummy regulators to keep them going until
> that happens.  It's trivial to do the hookup in the platforms.

You want each platform, that does not have a special regulated power supply
for the ads7846, to define a dummy regulator just to cope with that artificial
dependency of the device driver?
I think it is a waste and big code duplication in each platform
that does not have that special regulator.

-- 
Regards,
Igor.

