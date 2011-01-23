Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab1AWPBK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:01:10 -0500
Received: from mailout02.t-online.de ([194.25.134.17]:48219 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1AWPBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:01:08 -0500
Message-ID: <4D3C42A5.6060909@t-online.de>
Date: Sun, 23 Jan 2011 16:00:53 +0100
From: =?UTF-8?B?UmljaGFyZCBTY2jDvHR6?= <r.schtz@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101230 Lanikai/3.1.7
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, rjw@sisk.pl
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus
 laptops)
References: <4D3C3B1E.1080500@pardus.org.tr>
In-Reply-To: <4D3C3B1E.1080500@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: rIcaYGZGQh1nmJVIsOiaHBe53NKHSVR6TJxkk4yXBTLTNyksALVKp9YNXwQqW-RwSj
X-TOI-MSGID: 63533323-15c5-41e8-9f34-00e7dc54b2f2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
>
> I'm getting a lot of bug reports about hanging boot/shutdowns on these
> days.
>
> Most of the affected hardware are ASUS laptops. The problem is that I
> don't have access to any of those problematic laptops and the users are
> not able at all to debug/bisect what is going on. However, I have
> collected dmesgs of good/bad boots, acpidump, etc.
>
> Here are the current status:
>
> "Asus F50SV does not boot unless lapic is passed"
> https://bugzilla.kernel.org/show_bug.cgi?id=26502
>
> "Regression between 2.6.35-020635-rc1 and 2.6.35-020635 breaks acpi
> support on Asus X71 laptop"
> https://bugs.launchpad.net/ubuntu/+source/linux-meta/+bug/689796
>
> "Asus N61JQ hangs at shutdown unless lapic is passed"
> (Not reported upstream yet, I've only downstream bug report which is
> Turkish)
> http://bugs.pardus.org.tr/show_bug.cgi?id=15969
>
> "Asus X61S does not boot unless acpi=off is given"
> (Not reported upstream yet, I've only downstream bug report which is
> Turkish)
> http://bugs.pardus.org.tr/show_bug.cgi?id=16322
> (I've told the reporter to try with nolapic, it will probably fix the
> issue but until confirmed acpi=off is the only solution. 2.6.36 was fine)
>
> I'll post more bugs in here as I've found them.
>
> Thanks,
>

Looks like these are all Intel machines. Do they use intel_idle for the 
CPU powersaving features?
(cat /sys/devices/system/cpu/cpuidle/current_driver)

If yes - does booting with intel_idle.max_cstate=0 or 
intel_idle.max_cstate=3 boot parameter help?

It could be related to https://bugzilla.kernel.org/show_bug.cgi?id=21952 
somehow, which seems to be an 2.6.35 regression.

-- 
Regards,
Richard Schütz
