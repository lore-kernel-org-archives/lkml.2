Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613Ab2DZXAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 19:00:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757554Ab2DZXAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 19:00:31 -0400
Date: Thu, 26 Apr 2012 16:00:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shuahkhan@gmail.com
Cc: Jonas Bonn <jonas@southpole.se>, LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        NeilBrown <neilb@suse.de>
Subject: Re: [PATCH  v2] leds: add new transient trigger for one shot timer
 activation
Message-Id: <20120426160029.0c2da1fc.akpm@linux-foundation.org>
In-Reply-To: <1335375758.5313.22.camel@lorien2>
References: <1333310039.2879.4.camel@lorien2>
	<1334064283.10826.6.camel@ted>
	<1334507752.2723.3.camel@lorien2>
	<1334894674.3051.18.camel@lorien2>
	<1334983269.2435.90.camel@jerome.southpole.se>
	<1335138687.2882.20.camel@lorien2>
	<20120423115610.2da4d4d7@notabene.brown>
	<1335158999.5139.47.camel@jerome.southpole.se>
	<20120423154546.415bd6c0@notabene.brown>
	<1335219745.2850.7.camel@lorien2>
	<1335375758.5313.22.camel@lorien2>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2012 11:42:38 -0600
Shuah Khan <shuahkhan@gmail.com> wrote:

> Second version of the patch to add new transient trigger to support
> one shot timer activation. This trigger has two properties, activate
> and duration. duration allows setting timer value in msecs. activate
> allows activating and deactivating the timer specified by duration as
> needed.
> 
> There was a suggestion to change units to seconds similar to "safe_delay_show" 
> and "safe_delay_store" in drivers/md/md.c. safe_delay_show shows time in
> seconds, however safe_delay_store still takes the value in msecs. This
> sounded like an asymmetric interface.
> 
> I decided to leave duration units as msecs to be consistent with the
> rest of the triggers in the leds sub-system for now.
> 
> I also found couple of bugs in activate store causing it to cancel the 
> timer when it shouldn't and extending the timer when a second activate
> comes in while timer is running.
> 
> Hope I addressed all of the review comments and didn't miss anything.
> Thanks again for a good discussion and ideas.

First rule of changelogs: think about how your words will appear to
others in a year's time.  Text which refers to an earlier version of
the patch is uninteresting.  Text which refers to some review
discussion is uninteresting.  There is a convention that this short-term
information is presented after the separating "^---" in the changelog,
after the signoffs, cc's, etc.

When I stripped out all the short-term fluff all I was left with was
part of the first paragraph, and it's a poor changelog.  It doesn't
describe what a "transient trigger" is, it doesn't define "one shot
timer activation".  Quite importantly, it doesn't describe the user
interface to this feature, which is the most important part of the
patch, because it is the part we can never change.

So, please fully describe the feature and fully describe the interface
which it exposes to users.  This would include a description of dynamic
behaviour such as cancelation, what happens if a LED driver module is
removed when the trigger is in its pending and active states, what
happens if the trigger is re-acticated when it is pending, what happens
if the trigger is re-activated when the LED is active, etc.

This stuff matters!  We want to hear you describe it in your own words,
so we can understand (and hopefully agree with) your design intent and
then check the implementation agaisnt that intent.

Can I use this feature to have my LED temporarily blink *off*?

Another thing which is missing here is a decent description of why the
kernel needs this feature.  I can implement a one-shot LED trigger in
userspace, using complex things like "sleep".  Where is the
justification for adding kernel code to do this?

