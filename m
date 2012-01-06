Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030516Ab2AFUac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:30:32 -0500
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:59329 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030443Ab2AFUaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:30:30 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au5VADhZB09V5qrvPGdsb2JhbABDiVaiahkBAQEBNzKBcgEBBTocIxAIAxguFCUKGogPtiwTixtjBI0yh1SFX4xY
X-IronPort-AV: E=Sophos;i="4.71,469,1320620400"; 
   d="scan'208";a="27750417"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 6 Jan 2012 21:30:28 +0100
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Chase Douglas <chase.douglas@canonical.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: evdev - Add EVIOC mechanism to extract the MT
 slot state
Message-ID: <20120106203028.GA3287@polaris.bitmath.org>
References: <1325863019-2242-1-git-send-email-rydberg@euromail.se>
 <CAN+gG=FUEH851Um4Lco0avqdE2Eup3Jo79Ti4T7XhxT=PO6WeQ@mail.gmail.com>
 <20120106181845.GA22653@core.coreip.homeip.net>
 <20120106185544.GB2795@polaris.bitmath.org>
 <20120106191835.GA2998@polaris.bitmath.org>
 <4F074CAE.7010205@canonical.com>
 <20120106194815.GA3116@polaris.bitmath.org>
 <20120106200239.GB23619@core.coreip.homeip.net>
 <20120106201434.GA3174@polaris.bitmath.org>
 <20120106202342.GA10972@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106202342.GA10972@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 12:23:42PM -0800, Dmitry Torokhov wrote:
> On Fri, Jan 06, 2012 at 09:14:34PM +0100, Henrik Rydberg wrote:
> > On Fri, Jan 06, 2012 at 12:02:40PM -0800, Dmitry Torokhov wrote:
> > > On Fri, Jan 06, 2012 at 08:48:15PM +0100, Henrik Rydberg wrote:
> > > > > > Ok, maybe not to so easy after all, which probably answers my own
> > > > > > question. Looks like a EVIOCGMTSLOT, taking both slot and event code
> > > > > > as argument, would be the cleaner route to take. Another ioctl, how do we
> > > > > > feel about that?
> > > > > 
> > > > > What's the problem with userspace locking?
> > > > 
> > > > The idea was to get by without it.
> > > > 
> > > > Regarding ioctls, it does not seem realizable due to ioctl number
> > > > exhaustion.
> > > 
> > > I am prettu sure we cabn spare 1 ioctl number. We just need to pass slot
> > > number not as part of ioctl number but in data instead. Like
> > > EVIOCGKEYCODE works.
> > 
> > Right, thanks. Perhaps we could even pass it as result data -
> > returning all mt data in one go? With the purpose being to capture the
> > full MT state, it ought to be both simpler and faster.
> 
> Yes, if caller passes buffer size and buffer address we can return all
> data in one go. We just need to make _really sure_ we are using 32/64 bit
> safe interface.

Yep. Great, I think we are getting closer. Will look into it.

Thanks,
Henrik
