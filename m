Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab2KCLup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 07:50:45 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63334 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab2KCLun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 07:50:43 -0400
Message-ID: <5094D466.2010209@deeprootsystems.com>
Date: Sat, 03 Nov 2012 09:23:02 +0100
From: Kevin Hilman <khilman@deeprootsystems.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: "Cousson, Benoit" <b-cousson@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
References: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com> <20121031175219.GH12739@atomide.com> <C9715CB7-D3E2-4CA7-8A93-2B10E8B70640@antoniou-consulting.com> <20121031180935.GL12739@atomide.com> <50918223.6080003@ti.com> <8AD2F7AF-8315-442B-A394-1A38DAB29F52@antoniou-consulting.com> <20121031212639.GQ12739@atomide.com> <8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com> <20121031221402.GA29490@arwen.pp.htv.fi> <E4EE0D1F-C7AC-4620-86F2-D9C7C56E279F@antoniou-consulting.com> <50924DA3.1060901@ti.com> <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com> <50925C49.7060004@ti.com> <CBDE21C5-1980-4BDC-9153-7653A07D0024@dominion.thruhere.net> <50938108.5040507@ti.com> <40797D3D-D62C-4E15-B0DF-75636C1637EE@antoniou-consulting.com>
In-Reply-To: <40797D3D-D62C-4E15-B0DF-75636C1637EE@antoniou-consulting.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2012 09:43 AM, Pantelis Antoniou wrote:
[...]

>>
>> And then use the standard DT support to create later the platform_device that does represent the new super-cape devices.
>>
>
> We know this is the ideal case. In fact that's the long term goal and we had internal discussions about it.

Since you already had internal discussions about this, it would have 
been a great help in avoiding lots of this discussion if you would've 
summarized this ideal case from the beginning, then describe the 
weaknesses and limitations of DT for handling hotplug/dynamic devices 
and thus the reasoning behind creating capebus.  Now it's taken this 
long thread for others to try to convince you about something you 
already knew to be the ideal case.  Seems a bit wasteful.

Kernel development typically works by building/extending infrastructure 
that is already there.  Only when it's obvious that the current 
infrastructure cannot be extended for a new kind of usage do we build 
new infrastruture.

In this case, DT is the obvious infrastructure that needs extending.  At 
least we can all agree on that, for starters.

> DT is nowhere near being able to do it.
>
> That would require the introduction of a DT object file format with aliases being capable to be
> resolved dynamically. We're talking about major changes here in the way DT files are being compiled and
> used in practice.
>
> So yes, in an ideal world that would be great. We're nowhere near close today unfortunately.
>
> Assuming that we do work on a DT object format, and that the runtime resolution mechanism is approved,
> then I agree that this part of the capebus patches can be dropped and the functionality assumed by generic
> DT core.
>
> The question is that this will take time, with no guarantees that this would be acceptable from
> the device tree maintainers. So I am putting them in the CC list, to see what they think about it.

Since this thread has already ventured into the weeds a few times, I 
would suggest that you summarize the DT limitations (focusing on they 
dynamic/hotplug needs) and start a thread on devicetree-discuss, so that 
the DT maintainers can be helpful without having to follow this thread.

IMO, the path forward is clear (though probably longer than you would 
like):  Let's first try and extend DT infrastructure.  If that is 
obviously going nowhere, and DT maintainers are against it.  Then, let's 
revisit capebus.

Kevin
