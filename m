Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1CML6Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 07:58:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52119 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab1CML6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 07:58:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=s+DdMOcW+kOLWe8+/j15ELWqykubCQ5lIpPVntrTUmbzqlORQbmdo6FzyaUgAdaSL5
         32R0NzDVQ2zAkZDnti3NX/6RMgHb9/rF+kpYim0YksBrOf/Ogt0H8iTHI2lycu/RIaRs
         e9hUyEJXL3cpkvK66LpR58q78QKgxUE3EccgY=
Message-ID: <4D7CB15A.6030203@linaro.org>
Date: Sun, 13 Mar 2011 11:58:18 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [RFC PATCH 3/4] PLATFORM: Introduce async platform_data attach
 api
References: <20110312222633.27020.19543.stgit@otae.warmcat.com> <20110312223227.27020.83925.stgit@otae.warmcat.com> <20110313010155.GA20396@kroah.com> <201103131141.07380.rjw@sisk.pl>
In-Reply-To: <201103131141.07380.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2011 10:41 AM, Somebody in the thread at some point said:
> On Sunday, March 13, 2011, Greg KH wrote:
>> On Sat, Mar 12, 2011 at 10:32:27PM +0000, Andy Green wrote:
>>> This introduces a platform API so busses can allow platform_data to
>>> be attached to any struct device they create from probing in one step.
>>>
>>> The function checks through the async platform_data map if one was
>>> previously registered, and checks the device's device path for itself
>>> and its parents against the mapped device path names.
>>>
>>> If it sees a match, it attaches the associated platform_data and sets
>>> that map entry's device_path to NULL so no further time is spent trying
>>> to match it.
>>
>> This _really_ should just use the device tree stuff, that is what it is
>> for, please don't duplicate it here in a not-as-flexible way.
>
> I agree.
>
> @Andy: If it doesn't work for you for some reason, please let us know the
> usage case that is not covered (in detail).

The device tree stuff does not yet exist in a workable way, 
platform_data is established everywhere except USB bus.  Device tree 
brings in bootloader version as a dependency: this method doesn't.

Using platform / board definition files to define and configure the SoC 
and most or all of its onboard assets is a technique widely deployed in 
SoC board definition files.  The patch just very lightly extends 
platform_data to be workable with USB bus devices like it is the other 
buses, within the goal of being able to configure onboard assets at 
boot-time, so it's quite unremarkable from that POV.

However if you don't have that perspective on it, and think about it on 
a PC where it is not intended to be used, no doubt the patchset's 
approach is hard to understand as useful.

Device Tree will be a nice improvement in many ways when it is done, in 
this particular case though presumably it'll have to patch usbnet and 
smsc95xx in a similar way to offer similar configurability.

In the meanwhile, either Panda and Beagle will stay as they are for 
these misfeatures or specific userlands will have to be stunk up with 
/proc/cpuinfo-grepping board-specific ditro-by-distro quirk management.

Anyway, thanks for all the comments on this RFC.

-Andy
