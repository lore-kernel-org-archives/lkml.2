Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab2CJAHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 19:07:21 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59037 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab2CJAHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 19:07:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAF1ivSaDEfDFgF0hz3myjSc0BXhig1XGRa_uMOi=gtf2HTEMHg@mail.gmail.com>
References: <1329849524-23758-1-git-send-email-computersforpeace@gmail.com>
	<CAE5mzvgfsHD1Ku5saw+Cu7+vJAayx20=HfHfab1MrAwz3AtqJg@mail.gmail.com>
	<CAF1ivSZcGHQ-bnGasKghJ-_beDqgyZ_ug=m-7Ykr4xUphZeLqw@mail.gmail.com>
	<CAE5mzvgc60+_HOve+5wMsL7fo6jmM_sOB=_pTR1j23=RbP+uPw@mail.gmail.com>
	<CAF1ivSaDEfDFgF0hz3myjSc0BXhig1XGRa_uMOi=gtf2HTEMHg@mail.gmail.com>
Date: Sat, 10 Mar 2012 01:07:07 +0100
Message-ID: <CAG-aW04JJ=v4odC0TVoARijx-9eTCfwYAfUNwtAeLaODYcf06g@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] ahci: fix boot/resume COMRESET failures
From: Matt <jackdachef@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
        jeff@garzik.org, Brian Norris <computersforpeace@gmail.com>,
        Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Norbert Preining <preining@logic.at>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 6:28 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Mon, Mar 5, 2012 at 1:12 PM, cwillu <cwillu@cwillu.com> wrote:
>> On Sun, Mar 4, 2012 at 6:58 PM, Lin Ming <ming.m.lin@intel.com> wrote:
>>> On Fri, Mar 2, 2012 at 9:16 PM, cwillu <cwillu@cwillu.com> wrote:
>>>> On Tue, Feb 21, 2012 at 12:38 PM, Brian Norris
>>>> <computersforpeace@gmail.com> wrote:
>>>>> This series addresses regression problems with
>>>>>
>>>>>    commit 7faa33da9b7add01db9f1ad92c6a5d9145e940a7
>>>>>    ahci: start engine only during soft/hard resets
>>>>
>>>> I just spent the better part of last night tracking down the specific
>>>> sources of the log entry I get when I disconnect my e-sata drive; once
>>>> it disconnects, the port is dead until I reboot; no combination of
>>>> anything I've been able to poke at in /sys or elsewhere gets it live
>>>> again.  This starts with 3.3rc1, and turns out to still work fine in
>>>> 3.2.1. Any chance it's related?
>>>>
>>>> 3.3rc5, immediately after the unplug:
>>>
>>> Hi,
>>>
>>> I tested on my machine and it's fixed by below patch.
>>> http://marc.info/?l=linux-kernel&m=132996405028746&w=2
>>>
>>> Would you please also try it?
>>
>> Building it now, and will be able to test in about 5 hours.
>
> Hi,
>
> How about the test result?
>
> Regards,
> Lin Ming
>
>>
>> After looking at the thread, I spent another couple hours on poking
>> /sys, and did get the port to come back up and find the drive with the
>> following:
>>
>> echo on > /sys/devices/pci0000:00/0000:00:1f.2/ata5/power/control
>> echo on > /sys/devices/pci0000:00/0000:00:1f.2/ata5/host4/power/control
>> echo '- - -' > /sys/devices/pci0000:00/0000:00:1f.2/ata5/host4/scsi_host/host4/scan
>> --

@Carey:

thanks for the commands !


@Lin Ming:

I also have to apologize for the delay, I had much stuff to
repartition, reformat and re-sync during the week and finally
yesterday & today - after finishing that - I could do some testing

that patch works wonderfully - thanks a lot !


the system with 3.3 is significantly more responsive :)

so if there are no reservations against the patch please include it
for final and/or .1 kernel-release of 3.3



on a related note: I had one observation though (non-related to the
mentioned issue)

with or without the patch my computer doesn't turn itself off anymore,
if I remember correctly that didn't happen with rc3 (I could be wrong
though)

anyone else had the same issue ?

to not further delay the final release by this "minor" issue - I'll
test again once final is out and see whether there it's the same

and if that's the case I'll write again & provide you with further
information that you'll need


Awesome work as always, thanks !

Kind Regards

Matt
