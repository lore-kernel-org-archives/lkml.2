Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492Ab1FWONd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:13:33 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:36706 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759360Ab1FWONc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:13:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAFxJA05Ld/sX/2dsb2JhbAAMRoRJ3BOQe4Erg3iBCgSiHA
X-IronPort-AV: E=Sophos;i="4.65,413,1304308800"; 
   d="scan'208";a="116988993"
Message-ID: <4E034A09.6050107@teksavvy.com>
Date: Thu, 23 Jun 2011 10:13:29 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH 7/10 v2] Generic Watchdog Timer Driver
References: <20110618172537.GH3441@infomag.iguana.be> <201106182107.45682.arnd@arndb.de> <20110619110328.39c0f5e1@lxorguk.ukuu.org.uk> <201106191325.17181.arnd@arndb.de> <20110619151909.1403205d@lxorguk.ukuu.org.uk> <4DFE31DC.4080201@teksavvy.com> <20110622201346.GE26745@infomag.iguana.be>
In-Reply-To: <20110622201346.GE26745@infomag.iguana.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-06-22 04:13 PM, Wim Van Sebroeck wrote:
> Hi Mark,
> 
>>>>> Then you'd need an additional interface to specify which watchdog as soon
>>>>> as we support multiple watchdogs.
>>>>
>>>> You can always have multiple ways of setting nowayout -- hardware requirements,
>>>> global module option, local module option, and a new ioctl command -- but
>>>> what is being used is then the logical OR of all of them.
>>>
>>> An ioctl for it would make a lot of sense as watchdogs are often compiled
>>> in so currently there isn't a good way to runtime set this.
>>
>> I wouldn't mind a kernel parameter to enable a hardware watchdog timer at boot.
>> Currently, there's a window at startup where the watchdog is not enabled,
>> and the system could lock up and die in there without it being triggered.
> 
> This is another tricky thing were developers will always discuss about.
> What you don't want to happen is that the watchdog reboots your system when it does
> an fsck at bootup (for instance because the system rebooted by the watchdog and left
> the filesystem in a dirty state...).
> 
> So it's more complex if you look at the overal system...

Sure, but that's got little to do with wanting a kernel parameter to OPTIONALLY
enable a hardware watchdog timer at boot.

Filesystem checks are a separate issue, easily worked around in practice.
