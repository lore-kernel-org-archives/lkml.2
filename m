Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0FYNjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:39:16 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:58803 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab0FYNjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:39:12 -0400
X-Greylist: delayed 1414 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jun 2010 09:39:12 EDT
X-SENDER-IP: [217.174.79.67]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKNJJEzZrk9D/2dsb2JhbACfQHHBN4UhBA
X-IronPort-AV: E=Sophos;i="4.53,481,1272837600"; 
   d="scan'208";a="94345268"
Message-ID: <4C24ACE2.5000307@euromail.se>
Date: Fri, 25 Jun 2010 15:19:30 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>
Subject: Re: [PATCH] input: evdev: Use multi-reader buffer to save space (rev5)
References: <1277059734-2939-1-git-send-email-rydberg@euromail.se> <20100623061939.GB11187@core.coreip.homeip.net> <4C21C1C3.5050708@euromail.se> <20100625081445.GA8546@core.coreip.homeip.net>
In-Reply-To: <20100625081445.GA8546@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2010 13:19:35.0786 (UTC) FILETIME=[0E843CA0:01CB1469]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Wed, Jun 23, 2010 at 10:11:47AM +0200, Henrik Rydberg wrote:
>> Dmitry Torokhov wrote:
>>
>>> Overall I am starting getting concerned about proper isolation between
>>> clients. Right now, if one client stops reading events and another one
>>> issues grab then the first client will only get events that were
>>> accumulated before grab tookm place. With the new shared buffer the
>>> first client may get "grabbed" events if it stop for long enough for
>>> buffer to wrap around.
>> Doing some research, the semantics of ioctl have obviously been discussed
>> before, and I believe this points to another such issue. When grabbing a device,
>> are we guaranteeing that the device no longer sends events to other clients, or
>> are we guaranteeing that other clients can no longer read the device? If the
>> latter, clearing all client buffers in conjunction with a grab would be
>> appropriate, and would solve this issue.
> 
> 
> Yes, I think it would be acceptable approach.
> 
>>> Do we really same that much memory here? We normally do not have that
>>> many users connected to event devices at once...
>> Ok, let's scratch this. Although I think the idea of multi-reader buffers is
>> sound, it is obviously sufficiently incompatible with the current approach to
>> produce distastefully complex patches. I will return with a new set which only
>> fixes the buffer resize problem, and leaves the rest for later.
>>
> 
> Right, let's merge this and also MT slots and revisit this issue at some
> later point.

Sounds good. I just resent the main MT patches, adding some more Cc:s, and to
make sure we both have the same version. :-) Regarding the ioctl stuff for MT
slots, I did not send those again, I am not sure what to do with them.

Thanks,
Henrik

