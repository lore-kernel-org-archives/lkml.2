Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab1KDV5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 17:57:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45308 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520Ab1KDV5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 17:57:36 -0400
Date: Fri, 4 Nov 2011 21:57:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Olof Johansson <olof@lixom.net>
Cc: Rajendra Nayak <rnayak@ti.com>, grant.likely@secretlab.ca,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/4] regulator: adapt fixed regulator driver to dt
Message-ID: <20111104215733.GD8266@opensource.wolfsonmicro.com>
References: <1319702185-16108-1-git-send-email-rnayak@ti.com>
 <1319702185-16108-3-git-send-email-rnayak@ti.com>
 <20111104203422.GB3918@quad.lixom.net>
 <20111104210151.GA2541@opensource.wolfsonmicro.com>
 <20111104211824.GA5608@quad.lixom.net>
 <20111104212538.GA8266@opensource.wolfsonmicro.com>
 <CAOesGMh2_C+yx=_5PjqoKxZmAMvx-puRjq45s+G2kz2EaEEtqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOesGMh2_C+yx=_5PjqoKxZmAMvx-puRjq45s+G2kz2EaEEtqw@mail.gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 02:47:05PM -0700, Olof Johansson wrote:
> On Fri, Nov 4, 2011 at 2:25 PM, Mark Brown

> > I don't see how you can usefully do that, the task of plumbing a
> > regulator into a board is largely orthogonal to the specific feature set
> > of a given regulator.  The specific bindings for a fixed voltage
> > regulator would be useful or unhelpful for most regultors controlled via
> > I2C.

> I meant more that the fixed regulators should reuse as much as
> possible from the generic regulator bindings, instead of completely
> forking them.

That appears to be what's going on?  The fixed voltage regulator
includes by reference the core regulator binding, all of the properties
it defines with the possible exception of the supply name are not
covered in the core binding.

> Then, depending on how they are controlled, there will be more
> specific bindings. So the case of a gpio-controlled fixed regulator
> would have a binding where the format of the properties to find the
> gpio, etc, would be described. But things like voltage (without a
> range, obviously) would be using the same bindings as the other
> regulators.

The only overlap I'm seeing is the voltage?  

The intended semantic for the voltage is rather different.  The core
binding for the voltage specifies the range of voltages it is possible
to set a regulator to on a given board and is used to give permission to
the system to reconfigure the regulator.  The binding here tells the
system what voltage a fixed voltage regulator is running at.  We could
have the fixed voltage regulator read the same binding - though there's
some risk of mild confusion it shouldn't be too bad.
