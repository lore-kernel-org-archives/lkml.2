Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab0HaRJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 13:09:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60335 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab0HaRJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 13:09:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q6V72uO65XSZwjQfp87oY/ugTs5HX9Mp3j23YGv3S+NU+Xcq4RqWoc032l1VP7WVGo
         N1i95eSKDSMGTUMmIvBgj5N/5uAYN5iY3v1SIQT+NEEXZv/UVFtNj9D4DU8CPkvqqRxI
         hfsQ0kqPIoubulSVgkfH4gWewiMMqT9dTgYYA=
Date: Tue, 31 Aug 2010 10:09:23 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Felipe Balbi <me@felipebalbi.com>, Hemanth V <hemanthv@ti.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "igor.stoppa@nokia.com" <igor.stoppa@nokia.com>,
        "kai.svahn@nokia.com" <kai.svahn@nokia.com>,
        "matthias.nyman@nokia.com" <matthias.nyman@nokia.com>
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2] input:
 CMA3000 Accelerometer driver)
Message-ID: <20100831170923.GB30947@core.coreip.homeip.net>
References: <36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com>
 <20100830214025.2f9677a1@lxorguk.ukuu.org.uk>
 <20100830204412.GA28711@core.coreip.homeip.net>
 <AANLkTims1CagvPZQjTmYrOVi8REeLVbyyt3kEY_tsCtx@mail.gmail.com>
 <20100830214355.GB28865@core.coreip.homeip.net>
 <AANLkTinPConD62Ky7mvMn2ZgS=V9+Q5YUdaF5Vma8mn+@mail.gmail.com>
 <20100830224352.GF28865@core.coreip.homeip.net>
 <20100831104446.321fd4f4@lxorguk.ukuu.org.uk>
 <20100831161730.GA30947@core.coreip.homeip.net>
 <20100831175937.70a59a91@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100831175937.70a59a91@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 05:59:37PM +0100, Alan Cox wrote:
> > > If non-input uses later need non-input interfaces they can switch to that
> > > with an input bridge when there is one and when it happens, which
> > > probably won't.
> > 
> > Would there even be an argument which subsystem to use if IIO->input
> > bridge existed today? Because if the answer is "no" then push into input
> > is driven by convenience and not because it is the right solution. 
> 
> Probably because most of these devices have nothing to do with industrial
> I/O at all.

"Data acquisition devices" then?

> 
> > If application does take something as an input it does not make it
> > necessarily a human interface device. By this reasoning cameras should
> > be represented as an input devices (why, some applications take input
> 
> That's not what I asked. 
> 
> > I really believe that input should represent purely human interface
> > devices, not arbitrary data acquisition devices.
> 
> That tends to make little sense where the API is the same and
> applications benefit enormously from consistency. I'd rather have an
> input->IIO bridge because that is the real world today !
> 
> The question is what does the API make *sense* for. Not what can you use
> the API for. Unix (and Linux) are enormously powerful because of the use
> of common interfaces and APIs.
> 
> So a voltmeter really makes no sense. It's not a set of keys and it
> doesn't give X/Y/Z style readings. Nor does a camera. But a lot of things
> do fit this to varying degrees.
> 
> I'm actually more dubious than Linus about ALS - because ALS tends not
> produce 'events' but to be sampled, and there are significant power
> implications to unnecessary polling.
> 
> See it as a curse of success - because you got the API right and made it
> flexible people want to use it.

I knew it! Its all Vojtech's fault.

> And the more it's used the less special
> code is needed in user or kernel space for PDAs and phones - instead they
> just work.

OK, so let's say we start moving some of the devices into input. Which
ones we consider suitable for input? I guess some 3-digit
accelerometers, what else? Also, what new event types would we need?
Let's take GPS - I do not think that ABS_X and ABS_Y are the best events
to be used for such devices: I am trying to allow applications being
ignorant of what exact device they are talking to and rather concentrate
on device capabilities (list of events supported). GPS is sufficiently
different from a tablet/touchscreen; while some might want to use both
as inputs to a game most applications would want to know which one
which. 

Also, GPS, liek ALS, would probably be polling, no?

-- 
Dmitry
