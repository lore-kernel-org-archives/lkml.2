Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab0IOOIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 10:08:55 -0400
Received: from void.printf.net ([89.145.121.20]:54706 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab0IOOIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 10:08:54 -0400
Date: Wed, 15 Sep 2010 15:08:40 +0100
From: Chris Ball <cjb@laptop.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Ben Nizette <bn@niasdigital.com>, linux-mmc@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH] mmc: Reduce fOD to 200 kHz if possible
Message-ID: <20100915140840.GB1677@void.printf.net>
References: <1284541140-7328-1-git-send-email-haavard.skinnemoen@atmel.com> <9348108E-1108-46FE-8437-6F1271025C61@niasdigital.com> <20100915125138.1f25e4b1@hskinnemoen-d830>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100915125138.1f25e4b1@hskinnemoen-d830>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haavard,

On Wed, Sep 15, 2010 at 12:51:38PM +0200, Haavard Skinnemoen wrote:
> Thanks for the references. IMO Hein's patch is overkill. There is
> absolutely no reason why 200 kHz should be a problem on any setup, and
> I haven't found any indication in any discussions that it is.

Pierre was worried that we'd ping-pong between having an f_min too high
for some cards and too low for others, and be breaking a new set of
cards each time we changed the value.  He may have been being overly
pessimistic, but I don't think being cautious comes with any significant
downsides here.

There's also a (small) performance concern when f_min gets low, though
I agree that it wouldn't be a problem at 200 kHz.

> The reason why fOD was set to 400 kHz in the first place is that some
> controllers have a very low f_min so running the initialization at that
> frequency causes problems. Which makes sense because the SD standard
> clearly says that the clock can't be slower than 100 kHz.
> 
> But I have never seen any reasons why we absolutely _have_ to run the
> clock at the maximum frequency allowed by the spec. In fact, Sascha
> Hauer, who was the one who changed the minimum clock frequency to 400
> kHz, said he would be fine with any frequency between 50 kHz and 400
> kHz [1].

I agree that we aren't trying to run at the maximum possible frequency,
just trying to avoid having to choose a single perfect value without
enough information on what it is.

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
