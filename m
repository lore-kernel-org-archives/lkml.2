Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab2FUBVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 21:21:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59965 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab2FUBVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 21:21:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120620223754.GA5864@kroah.com>
References: <1339391600-17815-1-git-send-email-ming.lei@canonical.com>
	<20120615220343.GA8928@kroah.com>
	<CACVXFVO6h6wiHdTwVcjQLNtncO+ezVX3RJZPVenHEmhHjErRhg@mail.gmail.com>
	<20120618222550.GB11737@kroah.com>
	<CACVXFVOr1mnjaEoGpc3O_MDuvi_KHTXtsEBQ7LLoaeWxWRa0aQ@mail.gmail.com>
	<20120620223754.GA5864@kroah.com>
Date: Thu, 21 Jun 2012 09:21:08 +0800
Message-ID: <CACVXFVNP4HJwtjgAD=D7Fv7NW2j1aHj55X8j-4qhpBZTcw2+7w@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove(v2)
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 6:37 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Jun 19, 2012 at 10:00:36AM +0800, Ming Lei wrote:

>> so I marked it as -stable because I have explained how the race can be
>> exploited in reality.
>
> Ok, but as this has been there since when, 2.5, I'll refrain from
> marking it this way, as no one has reported a real problem like this
> before.

So have you agreed on keeping Cc: stable in v3?

>> I still have more many examples in kernel about timeout value...
>
> Yes, I know this, but now you are putting a limit on the amount of time

No, I don't put a limit on it, see my below explanation.

> a probe function can take, when before, we have never had one.  That's
> not something to be taken lightly, and is one I know is not true.
>
>> > Why not just do a real lock and try for forever?
>>
>> IMO, there are two advantages not just doing a real lock for forever:
>>
>> - avoiding buggy device/driver to hang the system
>> - with trylock, we can log the buggy device so that it is a bit
>> easier to troubleshoot the buggy drivers, suppose the bug is
>> only triggered 1 time in one year or more
>
> No, just fix the driver, I don't want to put a time limit on how long

Surely we need to fix the driver, but the problem is that it may be very
difficult to fix the driver without the log introduced in the patch, so why
not take it without obvious side effect?

> probe can take, as we never have in the past and I'm sure that whatever
> we pick, will be wrong for someone.
>
> I have seen devices that take many seconds, and minutes for some if bad
> things happen (i.e. the firmware doesn't download properly).  Don't
> break people's working systems.

Suppose some weird devices may take so much time on its probe callback,
the patch does not break anything, just like before applying the patch:
call its .shutdown callback directly without holding the device lock.

So could we just change the timeout value to a larger one? such as 10
seconds or more?

Thanks,
--
Ming Lei
