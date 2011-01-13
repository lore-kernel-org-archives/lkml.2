Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787Ab1AMUWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:22:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:46608 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933703Ab1AMUW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:22:26 -0500
Message-ID: <4D2F5EFE.6060407@windriver.com>
Date: Thu, 13 Jan 2011 14:22:22 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Power plug off / on - EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=600
References: <AANLkTinC=i24FaOtB3srbCUROza1V2TQ0zxNMq+QH+mj@mail.gmail.com> <B48664E0-16B7-49A5-AE50-1C3DA751DC2C@mit.edu>
In-Reply-To: <B48664E0-16B7-49A5-AE50-1C3DA751DC2C@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jan 2011 20:22:24.0022 (UTC) FILETIME=[969B5B60:01CBB35F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2011 06:09 PM, Theodore Tso wrote:
> 
> On Jan 12, 2011, at 4:35 PM, Luis R. Rodriguez wrote:
> 
>> When I yank my power chord off of my Thinkpad T61 running 2.6.37 I get
>> the following:
>>
>> [   79.523778] Monitor-Mwait will be used to enter C-3 state
>> [   81.195402] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=600
>>
>> mcgrof@tux ~ $ mount| grep sda1
>> /dev/sda1 on / type ext4 (rw,errors=remount-ro,commit=600)
> 
> Sounds like you have some userspace script which is being triggered on the transition running on batteries, and it's doing a remount -o commit=600 to save power.   Are you using laptop_mode by any chance?
> 

That is interesting indeed.   While I am running a substantially older kernel ( 2.6.35-24-generic #42-Ubuntu 10.10 ).  I was seeing a consistent problem where if you pulled the power cord while the system was under heavy I/O load, you could no longer run sync.  The jbd2 process just kept on running forever continuously.  Shutdown was impossible to because vfs unmount blocked (hold power key for 4+ seconds...).

The script in question is: 

/usr/lib/pm-utils/power.d/journal-commit

I commented out the line: 

#       mount -o remount,$2 $1

And now gone is the nasty problem of not being able to shutdown or have processes block on a call to sync().  Clearly this is nothing more than a band aid, and perhaps it is fixed in a newer kernel (one can hope anyway).

Cheers,
Jason.
