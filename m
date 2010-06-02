Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab0FBJYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:24:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56848 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab0FBJYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:24:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=anDXa6NmpqueOBGHvG26HDXLH49iKGkxQTITQynpGUk3Gk6TPj1DYPWE2f6+WbHyD/
         S2yGlm0VPfg8X0BRcFwGUYpl2AUpdwTl+VczxT2SYfC2gpt9pvzDoeaYy6DQhyST9cq1
         5hblwK189A/q/Zrv6149pZd6JijhPj5vmGhdc=
Message-ID: <4C0622BF.8070602@gmail.com>
Date: Wed, 02 Jun 2010 11:22:07 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: RAMOOPS: few questions
References: <1275420747.2574.8.camel@maxim-laptop>
In-Reply-To: <1275420747.2574.8.camel@maxim-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/06/2010 21:32, Maxim Levitsky ha scritto:
> Hi,
> 
> I want to switch over my own patch that does more or less the same that
> this driver.
> 
> As I see this driver uses ioremap to reserve the memory.
> However, I have a question about how to tell kernel that specific memory
> region is reserved.
> 
> Well, I use now mem=... to do so, but this wastes space, because the
> region I need can't be near end of the RAM.
> 

Have you got any particular constraints?

> I tried to use 'memmap=20M$0x70000000' on kernel command line, but that
> just makes kernel reboot.
> I think its a bug though.
> 
> Also, does this driver dupms all kernel log or only panic/oops message?

It dumps all, but there's a fixed size for each dump, so you can see the
panic/oops information and the latest prints of the kernel before
panic/oops.

> My patch actually makes kernel store actual printk buffer in fixed
> location, thus it is very robust. It was rejected though in favour of
> solution you eventually implemented.
> 
> Also I would like to extend your driver to dump old contents of the ram
> buffer to kernel log, so one wouldn't worry about erasing in on next
> boot after crash.
> Don't know when I do that though.
> 

ramoops uses a circular buffer of fixed size to store more information.
The number of "dumps" depends on the region size of memory you use.

Regards,

Marco
