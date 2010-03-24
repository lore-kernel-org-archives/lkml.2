Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab0CXQjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:39:40 -0400
Received: from xenotime.net ([72.52.64.118]:36932 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753271Ab0CXQjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:39:39 -0400
Message-ID: <4BAA4046.8060400@xenotime.net>
Date: Wed, 24 Mar 2010 09:39:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Pavan Savoy <pavan_savoy@yahoo.co.in>, Greg KH <gregkh@suse.de>,
       PavanSavoy <pavan_savoy@ti.com>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
References: <12213.61465.qm@web94909.mail.in2.yahoo.com> <1269448680.11714.121.camel@localhost.localdomain>
In-Reply-To: <1269448680.11714.121.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/10 09:38, Marcel Holtmann wrote:
> Hi Pavan,
> 
>>>> I wanted to somehow put this in staging because then
>>> it would probably have a thorough architectural review
>>> process.
>>>> Some details about this driver - 
>>>>
>>>> 1. This driver will be used by Bluetooth-BlueZ/FM-V4L2
>>> and GPS (probably character device driver) using the
>>> EXPORTED symbols (-register/_unregister).
>>>>
>>>> 2. Much like the hciattach daemon which maintains
>>> N_HCI bluetooth line discipline, this driver will also have
>>> a User-Space  N_TI_WL Init manager (UIM) maintaining
>>> the Line discipline.
>>>
>>> can you explain why you think this is needed and we can not
>>> interface
>>> this directly. If it is a serial port, what protocol does
>>> it talk?
>>
>> Illustration: The BT driver on top of this ST driver, would create a hci0 interface, when someone does an DEVUP on that interface, the BT driver would then do a st-register - which in-turn would ask the hciattach-like daemon to install the line discipline for it via the sysfs entry.
>> The same concept goes for FM-V4L2 and GPS character driver.
>>
>> The core of the problem is we cannot ask/install/ldisc_put for a line discipline from kernel space.
> 
> so let us get the facts straight here. The device in question is using a
> serial port to connect to the host and then multiplexing BT, FM and GPS
> over it. My question again, what protocol does it talk.
> 
> Also why not just install the line discipline and then control the
> subdevices via RFKILL?
> 
> You need to share some information about your hardware with us that
> explain what are your objections and how it works.
> 
>>>> 3. Because of the UIM should know when to
>>> install/uninstall line discipline, the /sys entry is created
>>> a root called UIM (a new kobject) and UIM daemon would write
>>> it's PID to it.
>>>
>>> I don't understand this. This sounds like a broken concept
>>> to me.
>>
>> Yes, I don't feel good about it either. But how do I request for a line discipline from kernel space ?
>> Currently a daemon has to run in user-space to maintain the ldisc, at all times, and I don't want to open TTY @ boot, and install Ldisc (tiocsetd) on it, without BT/FM or GPS core on chip being used - The Power Management team here would beat me up if I do that, 
>> and hence the very dumb idea of passing the PID of the daemon via sysfs entry, and the driver sending SIGUSR2 to that PID, daemon doing a tiocsetd upon that signal.
> 
> Lets forget about this at all. This is not working out at all. We need
> to figure out a workable solution.
> 
>>>> 4. As Alan suggested, If I make it self-contained by
>>> pushing number of line disciplines to a slightly larger
>>> number, then would it be OK ?
>>>
>>> Just from a quick look, I think within a few review cycles
>>> this might be
>>> able to get proper upstream inclusion. No idea why bother
>>> with staging
>>> in the first place. Lets do this correctly.
>>>
>>
>> The only reason I wanted this to be in staging was to have sort of continuous review process, and in hope the driver wouldn't be forgotten.
> 
> I dislike using the staging tree as review process. We can make a proper
> review on LKML and go towards a real upstream solution.

I agree.  If I had a new driver, I would try to keep it out of staging,
not get it added there.

-- 
~Randy
