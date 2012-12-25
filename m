Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2LYE1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 23:27:00 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:40079 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab2LYE05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 23:26:57 -0500
Message-ID: <50D92B10.8080508@gmail.com>
Date: Mon, 24 Dec 2012 23:26:56 -0500
From: Logan Rathbone <loganrathbone@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: USB 2.0 (EHCI) keeps crapping out (3.2.29)
References: <50D91733.2040000@gmail.com> <1356408600.31232.2@driftwood>
In-Reply-To: <1356408600.31232.2@driftwood>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/24/2012 11:10 PM, Rob Landley wrote:
> On 12/24/2012 09:02:11 PM, Logan Rathbone wrote:
>> *** NOTE:  Kindly CC me directly if you reply to list since I'm not an
>> LKML subscriber. ***
>>
>> Running vanilla 3.2.29 (Slackware 14.0).  I also had this issue on
>> 2.6.37.6 and *possibly* 2.6.33.x, but I don't recall.
>>
>> Every now and again (could be every few days, could take a couple of
>> weeks...
>> depends.) USB 2.0 stops working.  My scanner as well as certain
>> mass-storage
>> devices that are USB-2.0 compatible fail to function all of a sudden.
>>
>> With the said mass storage devices, I get lots of errors like this in
>> my logs:
>>
>> hub 1-0:1.0: unable to enumerate USB device on port 3
>
> What is the _first_ error that shows up in dmesg when the failure occurs?

I *think* this is the first error that appears:

usb 1-3: USB disconnect, device number 3
sd 5:0:0:0: Device offlined - not ready after error recovery

That second message is sometimes:

usblp0: removed

But honestly I can't recall if my USB 2.0 printer stopped working at 
that point in time.  The effect of the crap-out is mainly noticeable on 
my mass storage devices since I can't mount them (the device nodes do 
not get created by udev until I rmmod & modprobe ehci_hcd again or reboot).

I also see stuff like this scattered throughout (hard to tell if it's 
one of the first or last errors that pops up though... I think it's the 
last.  It usually pops up after a whole whack of the "unable to 
enumerate" errors:

ehci_hcd 0000:00:10.3: force halt; handshake f8044014 0000c000 00000000 
-> -110
