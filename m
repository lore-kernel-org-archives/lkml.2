Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab2JAVdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:33:24 -0400
Received: from ozy.pierre-beck.de ([178.63.78.113]:46790 "EHLO
	ozy.pierre-beck.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab2JAVdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:33:23 -0400
Message-ID: <506A0BFB.60606@pierre-beck.de>
From: Pierre Beck <mail@pierre-beck.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Nix <nix@esperi.org.uk>
CC: Chris Murphy <lists@colorremedies.com>,
        Linux RAID <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Areca hardware RAID / first-ever SCSI bus reset: am I about to
 lose this disk controller?
References: <87mx0lsv4d.fsf@spindle.srvr.nix> <FCFB407F-9FED-4B4E-B5D9-62AB363050D2@colorremedies.com> <87r4pslpau.fsf@spindle.srvr.nix>
In-Reply-To: <87r4pslpau.fsf@spindle.srvr.nix>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Original-Recipients: nix@esperi.org.uk, lists@colorremedies.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
X-Original-Date: Mon, 01 Oct 2012 23:32:43 +0200
Date: Mon, 01 Oct 2012 23:33:15 +0200
X-Spam-Notice: Unscanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the SMART values of the disks if possible. Watch for command 
timeouts and the usual bad sector stuff. I've had similar issues with 
Adaptec controllers. Bad disks seem to cause havoc. The outstanding 
operation isn't answered within [SCSI Timeout, default 30, 
/sys/block/sdX/device/timeout] seconds, so Linux performs a loop reset, 
eventually resetting the controller. That means between 60 and 120 
seconds of zero I/O operation, varying between controllers and disk 
array sizes. It's particularly annoying when in RAID and the disk 
could've simply been kicked within few seconds. Something that needs 
improvement IMHO.

On 23.09.2012 17:42, Nix wrote:
> On 19 Sep 2012, Chris Murphy outgrape:
>
>> On Sep 19, 2012, at 12:52 PM, Nix wrote:
>>
>>> So I have this x86-64 server running Linux 3.5.1 with a SATA-on-PCIe
>>> Areca 1210 hardware RAID-5 controller
>> Did you find this? Same controller family. Weird that this just shows
>> up now, but perhaps instead of it being "bad hardware" out the gate,
>> something's happened to it and now it's failing as you suspect.
> Hm, it's possible I suppose. Just as possible that a disk is dying.
>
>
> It looks to have been a one-off transient -- no recurrence yet, touch
> wood :)
>

