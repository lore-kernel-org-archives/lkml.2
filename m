Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab1BDTih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 14:38:37 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44743 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab1BDTig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 14:38:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FA9xXszb8yg9Va6ONJZL6mquEgWhlFmRFw1+yTpRGnTmWhTYhWAT8qXeg/yowt3qCq
         1tXA4yiOuYZrs3JeysVBtwDphSRlozAf6i2CNFPvm4LMOREVYSrdgV57ETQ1ECcqzAoe
         CFjO3pHd7hy8sknezeB6YAu+DtpTl+E/x6bK8=
Message-ID: <4D4C55B7.4010005@gmail.com>
Date: Fri, 04 Feb 2011 20:38:31 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@suse.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
References: <Pine.LNX.4.44L0.1102041426380.1877-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1102041426380.1877-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2011 08:33 PM, Alan Stern wrote:
> On Fri, 4 Feb 2011, Jiri Slaby wrote:
> 
>>>> It seems to suffice... No hangs still. Should I enable pm_async back
>>>> again to confirm the issue is still present?
>>>
>>> Yes, please, it would be good to know for sure.
>>
>> Ok, confirmed right now :).
>>
>> I disabled pm_async for USB again. What do you suggest next?
> 
> What happens if you leave pm_async enabled but unplug all the USB 
> devices before suspending?

Then I cannot suspend at all (ENOINPUTDEVICE)... And this would be
painful as the bug occurs once a week or so.

> If there are any USB devices you can't 
> unplug, you can get an equivalent result by unconfiguring the root 
> hubs:
> 
> 	for a in /sys/bus/usb/devices/usb* ; do
> 		echo 0 >$a/bConfigurationValue
> 	done

Well, I can put this into suspend/resume scripts. What's the opposite
operation? 1 > $a/bConfigurationValue?

thanks,
-- 
js
