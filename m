Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab2JBAKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:10:55 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:38739 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab2JBAKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:10:34 -0400
From: Nix <nix@esperi.org.uk>
To: Pierre Beck <mail@pierre-beck.de>
Cc: Chris Murphy <lists@colorremedies.com>,
        Linux RAID <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Areca hardware RAID / first-ever SCSI bus reset: am I about to lose this disk controller?
References: <87mx0lsv4d.fsf@spindle.srvr.nix>
	<FCFB407F-9FED-4B4E-B5D9-62AB363050D2@colorremedies.com>
	<87r4pslpau.fsf@spindle.srvr.nix> <506A0BFB.60606@pierre-beck.de>
Emacs: a Lisp interpreter masquerading as ... a Lisp interpreter!
Date: Tue, 02 Oct 2012 01:10:12 +0100
In-Reply-To: <506A0BFB.60606@pierre-beck.de> (Pierre Beck's message of "Mon,
	01 Oct 2012 23:33:15 +0200")
Message-ID: <87mx057mzf.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: spindle 1290; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 Oct 2012, Pierre Beck stated:
> On 23.09.2012 17:42, Nix wrote:
>> On 19 Sep 2012, Chris Murphy outgrape:
>>
>>> On Sep 19, 2012, at 12:52 PM, Nix wrote:
>>>
>>>> So I have this x86-64 server running Linux 3.5.1 with a SATA-on-PCIe
>>>> Areca 1210 hardware RAID-5 controller
>>> Did you find this? Same controller family. Weird that this just shows
>>> up now, but perhaps instead of it being "bad hardware" out the gate,
>>> something's happened to it and now it's failing as you suspect.
>> Hm, it's possible I suppose. Just as possible that a disk is dying.
>>
>>
>> It looks to have been a one-off transient -- no recurrence yet, touch
>> wood :)
>>
> Check the SMART values of the disks if possible. Watch for command
> timeouts and the usual bad sector stuff. I've had similar issues with
> Adaptec controllers. Bad disks seem to cause havoc. The outstanding
> operation isn't answered within [SCSI Timeout, default 30,
> /sys/block/sdX/device/timeout] seconds, so Linux performs a loop
> reset, eventually resetting the controller. That means between 60 and
> 120 seconds of zero I/O operation, varying between controllers and
> disk array sizes. It's particularly annoying when in RAID and the disk
> could've simply been kicked within few seconds. Something that needs
> improvement IMHO.

The problem has not recurred in more than three weeks. SMART says no
problems... so I guess the controller dropped off the bus for some
reason. Probably some sort of subtle firmware bug or something. (There
are hints in the driver that such bugs exist, hence the enormous amount
of code the driver devotes to resetting the thing when it goes silent.)

-- 
NULL && (void)
