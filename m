Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1AYBXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:23:35 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57865 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab1AYBXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:23:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Eh8w76bGE7hTD9ZNTZgvYO48mJ4Sr+a9qQapf/yZW8lr3v1yNkfNZSg+7oWVHwiq1r
         84Fvg8lA0dBoUTRTep+Cuw3j+xneArZrn4MfEkS2ScHKJqOlBUdNdWO/4UT1E6E980pU
         E3zZvgBgRm+c/U9GUfflvBHsgSQaXJ4Nkzy7o=
Message-ID: <4D3E2612.2060808@gmail.com>
Date: Mon, 24 Jan 2011 19:23:30 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>
Subject: Re: libata EH running when switching VTs
References: <201101221625.00775.toralf.foerster@gmx.de> <4D3B077F.7040000@gmail.com> <201101221831.09448.toralf.foerster@gmx.de>
In-Reply-To: <201101221831.09448.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2011 11:31 AM, Toralf Förster wrote:
>
> Robert Hancock wrote at 17:36:15
>> (CCing linux-ide)
>>
>> On 01/22/2011 09:25 AM, Toralf Förster wrote:
>>> Hello,
>>>
>>> Henrique de Moraes Holschuh wrote at 14:11:12
>>>
>>>> I don't even know whom to refer you to.  Maybe ask in LKML directly?
>>>> Use the subject "libata EH running when switching VTs".  If one of
>>>> those VTs are in X.org control, say that as well.
>>>
>>> I'm wondering why I get this in /var/log/messages w/ kernel 2.6.37 when I
>>> switch from VT7 (running xorg ) to VT12 (or 1 or 2 or another number) and
>>> back:
>>>
>>>
>>> 2011-01-22T16:20:53.854+01:00 n22 kernel: ata1: hard resetting link
>>> 2011-01-22T16:20:54.163+01:00 n22 kernel: ata1: SATA link up 1.5 Gbps
>>> (SStatus 113 SControl 300)
>>> 2011-01-22T16:20:54.164+01:00 n22 kernel: ata1.00: ACPI cmd
>>> ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
>>> 2011-01-22T16:20:54.164+01:00 n22 kernel: ata1.00: ACPI cmd
>>> f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
>>> 2011-01-22T16:20:54.165+01:00 n22 kernel: ata1.00: ACPI cmd
>>> ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
>>> 2011-01-22T16:20:54.165+01:00 n22 kernel: ata1.00: ACPI cmd
>>> ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
>>> 2011-01-22T16:20:54.169+01:00 n22 kernel: ata1.00: ACPI cmd
>>> ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
>>> 2011-01-22T16:20:54.169+01:00 n22 kernel: ata1.00: ACPI cmd
>>> f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
>>> 2011-01-22T16:20:54.169+01:00 n22 kernel: ata1.00: ACPI cmd
>>> ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
>>> 2011-01-22T16:20:54.169+01:00 n22 kernel: ata1.00: ACPI cmd
>>> ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
>>> 2011-01-22T16:20:54.170+01:00 n22 kernel: ata1.00: configured for
>>> UDMA/100 2011-01-22T16:20:54.171+01:00 n22 kernel: ata1: EH complete
>>>
>>>
>>> I'm running an almost stable Gentoo on a ThinkPad T400 with current
>>> kernel (2.6.37, earlier shows this behaviour too)
>>
>> Is that the only output you're getting? Can you post the full dmesg log
>> from bootup?
>
> Of course - attached here

Curious, there seems to be no indication of why EH was triggered, 
doesn't seem to be have been due to an error. Does this also happen in 
single-user mode or with minimal processes running? It's possible that 
userspace is triggering this somehow.
