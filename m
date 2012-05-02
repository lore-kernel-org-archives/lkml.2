Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab2EBLtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 07:49:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41003 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab2EBLtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 07:49:18 -0400
Message-ID: <4FA11F37.5070903@msw.it>
Date: Wed, 02 May 2012 19:49:11 +0800
From: Paolo Scarabelli <paolo@msw.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Ralf Jung <post@ralfj.de>
CC: Jonathan Nieder <jrnieder@gmail.com>, Adrian Fita <adrian.fita@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [bug?] Battery notifications produce flashing battery icon, syslog
 spam (Re: [PATCH 11/11] ACPI / Battery: Update information on info notification
 and resume)
References: <201101062331.17079.rjw@sisk.pl> <4FA032EA.1090608@gmail.com> <20120501191408.GD19143@burratino> <201205012142.55664.post@ralfj.de>
In-Reply-To: <201205012142.55664.post@ralfj.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have the same problem on kernel 3.2.0 (actually I have the same
problem with all kernels I tried since reporting the issue the first time).

I'm almost sure this is related to several Debian bugs open for upower:
#606414, #596721 and #619343.

Is it possible that the high cpu problem with upowerd is caused just to
the log size increasing too much when the laptop is left on for a long time?

In my laptop upowerd starts using a lot of cpu only when I leave it on
overnight.


Regards,


Paolo


On 05/02/2012 03:42 AM, Ralf Jung wrote:
> Hi,
> 
> in addition to the constant flickering when running on AC, there is a more 
> "high frequency" flickering immediately after plugging in the AC: For some 5 
> to 10 seconds, the battery appears and disappears (according to upower) around 
> once per second. There's also a short moment without battery after plugging 
> out the AC.
> All this is gone after going to a kernel version without this patch applied.
> 
> I did not notice unusual high CPU usage of upower on my system, however I 
> noticed disc activity - according to iotop, upower is writing several MiB of 
> data per minute to /var/lib/upower/ where it keeps some battery statistics. I 
> do not know whether this is out of the ordinary.
> 
> Kind regards,
> Ralf
> 
> 
> On Tuesday 01 May 2012 21:14:08 Jonathan Nieder wrote:
>> (cc-ing Andy)
>>
>> Adrian Fita wrote:
>>> Also, searching on Google after "upowerd device
>>> removed:/org/freedesktop/UPower/devices/battery_BAT0", reveals much
>>> more bug reports with the exact issue.
>>
>> Thanks.  That confirms the high CPU consumption in upowerd ---
>> see [1], for example.
>>
>> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/987807
> 
