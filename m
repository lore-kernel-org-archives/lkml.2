Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097Ab1FVWSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 18:18:22 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:47718 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759081Ab1FVWSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 18:18:20 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
Subject: Re: [Update][PATCH 7/8] PM / Domains: System-wide transitions support for generic domains (v3)
Organization: Texas Instruments, Inc.
References: <201106112223.04972.rjw@sisk.pl> <201106200006.07642.rjw@sisk.pl>
	<8739j1lemc.fsf@ti.com> <201106230016.46704.rjw@sisk.pl>
Date: Wed, 22 Jun 2011 15:18:17 -0700
In-Reply-To: <201106230016.46704.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Thu, 23 Jun 2011 00:16:46 +0200")
Message-ID: <871uyljys6.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Wednesday, June 22, 2011, Kevin Hilman wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>> > From: Rafael J. Wysocki <rjw@sisk.pl>
>> >
>> > Make generic PM domains support system-wide power transitions
>> > (system suspend and hibernation).  Add suspend, resume, freeze, thaw,
>> > poweroff and restore callbacks to be associated with struct
>> > generic_pm_domain objects and make pm_genpd_init() use them as
>> > appropriate.
>> >
>> > The new callbacks do nothing for devices belonging to power domains
>> > that were powered down at run time (before the transition).  
>> 
>> Great, this is the approach I prefer too, but...
>> 
>> Now I'm confused.  Leaving runtime suspended devices alone is what I was
>> doing in my subsystem but was told not to.  According to
>> 
>>     http://www.mail-archive.com/linux-omap@vger.kernel.org/msg50690.html
>> 
>> "it's generally agreed that _all_ devices should return to full 
>> power during system resume -- even if they were runtime suspended 
>> before the system sleep."
>
> Well, let's say this part of the documentation is slightly outdated.
>
> It basically refers to the model in which system suspend is a separate global
> hardware or firmware operation, so the state of devices may be changed by the
> BIOS or whatever takes over control in the meantime.  In that case the kernel
> has to ensure that the states of devices are consistent with what it thinks
> about them and the simplest way to achieve that is to put the devices to
> full power during resume (and back to low power if that's desirable).
>
> However, in the case of the systems this patchset is intended for system
> suspend is achieved by putting various hardware components into low-power
> states directly in a coordinated way and the system sleep state effectively
> follows from the low-power states the hardware components end up in.  The
> system is woken up from this state by an interrupt or another mechanism under
> the kernel's control.  As a result, the kernel never gives control away, so
> the state of devices after the resume is precisely known to it.
> In consequence, it need not ensure that the state of devices is consistent with
> its view, because it knows that this is the case. :-)
>
> So the documentation should be updated to say what hardware model it is
> referring to.

Great!   Thanks for the clarification.

Kevin
