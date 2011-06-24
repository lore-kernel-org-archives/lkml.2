Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab1FXWQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 18:16:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:34863 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1FXWQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 18:16:44 -0400
Message-ID: <4E050CBE.2030103@infradead.org>
Date: Fri, 24 Jun 2011 19:16:30 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Hans Verkuil <hverkuil@xs4all.nl>, Jesper Juhl <jj@chaosbits.net>,
        LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        linux-media@vger.kernel.org, ceph-devel@vger.kernel.org,
        Sage Weil <sage@newdream.net>
Subject: Re: [RFC] Don't use linux/version.h anymore to indicate a per-driver
 version - Was: Re: [PATCH 03/37] Remove unneeded version.h includes from
 include/
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>	 <4E04912A.4090305@infradead.org>	 <BANLkTim9cBiiK_GsZaspxpPJQDBvAcKCWg@mail.gmail.com>	 <201106241554.10751.hverkuil@xs4all.nl> <4E04A122.2080002@infradead.org>	 <20110624203404.7a3f6f6a@stein>	 <BANLkTimj-oEDvWxMao6zJ_sudUntEVjO1w@mail.gmail.com> <1308949448.2093.20.camel@morgan.silverblock.net>
In-Reply-To: <1308949448.2093.20.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-06-2011 18:04, Andy Walls escreveu:
> On Fri, 2011-06-24 at 14:48 -0400, Devin Heitmueller wrote:
>> On Fri, Jun 24, 2011 at 2:34 PM, Stefan Richter
>> <stefanr@s5r6.in-berlin.de> wrote:
>>> If the "driver version" is in fact an ABI version, then the driver author
>>> should really increase it only when ABI behavior is changed (and only if
>>> the behavior change can only be communicated by version number --- e.g.
>>> addition of an ioctl is not among such reasons).  And the author should
>>> commit behavior changing implementation and version number change in a
>>> single changeset.
>>>
>>> And anybody who backmerges such an ABI behavior change into another kernel
>>> branch (stable, longterm, distro...) must backmerge the associated version
>>> number change too.
>>>
>>> Of course sometimes people realize this only after the fact.  Or driver
>>> authors don't have a clear understanding of ABI versioning to begin with.
>>> I am saying so because I had to learn it too; I certainly wasn't born
>>> with an instinct knowledge how to do it properly.
>>>
>>> (Disclaimer:  I have no stake in drivers/media/ ABIs.  But I am involved
>>> in maintaining a userspace ABI elsewhere in drivers/firewire/, and one of
>>> the userspace libraries that use this ABI.)
>>
>> Hi Stefan,
>>
>> To be clear, I don't think anyone is actually proposing that the
>> driver version number really be used as any form of formal "ABI
>> versioning" scheme.  In almost all cases, it's so the application can
>> know to *not* do something is the driver is older than X.
> 
> MythTV, for example, used to use the driver version to work around old
> VBI bugs and MPEG encoder quirks that the older version of the driver
> may not have known how to handle:
> 
> https://github.com/MythTV/mythtv/blob/b98d3a98e3187000ae652df5ffebe2beb5221ba7/mythtv/libs/libmythtv/mpegrecorder.cpp#L335
> 
> But for newer versions, MythTV could avoid using its own odd hacks.
> The bleeding edge MythTV now has most of these removed.

Removing it is a good thing.

>> Really, this is all about applications being able to jam a hack into
>> their code that translates to "don't call this ioctl() with some
>> particular argument if it's driver W less than version X, because the
>> driver had a bug that is likely to panic the guy's PC".
> 
> Well, not even panics per se, but some thing like the VBI is broken, or
> the volume control doesn't work, IR blaster is works for this version,
> or something else stupid that is very visible to the end user.
> 
> I also use the driver version for troubleshooting problem with users.  I
> roughly know what wasn't working in what version of the cx18 and ivtv
> drivers.  If the end user can tell me the driver version (using v4l2-ctl
> --log-status) along with his symptoms, it makes my life easier.  Being
> able to efficiently help the end user is a win for both me and the end
> user.

If you add it to MODULE_VERSION, you can get the version with:

$ modinfo -F version vivi
0.8.1

Mauro.
