Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692Ab0EVU46 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 16:56:58 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54913 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab0EVU44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 16:56:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vai9hM+XMkjFEUl27bn9hy8rKoW0Tqud+FDNK5Y0DvtdlG3FaFXs0ezk1sm+qkzgJd
         rgJUiyHnG7PQzLkCzxto8/dr2JK6+6/4OTisUkA5JAhNibWWLVYsvKDbdFaskOUbX0D6
         0FKXy7C+fWLQET8Og4N65qeLFimyJulTByTlI=
Date: Sat, 22 May 2010 13:56:49 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Rafi Rubin <rafi@seas.upenn.edu>,
       Ping Cheng <pinglinux@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev3)
Message-ID: <20100522205649.GD30464@core.coreip.homeip.net>
References: <4BF6BB43.2020405@euromail.se>
 <20100521172222.GB26439@core.coreip.homeip.net>
 <4BF6C303.7030804@euromail.se>
 <20100521174140.GA23155@core.coreip.homeip.net>
 <4BF6C7B6.2020008@euromail.se>
 <4BF7A4E8.3050806@seas.upenn.edu>
 <4BF7B438.8000001@euromail.se>
 <1274539582.13705.132.camel@cndougla-ubuntu>
 <4BF818A6.6000801@euromail.se>
 <1274561549.20881.8.camel@mini>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274561549.20881.8.camel@mini>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 04:52:29PM -0400, Chase Douglas wrote:
> On Sat, 2010-05-22 at 19:47 +0200, Henrik Rydberg wrote:
> > Chase Douglas wrote:
> > > On Sat, 2010-05-22 at 12:38 +0200, Henrik Rydberg wrote:
> > >> Getting serious, it is anyone's guess what will happen next, but I was picturing
> > >> a table, with a large multitouch screen and buttons along the side of the table.
> > >> Sure, we can do "ABS_BTN_0", "ABS_BTN_1", etc, but with slots in place, it seems
> > >> more natural to use something like "ABS_MT_BTN_X". While at it, REL_MT event
> > >> makes sense for those touchscreen techniques which register changes, like
> > >> acoustic pulse recognition.
> > 
> > s/ABS/KEY/
> > 
> > > 
> > > Shouldn't this be handled in userspace? I don't think we want to be
> > > quirking drivers for instances where the same touchscreen is overlaid on
> > > buttons in some cases, but not in others. If we don't quirk, we'd need
> > > some mechanism to tell the driver about such buttons.
> > 
> > Perhaps you would like to clarify what "this" means here, and how you arrive at
> > quirking drivers.
> 
> I'm arriving rather late to the conversation, so this could be a matter
> of me not understanding everything. What I thought you were proposing is
> something like what I have on my Nexus One: an MT area encompassing a
> touchscreen and extending to an area of four "buttons" off the bottom of
> the screen. I was thinking that interactions with these buttons would
> trigger the KEY_MT_BTN events you mentioned. However, if thats the case
> then the driver needs to know of these buttons, so we've gone from a
> dumb touchscreen driver to a driver that must be aware of regions of the
> screen where there are buttons. This is where I think it would be better
> to have a userspace application (X?) understand the properties of the
> screen to know exactly what a touch means, instead of trying to
> interpret it inside the kernel.
> 

Even if kernel driver would be doing the "key" decoding then you would
not need KEY_MT_BTN - input layer will happily handle several keys
pressed at once, so the driver would just emit KEY_WWW, KEY_HOMEPAGE,
KEY_CANCEL, etc, etc. No need to bring in MT protocol here.

-- 
Dmitry
