Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab0EXSEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:04:20 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:49606 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab0EXSES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:04:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hqf8TIN8ziRNo3XBy7EidCkflY+OIETGAw6eo6hgKqxqyEJtm+I6KtujYg+XNjYBZZ
         695PCVQ1vplR3ricl6U8o9oLaIHzqH27HvYhK+WYxxYSShcbdkbUCNnY7i1LBZe6+Mx7
         Wp/HASKZoYyqHnVaDTHtZzWDEVSlCoZwy1B1g=
Date: Mon, 24 May 2010 11:04:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Ping Cheng <pinglinux@gmail.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
Message-ID: <20100524180411.GA6033@core.coreip.homeip.net>
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>
 <20100524155901.GB3182@core.coreip.homeip.net>
 <AANLkTin9ahtqL7jrUP4C0zF9-P3rUg7ktN93-hcqdDnj@mail.gmail.com>
 <201005241021.02731.dmitry.torokhov@gmail.com>
 <4BFABBD0.9020202@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFABBD0.9020202@euromail.se>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 07:48:00PM +0200, Henrik Rydberg wrote:
> Dmitry Torokhov wrote:
> [...]
> >>>> I think we need to add an ioctl to enable user land driver/client to
> >>>> signal the kernel driver to send all events without filtering, just
> >>>> once. Hot-plugged devices and X driver starts after user has contacted
> >>>> with the device are two examples that the client would miss filtered
> >>>> events.
> >>>>
> >>>> Dmitry, do you think it is a valid suggestion?
> >>> What about using EVIOCGKEY/EVIOCGSW/EVIOCGABS?
> >> Those EVIOCs only give us the static values (max/min/supported keys,
> >> etc.).  We need their dynamic input data here, the actual x, y,
> >> button, pressure, etc. Am I missing something about those EVIOs?
> >>
> > 
> > Yes you are ;) Supported events are reported via EVIOCGBIT, EVIOCGKEY and
> > EVIOCGSW will return current state of keys/switches. As far as EVIOCGABS
> > goes, it also returns, besides min/max/etc, last reported _values_ of the
> > ABS_* events.
> > 
> 
> Ping is not alone. :-)
> 
> But it does not work for MT events -- yet.
> 

Yes, this is true.

I think the most interesting is the switch data, since they may not change
at all. The rest is transient and should refresh "fairly quickly".

-- 
Dmitry
