Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab0FORhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 13:37:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:40644 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab0FORhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 13:37:21 -0400
Message-ID: <4C17BA0C.4010208@kernel.org>
Date: Tue, 15 Jun 2010 19:36:12 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <gregkh@suse.de>, mingo@elte.hu, tglx@linutronix.de,
       bphilips@suse.de, yinghai@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org, linux-ide@vger.kernel.org, stern@rowland.harvard.edu,
       khali@linux-fr.org
Subject: Re: [PATCH 12/12] usb: use IRQ watching
References: <1276443098-20653-1-git-send-email-tj@kernel.org> 	<1276443098-20653-13-git-send-email-tj@kernel.org> <20100614214122.GA21064@suse.de> 	<4C16A48A.2070404@kernel.org> <4C16AAEE.5090204@kernel.org> 	<AANLkTilG1KAVOe5DcpLEFAJ-37PQJCgVT-jLZhr1e6tC@mail.gmail.com> 	<4C176206.90305@kernel.org> <AANLkTinVL4UuF70E1dR1vbYYkVRTBDh5su5D9k0h-vVA@mail.gmail.com>
In-Reply-To: <AANLkTinVL4UuF70E1dR1vbYYkVRTBDh5su5D9k0h-vVA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 15 Jun 2010 17:36:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/15/2010 03:36 PM, Kay Sievers wrote:
> Yeah, I'm pretty sure that's not what we want. We want structured
> data, and a generic channel to pass all sort of errors through, and a
> userspace part to handle it in a sane way. Many error sources may also
> not have a device path in /sys, and therefore no uevent to send.
> Uevents/udev just seem so convinient because it's already there, but I
> think, has too many limitations to provide the needed functionality.
> Besides the fact that nothing listens to these events in userspace
> today -- it's a lot more to think through and work on than passing
> things through uevents, especially some generic classification and
> structured data passing, which is needed, instead of the current
> free-text 'dmsg' or the property-based stuff in uevents. I'm very sure
> it's the wrong facility to use.

Yeah, well, if you say so.  It would be very nice to have report this
type of critical events in somewhat formatted way so that they can be
processed automatically and presented to the user in more accessible
manner.  I doubt requiring strict structure would work in the long
run.  It'll likely end up being able to cover only portion of what's
originally designed and and stagnate in time.  I think control
information including identification and severity + free form string
would be much more manageable.

It would really be great to have something like that.  I can easily
think of several libata events the user should be notified of from the
top of my head but currently are buried in dmesg.

Thanks.

-- 
tejun
