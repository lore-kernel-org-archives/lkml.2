Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab1CNV7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:59:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35113 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1CNV7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:59:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=stSqGcn+F1+TsxiBm5uCyPaIfSdkRxF9DCzdvDrstz12lNVEo5/cN2lwyhQC4sy8Dj
         4h4YrqjiTFH/mrTfwchvlQsx6lCbNd9BrzdIn/UxsCVzZI5IofUyeEoHLm1KPeKvbNMi
         mXGYDLCg9NfHXK2HZpfZgFIYZjp0zQC3JHYeU=
Message-ID: <4D7E8FA9.6000203@linaro.org>
Date: Mon, 14 Mar 2011 21:59:05 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [RFC PATCH 3/4] PLATFORM: Introduce async platform_data attach
 api
References: <201103131141.07380.rjw@sisk.pl> <4D7CB15A.6030203@linaro.org> <201103131353.54612.rjw@sisk.pl> <4D7CC4D0.90305@linaro.org> <20110313161528.GB10718@kroah.com> <4D7CFB3B.8060008@linaro.org> <20110313174811.GA11504@kroah.com> <4D7D0933.9010502@linaro.org> <20110313232612.GA13784@kroah.com> <4D7DD41D.1070401@linaro.org> <20110314205432.GA1856@kroah.com>
In-Reply-To: <20110314205432.GA1856@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2011 08:54 PM, Somebody in the thread at some point said:

>> The first issue for usbnet is right now, it has no real insight into
>> what the appropriate interface name is because it is out of its view
>> if the USB Ethernet bridge is soldered onboard or not.  You know, it
>> is also not in a generic userspace's view what is soldered on that
>> board either, so I can only read your pushing of that 'solution' as
>> "get this out of my hair".  The one place that can properly know it
>> right now is the board definition file in the kernel, maybe Device
>> Tree too in the future.
>
> It's not up to the driver to "know" this at all.

Right, it's a matter for the board definition file to know about the 
board.  Not sure how many times I wrote that on this thread, but 
evidently not enough.  It can then send specific functional 
configuration information to the subsystems on the board so they can 
adapt automatically to that environment without stinking up everything 
with private quirk information per-board in the drivers.  That is the 
idea of platform_data and it works really successfully.

It's pointless for you to talk about Device Tree when we'll allegedly 
have the capability to deliver functional configuration data to USB 
devices from board support files, but you claim it's forever evil to use 
it, so what's the point of discussing it?  I dunno why you're bothering 
and it's getting less interesting the more distorted your argumentation 
is becoming trying to hold the line against fixing the drivers.

>> To do it what you are calling the "correct" way in userland, you are
>> okay with the driver selecting the wrong interface name, condemning
>> userland to regenerate board-specific knowledge from grepping
>> /proc/cpuinfo, inferring in userland what can easily and justly be
>> known in the board definition file in kernel, and overriding the
>> wrong interface name.  In all that, Caesar's hands are clean
>> alright, but don't tell me this is a good job and the correct
>> solution.
>
> It really is.  How do you know that I don't want to name this device
> something else than you feel you should?  Do you really want to tell me
> to recompile my kernel just to change the name of the network device?

You know by default if it's going to do it, it ought to try to be 
correct if it's possible, it sounds strange how lassaiz-faire you are 
about these drivers doing the wrong thing.  As Alan pointed out that you 
should either do it well or not bother to do it and have all network 
devices called xxxN until your "wonderful" and "simple" userland rename 
is mandated.  Never mind userland will have to hold a board quirk 
database and query the driver to find out which is WLAN or whatever: 
simplicity.

Nobody said about removing network interface naming, what we're talking 
about is making the driver a touch better so it does the right thing 
first time, adaptively to its platform.

Hey, did you see the smsc95xx driver is configuring its mac address from 
an EEPROM if it's connected instead of letting userland do it, holy 
crap.  I bet those guys who get their MAC address automagically are 
super upset the kernel is cheating userland of some simple wonderfulness.

Ha ha no, just kidding.

Thanks to the other guys for giving their opinions frankly -- I am 
particularly appreciate Mark got the idea immediately -- and I hope 
everyone has a nice evening.

-Andy
