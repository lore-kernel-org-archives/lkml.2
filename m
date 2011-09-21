Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab1IUMje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 08:39:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50039 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753633Ab1IUMjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 08:39:33 -0400
Date: Wed, 21 Sep 2011 13:39:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: =?iso-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: Re: Re: [PATCH 07/17] ASoC: twl6040: Lower the initial gains
Message-ID: <20110921123931.GD4374@opensource.wolfsonmicro.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
 <2033664.fWQvF2IA53@barack>
 <20110919114031.GI23727@opensource.wolfsonmicro.com>
 <2240573.6cRWXtKJB6@barack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2240573.6cRWXtKJB6@barack>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 12:22:26PM +0300, Péter Ujfalusi wrote:

> The implementation in twl6040 looks similar to the one in the wm8350 in 
> regards to the ramp code, and caching of the user configured gains.

Yes, it was copied from there.

> If you take a look at the wm8350 driver it is also changing the L/R OUT 1/2 
> registers at probe time.
> I don't see any difference in the two.

The key problem here is that you sent a change saying "change the
default volume" with no other context in either the changelog or the
code.  If you've got code that's actively managing the volume register
while presenting a nice view to the application layer so that the
register value isn't directly seen in the way it is for standard ASoC
controls that's a very different thing to standard code.  I'm not going
to remember the details of everything in every CODEC driver.

> We do have other scenarios covered, but this initialization was missing. This 
> resulted that the _first_ playback has pop noise, but all subsequent playbacks 
> were fine, since we had the runtime fix for this.

So what you're doing here is really a bug fix for the ramping code.
