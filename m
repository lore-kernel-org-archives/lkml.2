Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab0JVS2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:28:54 -0400
Received: from edu-smtp-01.edutel.nl ([88.159.1.175]:57386 "EHLO
	edu-smtp-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab0JVS2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:28:48 -0400
Message-ID: <4CC1D7DE.7060405@neli.hopto.org>
Date: Fri, 22 Oct 2010 20:28:46 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Thomas Moll <thomas.moll@sysgo.com>
Subject: Re: [PATCH -mm 0/2] RapidIO: Changes to handling of RIO switches
References: <1287688250-14226-1-git-send-email-alexandre.bounine@idt.com> <4CC0AD74.8070800@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201445906@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E55201445906@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bounine, Alexandre wrote:
> Micha Nelissen <micha@neli.hopto.org> wrote:
>> Alexandre Bounine wrote:
>> How can you say this? The two variables have different meanings, this
>> logically implies you can't merge them. So how do you say 'this does
> not
>> prevent us from ...' without providing a reason?
> 
> Looks like I formulated it bad - better would be: they have different
> interpretation by hardware but logically in RapidIO they have single
> role - destid/hopcount are a device coordinates in the RIO network used
> to access that device.

They are logically different as well (for a non-host).

rswitch->destid with hopcount is the way to reach that switch.

rswitch->rdev->destid should be the id associated with a given switch, 
so that every (processor) device can agree what id some switch has. For 
a non-host, the path to reach a switch may use a different id than the 
switch itself has; it's just the id by which it was discovered.

However, it's possible to fix that by fixing the id+hopcount once the 
switch is found using the path with its own id: then you know the right 
hopcount.

>> can be defined to point to the switch that a given rio_dev is
> connected
>> to. This is useful for quick lookups. How else can to know to which
>> switch a given device is connected?
> 
> rdev->rswitch is not a pointer to the entire switch device object - it
> is a pointer to the switch specific extension associated with given
> rio_dev (if applicable). There is no other role for rdev->rswitch.

I know this, it doesn't answer my question.

> Why would you keep a pointer to device data extension instead of the
> pointer to attached device object itself?

There is no particular reason, but this is a useful way to define the 
fields that are there.

My point is, now that you remove the pointer field, that information (to 
which switch is a particular device connected) cannot be stored in this 
way, so do you have an alternative proposal for that? Maybe add a new field.

> BTW, I have back and forward links added in previous patches and only
> one link that may be added later is a forward link from mport to the
> attached rio_dev (ptr to rio_switch will not work here because it can be
> switchless connection). But this reference has to be added into
> rio_mport.

Possible, but I suggest to put it in the rio_net: fields rdev_host, and 
rdev_self. You can see it in the patch I sent you.

Micha
