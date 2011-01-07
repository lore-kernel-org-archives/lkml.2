Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab1AGWmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:42:10 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53029 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1AGWmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:42:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oReKZstT7ial7a8VscBUkXuo3UXUalUveECdpbI9rCQ60mpxaP/gOj2IJ+L8V2CCH7
         GpWdsFXvHPVZEDXi7m1+QKwp6wGMm5s+1I6+ljArKuq8CkxI5brFhQNFl30Ir+1bWR8T
         v6f6M0upE13P9wO6tO7zIioAdHUKmDMyR1g1M=
Date: Fri, 7 Jan 2011 14:42:02 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Nikolai Kondrashov <spbnick@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Documentation: Add evdev type and code definitions
Message-ID: <20110107224202.GG28875@core.coreip.homeip.net>
References: <1294435695-16750-1-git-send-email-chase.douglas@canonical.com>
 <20110107215353.GF28875@core.coreip.homeip.net>
 <4D278DC6.7070209@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D278DC6.7070209@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 05:03:50PM -0500, Chase Douglas wrote:
> On 01/07/2011 04:53 PM, Dmitry Torokhov wrote:
> > Hi Chase,
> > 
> > On Fri, Jan 07, 2011 at 04:28:15PM -0500, Chase Douglas wrote:
> >> +
> >> +EV_SW:
> >> +----------
> >> +EV_SW events describe stateful binary switches. For example, the SW_LID code is
> >> +used to denote when a laptop lid is closed.
> > 
> > Please add that drivers should refresh switch state upon binding to a
> > device and also upon resume.
> 
> I've not written any switch evdev drivers, can you clarify what you
> mean, maybe give me something to paste in?
> 
> Are you meaning that the switch state may have physically changed, and
> that the driver should query the physical state to be sure, or do you

Right, switch state might be physically changed while the device/system
was asleep and thus we need to ensure that kernel's (and userspace)
switch state is consistent with physical state.

Same should be done in the very beginnning, while registering input
device - it is quite possible that we start with some switches in
"on" state.

Technically speaking, some keys might be depressed as well, but we
ignore this possibility and assume that everything is released because
it is simpler, we expect that all depressed keys will be released
shortly anyway, and not all devices allow to query current state of a
button (i.e. devices that only transmit state change).

> mean that the driver must send a new event even if the state has not
> changed?

The drive should send the events and input core will filter them out if
state still matches the old state.

Thanks.

-- 
Dmitry
