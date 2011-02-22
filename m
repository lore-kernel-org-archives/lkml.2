Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab1BVIpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:45:50 -0500
Received: from mail-bw0-f51.google.com ([209.85.214.51]:59596 "EHLO
	mail-bw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab1BVIpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:45:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=j8LZF9itg0W7bRMKsnrhhZpqVmzTxWu+MAw623vPzDJsJ23oYa9iqa0Xfz3T6K1iHK
         RdwDGZNlwLPT0hSWmtkKjK8RJ+6DqFw50Db+ZSMdvPFYU6C1kD+058UagM6bBKWLTSQi
         P1QW1ocuPD2taFG15nYltXi+7vUn8/39vtnV0=
Message-ID: <4D6377B8.7080805@gmail.com>
Date: Tue, 22 Feb 2011 09:45:44 +0100
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
> devices before suspending?  If there are any USB devices you can't 
> unplug, you can get an equivalent result by unconfiguring the root 
> hubs:
> 
> 	for a in /sys/bus/usb/devices/usb* ; do
> 		echo 0 >$a/bConfigurationValue
> 	done

This doesn't seem to help. The hang happened 3 times during the 2 weeks.

I have /etc/pm/sleep.d/99usb-debug with:
#!/bin/bash

send() {
        for a in /sys/bus/usb/devices/usb* ; do
                echo $1 >$a/bConfigurationValue
        done
}

case "$1" in
        hibernate|suspend)
                        send 0
                ;;
        thaw|resume)
                        send 1
                ;;
        *)
                ;;
esac

exit 0

And it indeed properly enable/disable usb before/after suspend.

regards,
-- 
js
