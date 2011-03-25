Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab1CYGQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 02:16:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59256 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab1CYGQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 02:16:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RSdpR5K//KUmSWyN2zvMfvwRasZvjqY1s7vEY7KLNEHP5al1tKD8GxlxKgTFdy8Ra3
         eQWZZ0MagMp8Nt20c1QHt+7FlgrTA3T9zuIQEeFhxqtvwO6zu4+BEK8wLigm4dtcAXBJ
         rUSHuVWSCKjyidl/ISP5RiYZ4Y9ed6Pup/j1I=
Date: Thu, 24 Mar 2011 23:16:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: Chase Douglas <chase.douglas@canonical.com>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Nikolai Kondrashov <spbnick@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Documentation: Add evdev type and code definitions
Message-ID: <20110325061624.GA1973@core.coreip.homeip.net>
References: <1300988652-25353-1-git-send-email-chase.douglas@canonical.com>
 <AANLkTimv3ZVQmgB-tbMthCYdEsK3Spk0WY9Vs9VLQEVs@mail.gmail.com>
 <4D8B9F6F.5010705@canonical.com>
 <20110325003602.GA14035@barra.bne.redhat.com>
 <20110325055023.GB4137@core.coreip.homeip.net>
 <20110325060434.GB24855@barra.bne.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325060434.GB24855@barra.bne.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 04:04:34PM +1000, Peter Hutterer wrote:
> On Thu, Mar 24, 2011 at 10:50:23PM -0700, Dmitry Torokhov wrote:
> > On Fri, Mar 25, 2011 at 10:36:02AM +1000, Peter Hutterer wrote:
> > > On Thu, Mar 24, 2011 at 03:45:51PM -0400, Chase Douglas wrote:
> > > > On 03/24/2011 02:44 PM, Chris Bagwell wrote:
> > > > > Looking good.  Minor comments at end.
> > > > > 
> > > > > On Thu, Mar 24, 2011 at 12:44 PM, Chase Douglas
> > > > > <chase.douglas@canonical.com> wrote:
> > > > >> +Touchscreens:
> > > > >> +----------
> > > > >> +ABS_{X,Y} must be reported with the location of the touch. BTN_TOUCH must be
> > > > >> +used to report when a touch is active on the screen.
> > > > >> +BTN_{MOUSE,LEFT,MIDDLE,RIGHT} must not be reported. BTN_TOOL_<name> events
> > > > >> +should be reported where possible.
> > > > > 
> > > > > Does the real button event restriction solve something?  I know
> > > > > majority of touchscreens are not sending a button today but usually
> > > > > there is a button on the touchscreen frame that I'd image at least
> > > > > some devices hooking it up to touchscreen interface.
> > > > >
> > > > > stylus+touchscreen combo devices are surely going to want to do this.
> > > > 
> > > > Perhaps this should be more clearly for touchscreen-only devices (not
> > > > tablets or a mix). The problem we end up seeing is drivers who use
> > > > BTN_LEFT because they want a touch to generate a primary button press in
> > > > X. I want to prevent people from doing this.
> > > 
> > > suggest that they use BTN_0 instead then?
> > > 
> > 
> > Umm, I'd hope X evdev driver could handle BTN_TOUCH without
> > BTN_LEFT/BTN_0 to indicate primary button. Legacy mode (mousedev)
> > already translateds BTN_TOUCH/BTN_LEFT/BTN_0 into "left PS/2 button".
> 
> evdev treats BTN_TOUCH as button, yes. my comment above refers to additional
> buttons on the tablet that aren't touch. maybe I misread the above though.
> 

I guess it depends on the purpose of the buttons. BTN_LEFT is really a
"primary button" so would not make sense for additional buttons on a
touchscreen. BTN_0 is more like "we have no idea what it is so here you
go" though...

Thanks.

-- 
Dmitry
