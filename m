Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab1LGQLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:11:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60319 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756107Ab1LGQLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:11:36 -0500
Date: Thu, 8 Dec 2011 00:10:59 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, HoP <jpetrous@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
Message-ID: <20111207161058.GC22355@opensource.wolfsonmicro.com>
References: <4EDC9B17.2080701@gmail.com>
 <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com>
 <4EDD01BA.40208@redhat.com>
 <4EDD2C82.7040804@linuxtv.org>
 <20111206112153.GC17194@sirena.org.uk>
 <4EDE0427.2050307@linuxtv.org>
 <20111206141929.GE17731@opensource.wolfsonmicro.com>
 <4EDE2B3B.2080905@linuxtv.org>
 <20111207134848.GB18837@opensource.wolfsonmicro.com>
 <4EDF71AE.5070509@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDF71AE.5070509@linuxtv.org>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 03:01:18PM +0100, Andreas Oberritter wrote:

> Once and for all: We have *not* discussed a generic video streaming
> application. It's only, I repeat, only about accessing a remote DVB API
> tuner *as if it was local*. No data received from a satellite, cable or
> terrestrial DVB network shall be modified by this application!

> Virtually *every* user of it will use it in a LAN.

> It can't be so hard to understand.

You're talking about a purely software defined thing that goes in the
kernel - it pretty much has to be able to scale to other applications
even if some of the implementation is left for later.  Once things like
this get included in the kernel they become part of the ABI and having
multiple specific things ends up being a recipie for confusion as users
have to work out which of the options is most appropriate for their
application.

Really this feels like the pattern we've got with audio where we
restrict the drivers to driving hardware and there's a userspace which
wraps that and can also dispatch to a userspace implementation without
applications worrying about it.  Perhaps given the current entirely in
kernel implementation a simple loopback in the style of FUSE which
bounces the kernel APIs up to userspace for virtual drivers would make
sense.
