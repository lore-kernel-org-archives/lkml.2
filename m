Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab0LOHZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 02:25:37 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54617 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab0LOHZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 02:25:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J6jrbIOVT7/QiBfclOEx+ofpnGZAVz/6dKmXw/aO1o0DcEB0q991thP5R41z1st6Kk
         ju/ZkjIywR3J0kgJOZNm3NvBg8BPjqO+3T8yxlU2Nfd9BrPAt9AuaNHR7isyF2py+lWq
         V+XeufVs3QoONvwS0g/BeTQ562xehrrx/r9e4=
Date: Tue, 14 Dec 2010 23:25:29 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Chase Douglas <chase.douglas@canonical.com>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Alternative approach to MT_TOOL_ENVELOPE
Message-ID: <20101215072528.GB11867@core.coreip.homeip.net>
References: <1292361672-2581-1-git-send-email-chase.douglas@canonical.com>
 <20101214221241.GA11519@core.coreip.homeip.net>
 <4D080A13.6050601@canonical.com>
 <4D081BF2.7000202@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D081BF2.7000202@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 02:37:54AM +0100, Henrik Rydberg wrote:
> Hi Chase,
> 
> >
> 
> > I gave this some more thought, and I was close to accepting it with
> > documentation of the above restrictions. Then I thought of how the
> > following two devices would be presented to userspace:
> > 
> > 1. A real MT device supporting up to 2 touches (e.g. a bamboo touch)
> >   - ABS_{X,Y}, BTN_TOUCH, BTN_TOOL_FINGER, and BTN_TOOL_DOUBLETAP for ST
> >   - ABS_MT_SLOT, ABS_MT_TRACKING_ID, ABS_MT_POSITION_{X,Y}, ABS_MT_TOOL_TYPE
> > 
> > 2. A partial MT device using MT_TOOL_ENVELOPE (e.g. synaptics MT)
> >   - ABS_{X,Y}, BTN_TOUCH, BTN_TOOL_FINGER, and BTN_TOOL_DOUBLETAP for ST
> >   - ABS_MT_SLOT, ABS_MT_TRACKING_ID, ABS_MT_POSITION_{X,Y}, ABS_MT_TOOL_TYPE
> > 
> > Note that they are identical! The range of values for each axis would be
> > identical too. The only way to tell the two apart would be to watch for
> > the ABS_MT_TOOL_TYPE axis.

Question: does the driver really need to know this data beforehand?  I'd
expect MT-aware driver simply having handlers for both styles and then
doing the best it can with the data stream it gets... There should not
be ambiguity as to what event is - I believe we should be sending
BTN_TOOL_ENVELOPE even for the single/first contact for devices that do
not do full MT tracking.

> 
> 
> Ping has touched upon this subject as well, from the pen & touch perspective.
> Generally, some ABS axes are actually enumerations, for which we have no direct
> abstraction. If we had a way to declare the used values for such enumerations,
> it would resolve these and possibly other issues.

I think that presence of pen/touch can be detected by having
BTN_TOOL_PEN and BTN_TOOL_FINGER. However in this case the tool is
finger, so I do not think we should introduce BTN_TOOL_ENVELOPE. Maybe
this is another case where we should employ the proposed device flags?

Anyway, it looks like we have a few concerns with current
MT_TOOL_ENVELOPE so I want to rewind my 'next' branch.

-- 
Dmitry
