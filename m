Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239Ab1LFLV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:21:57 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60642 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab1LFLV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:21:56 -0500
Date: Tue, 6 Dec 2011 11:21:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, HoP <jpetrous@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
Message-ID: <20111206112153.GC17194@sirena.org.uk>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
 <4ED6C5B8.8040803@linuxtv.org>
 <4ED75F53.30709@redhat.com>
 <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
 <20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
 <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com>
 <4EDC9B17.2080701@gmail.com>
 <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com>
 <4EDD01BA.40208@redhat.com>
 <4EDD2C82.7040804@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDD2C82.7040804@linuxtv.org>
X-Cookie: Garbage In, Gospel Out
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 09:41:38PM +0100, Andreas Oberritter wrote:
> On 05.12.2011 18:39, Mauro Carvalho Chehab wrote:

> > When you put someone via the network, issues like latency,  package
> > drops, IP
> > congestion, QoS issues, cryptography, tunneling, etc should be taken
> > into account
> > by the application, in order to properly address the network issues.

> Are you serious? Lower networking layers should be transparent to the
> upper layers. You don't implement VPN or say TCP in all of your
> applications, do you? These are just some more made-up arguments which
> don't have anything to do with the use cases I explained earlier.

For real time applications it does make a big difference - decisions
taken at the application level can greatly impact end application
performance.  For example with VoIP on a LAN you can get great audio
quality by using very little compression at the expense of high
bandwidth and you can probably use a very small jitter buffer.  Try
doing that over a longer distance or more congested network which drops
packets and it becomes useful to use a more commpressed encoding for
your data which may have better features for handling packet loss, or to
increase your jitter buffer to cope with the less reliable transmit
times.
