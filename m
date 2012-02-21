Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2BUWY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 17:24:28 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:44114 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab2BUWY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 17:24:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jgpobox@gmail.com designates 10.229.134.205 as permitted sender) smtp.mail=jgpobox@gmail.com; dkim=pass header.i=jgpobox@gmail.com
Message-ID: <4F441998.5080600@garzik.org>
Date: Tue, 21 Feb 2012 17:24:24 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Holger Macht <holger@homac.de>
CC: Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, Jeff Garzik <jgarzik@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: dock_link_device is oopsy
References: <20120217222922.GA2741@homac.suse.de> <alpine.LSU.2.00.1202171436490.10222@eggly.anvils> <20120217230107.GA12929@homac.suse.de> <alpine.LSU.2.00.1202171541040.3155@eggly.anvils> <20120218111419.GA2488@homac.suse.de> <CAJd=RBDRZSizawvRYqr7=U75Su5TLvMfgdagRA49wzJr40DqSg@mail.gmail.com> <20120218132610.GA15265@homac.suse.de> <CAJd=RBAhnsuP4+pRS=MLyOaqx8O1gOR30bcoZC0Owabh1-1nzA@mail.gmail.com> <20120218140449.GA2558@homac.suse.de> <alpine.LSU.2.00.1202181034380.3512@eggly.anvils> <20120218195722.GA2590@homac.suse.de>
In-Reply-To: <20120218195722.GA2590@homac.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2012 02:57 PM, Holger Macht wrote:
> On Sa 18. Feb - 10:46:04, Hugh Dickins wrote:
>> On Sat, 18 Feb 2012, Holger Macht wrote:
>>> How about that one?
>>
>> It's more broken than that.  Here's my attempt.  It boots on the
>> systems with dock_station_count 0, and it boots on my laptop with
>> dock_station_count 2; but I don't actually have any docking station,
>> so it still doesn't test very much (dock is 0 after the loop).
>
> Well, there doesn't have to actually exist a physical dock station (or
> bay device) for dock_station_count to be>  0. It just tells that the
> ACPI objects are present and thus the system is capable of it.
>
> So does this function actually also break on your laptop and you're
> getting the oops there, too?
>
>> I have no idea if what goes on in the loop is correct, but it looks
>> to me as if (as predicted) there's further breakage, that it would
>> have been writing beyond the end of what it allocated if I did have
>> a docking station.
>>
>> Hugh
>>
>> [PATCH] dock: fix bootup oops and other dock_link breakage
>>
>> dock_link_device() and dock_unlink_device() should bail out early
>> to avoid oops on zero-length kmalloc() when dock_station_count is 0.
>>
>> But isn't there an off-by-one in that kmalloc() length anyway?
>> An extra NULL appended at the end suggests so.
>>
>> Rework the ordering with gotos on failure to fix several issues.
>>
>> And presumably dock_unlink_device() should be presenting the same
>> interface as dock_link_device(), with NULL returned when none found.
>>
>> Signed-off-by: Hugh Dickins<hughd@google.com>
>
> Fine with me.

So, just to be clear, the preferred patch is Hugh's, and I should drop 
your earlier proposed fix found in this thread?

And what about that warning?

Need to fix up linux-next or temporarily drop this patchset from linux-next.

	Jeff




