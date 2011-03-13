Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab1CMNxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 09:53:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42440 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328Ab1CMNxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 09:53:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=rVwKsJrwzCk2AvB66jCpz1r9d1lf8hcRoFVVRGGBRev/4vhM+q4Tpx7fOJmyCzAGAa
         e86yGCsKtE4mf1weBD0gl4NmhSJ1YCWuMNP3wg6PWqEN0xbi614YtWKUXte7V0CtEyKJ
         g5YX6rBlyiTVhBdFN4+F6ekpgDrIBj8xWiOTw=
Message-ID: <4D7CCC4D.801@linaro.org>
Date: Sun, 13 Mar 2011 13:53:17 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, patches@linaro.org
Subject: Re: [RFC PATCH 1/4] PLATFORM: introduce structure to bind async platform
 data to a dev path name
References: <20110312222633.27020.19543.stgit@otae.warmcat.com> <20110313010329.GB20396@kroah.com> <4D7CA900.2070302@linaro.org> <201103131351.36078.rjw@sisk.pl>
In-Reply-To: <201103131351.36078.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2011 12:51 PM, Somebody in the thread at some point said:

>> Okay.  This is not a PC we are talking about.
>>
>> If the platform / board definition file is registering the USB hosts
>> synchronously at boot time, the driver is composed into the monolithic
>> kernel, there are no PCI busses or whatever on the SoC, the bus indexing
>> is totally deterministic.  This is extremely common in the platform /
>> SoC case and is the case the patchset is targeted at.  Even further, the
>> only time you'd use it is to reach a USB asset that is wired up the same
>> board permanently as well.
>>
>> Anyway this seems moot by now.
>
> However, if you add a new infrastructure like this, it should be at least
> usable on systems that you description doesn't apply to.

Sounds reasonable, except the platform data is coming from a 
board-specific board definition file at boot-time to talk about assets 
that are on fixed interfaces of a specific board.  It's not really 
applicable to wider generic bus use, just like platform_data usually 
isn't and has to be targeted at "device at XYZ on I2C bus n" with 
knowledge of what driver is bound to that device.  Despite that 
"impedence mismatch", it covers the SoC onboard USB asset case just fine 
as it is.

If you mean though, that the patch series implements new configuration 
options in usbnet that are anyway interesting to expose for the general 
case, I can see the point but don't know enough about udev / usb 
subsystem internals to suggest a way to expose the options nicely.

It's also commented the "right" thing to do is to have the driver set 
the device up to wrong defaults like inappropriate interface name / 
random MAC and have userland clean up the mess, rather than have the 
board file ask the driver to set things appropriately.

-Andy
