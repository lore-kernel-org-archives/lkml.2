Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab1CMR0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 13:26:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47642 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab1CMR0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 13:26:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=yCH80geIptB1yLF0lJDuoe3rbyiWggBM8aXzUojqmc/kqdKcUfJYH3JZT0dFYnv9JR
         0jwyo6ygZ1U14f7wO5dXbkvJEJ/8uw2LbjQ7s0PQGwTOFUgG+9aUTuUd3XVHm3KjRj79
         XIAmXH17cZ2fhm0gc3VdmQy4qkF5+8WY5ybKM=
Message-ID: <4D7CFE4B.6020602@linaro.org>
Date: Sun, 13 Mar 2011 17:26:35 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, patches@linaro.org
Subject: Re: [RFC PATCH 1/4] PLATFORM: introduce structure to bind async platform
 data to a dev path name
References: <20110312222633.27020.19543.stgit@otae.warmcat.com> <20110312223212.27020.9839.stgit@otae.warmcat.com> <201103130029.38458.rjw@sisk.pl> <4D7C0423.9020204@linaro.org> <20110313010329.GB20396@kroah.com> <4D7CA900.2070302@linaro.org> <20110313161435.GA10718@kroah.com>
In-Reply-To: <20110313161435.GA10718@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2011 04:14 PM, Somebody in the thread at some point said:

Hi -

> You CAN NOT GUARANTEE the USB device ordering of bus numbers or device
> numbers.  It's that simple.
>
>> If the platform / board definition file is registering the USB hosts
>> synchronously at boot time, the driver is composed into the
>> monolithic kernel, there are no PCI busses or whatever on the SoC,
>> the bus indexing is totally deterministic.
>
> Not true, it could change for a number of reasons, not the least being
> your kernel version changed.
>
> So again NEVER rely on this, bad things could happen in the field when
> you least expect it.

Okay, I can't see how and you did not explain how, but let's agree with 
what you are saying.

Unlike the Shiny Device Tree path where the binding device path string 
is in the bootloader, with this patch series the binding device path is 
in the board definition file, ie, part of the same kernel.  If an 
upgrade breaks it, the guy can look in /sys on his new broken kernel, 
find the new path and uplevel it to that and he's consistent again.  If 
he goes back to an older kernel, it still works consistently (unlike if 
he updated his bootloader that now only knows the new way).

However as I said to Rafael if he thought bus name part of this path was 
too shaky, and you also think it is, it can be changed to use a pointer 
to the host controller since that's also coming from platform or board 
definition file directly in this kind of SoC implementation and is 
available.

-Andy
