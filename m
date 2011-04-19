Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1DSOtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:49:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59436 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab1DSOtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:49:51 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTin0krYi+MqngSQ5n-752vDa_a8ZtA@mail.gmail.com>
References: <1303116654-5042-1-git-send-email-monstr@monstr.eu>
 <20110418160658.GD23814@pengutronix.de> <BANLkTimFnfgiQ5aMq_KwqHP8p92pjOJJwg@mail.gmail.com>
 <20110419061121.GB5252@ponder.secretlab.ca> <BANLkTin0krYi+MqngSQ5n-752vDa_a8ZtA@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 19 Apr 2011 08:49:31 -0600
X-Google-Sender-Auth: o17EpOTzDk-yb953ecxTjHOIOTI
Message-ID: <BANLkTin-qL3ppG1jRjBu3S16SWcNjD=3kA@mail.gmail.com>
Subject: Re: [PATCH v3] uio/pdrv_genirq: Add OF support
To: John Williams <john.williams@petalogix.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Michal Simek <monstr@monstr.eu>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 6:37 AM, John Williams
<john.williams@petalogix.com> wrote:
> On Tue, Apr 19, 2011 at 4:11 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Tue, Apr 19, 2011 at 11:58:25AM +1000, John Williams wrote:
>>> On Tue, Apr 19, 2011 at 2:06 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
>>> > Hi,
>>> >
>>> >> For example with "uio" compatible string:
>>> >> static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
>>> >>       { .compatible = "uio", },
>>> >>       { /* empty for now */ },
>>> >> };
>>> >
>>> > Please use a proper example with "vendor,device".
>>> > (And after that it won't be empty anymore)
>>>
>>> My vote is, and always has been 'generic-uio' :)
>>>
>>> Putting some random vendor/device string in there is just nuts. Do you
>>> really want a kernel patch every time some one binds their device to
>>> it?
>>>
>>> Or, is there no expectation that anybody would attempt to merge such a
>>> pointless patch to begin with?
>>>
>>> As we discussed at ELC, putting a real vendor/device in there is also
>>> broken because all instances in the system wil bind to the generic
>>> uio, which is not necessarily what is desired.
>>>
>>> I know the arguments against the 'generic-uio' tag, but come on, let's
>>> look at the lesser of two evils here!  I call BS on this DTS purity.
>>
>> Call it what you like, but the reasons are well founded.  The alternative
>> that has been proposed which I am in agreement with is to investigate
>> giving userspace the hook to tell the kernel at runtime which devices
>> should be picked up by the uio driver.
>
> OK, so let's talk about this interface.  As I see it, it must be able
> to handle bind per-instance, not per compatibility.
>
> For example, we make systems with multiple, identical timers.  One
> will be used as the system timer, the others need to be (optionally)
> bound to generic UIO.
>
> Therefore, it's not OK to just do
>
> echo "vendor,device" >> /sys/class/something/generic-uio/compatlist
>
> or whatever, as this would bind all instances matching vendor,device.
>
> So, the question I have is, how to handle bind per-instance?

By manipulating a property on the device instance of course!  :-)

Something like:  echo "generic-uio" >>
/sys/devices/path/to/device/a-property-that-changes-the-driver-it-will-bind-to.

>> In the mean time, explicitly modifying the match table is an okay
>> compromise.
>
> My mind is still boggling that in this day and age it could possibly
> be preferred to modify code, instead of a data structure.  However,
> clearly this is a lost cause!

I don't think anybody wants this as a long term solution.  It is
merely a stop-gap so that development is not stalled while working out
a real interface.

g.
