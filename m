Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930Ab2FDVWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 17:22:50 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48554 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab2FDVWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 17:22:48 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6732"; a="197613218"
Message-ID: <4FCD2727.7050405@codeaurora.org>
Date: Mon, 04 Jun 2012 14:22:47 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] remoteproc: maintain a generic child device for each
 rproc
References: <1338017791-9442-1-git-send-email-ohad@wizery.com> <4FC5DBFA.2030300@codeaurora.org> <CAK=WgbZJJJPuNWVv8WgL=KKm6Hrx2krDD9gBOTP7sA8p7mh_rA@mail.gmail.com>
In-Reply-To: <CAK=WgbZJJJPuNWVv8WgL=KKm6Hrx2krDD9gBOTP7sA8p7mh_rA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry your mail was lost due to mail outage)

On 05/30/12 05:16, Ohad Ben-Cohen wrote:
>
> On Wed, May 30, 2012 at 11:36 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>> One complaint I've gotten is that the error messages are essentially
>> useless now. I believe there are some ongoing discussions on lkml to fix
>> this by traversing the device hierarchy to find the "real" device but
>> the hard part is finding the real device.
> You probably refer to the discussions around the input subsystem's pull request.
>
> I was thinking about that too when creating this patch, and it looks
> like whatever Greg will come up with on that matter will benefit us
> too. So taking that into account, it might make more sense to do stick
> with the virtual device rather than use the real one here (we'll end
> up having more information in the long run).

Fair enough. Hopefully something comes out of that discussion since this
will need it.

>> I'm not clear on busses versus classes.
> I think that busses is a whole lot more complex beast. Probably the
> main indication we want one is when we need to match drivers to
> devices.
>
> In this case, I was more wondering between using a class to a device type.
>
>> I recall seeing a thread where
>> someone said classes were on the way out and shouldn't be used but I
>> can't find it anymore.
> I also remembered a similar discussion at a plumbers mini-conf about
> 2-3 years ago too, so I looked at device_type as an alternative to
> class. The former looks somewhat simpler, but I couldn't find any
> major advantage for using one over the other, and both seem to be in
> use by many subsystems.
>
>> Should we use classes for devices that will never
>> have a matching driver?
> It's not strictly required, but in case we want to provide these
> devices some common behavior (and in our case we want them all to have
> the same release handler, and very soon, the same PM handlers, too),
> then a class (or a type) is helpful.
>
> It looks like moving from a class to a type is quite trivial, in case
> classes do eventually go away (or an advantage of using the latter
> shows up), but I'm not aware of any other viable alternative for us
> other than class/type.
>

Ok. Will moving from a class to a device type disrupt the kernel ABI?
First it will be under /sys/class/ and then under /sys/bus? Greg, can
you shed some light on when to use a class versus a device type?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

