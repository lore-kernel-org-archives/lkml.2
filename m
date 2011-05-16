Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab1EPVkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:40:46 -0400
Received: from nigelcunningham.com.au ([178.79.133.97]:56122 "EHLO
	nigelcunningham.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab1EPVkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:40:45 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 May 2011 17:40:45 EDT
Message-ID: <4DD19879.5020606@tuxonice.net>
Date: Tue, 17 May 2011 07:34:49 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Martin Steigerwald <Martin@lichtvoll.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] PM / Hibernate: Add sysfs knob to control size of
 memory for drivers
References: <201105100059.25372.rjw@sisk.pl> <201105150056.55601.rjw@sisk.pl> <201105151051.38934.Martin@lichtvoll.de> <201105151136.22169.rjw@sisk.pl>
In-Reply-To: <201105151136.22169.rjw@sisk.pl>
X-TagToolbar-Keys: D20110517073449281
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 15/05/11 19:36, Rafael J. Wysocki wrote:
> In fact, if drivers allocated their memory from suspend/hibernate notifiers,
> that would be practically equivalent to setting reserved_size to the total
> amount of memory reserved by the drivers.  However, it may be difficult
> for drivers to predict how much memory they will need at the time the
> notifiers are called (they are called before freezing user space).
> 
> Thus I'm considering a change that will cause device drivers' ->prepare()
> callbacks to be executed before the preallocation of memory takes place.
> In that case the drivers may allocate memory from their ->prepare()
> callbacks _after_ user space has been frozen and that will make more
> sense overall.
> 
> For now, however, I think that exposing reserved_size is the right choice.

Sorry for not commenting earlier - too busy with Drupal development and
only came across this thread by chance (yes, I'm still subscribed to the
PM list, but haven't been reading it. Hibernation isn't high on my list
of priorities at the moment because TOI is feature complete and stable.
I know I'm supposed to be sending you patches, but other things have
been taking the time that would be used for that).

Anyway...

This sounds to me like a great development. As far as TuxOnIce goes,
we've had a knob for ages that has allowed the user to specify an amount
of memory to be kept aside for driver allocations, and we calculate and
report how much they used in the debugging info sysfs entry. Because
TuxOnIce works differently to [u]swsusp, this is the only source of
potential out-of-memory related failures, and the measures just
mentioned made things much more reliable.

If things went in the direction you're suggesting here, they'd get
better again. I'm all in favour!

Regards,

Nigel
