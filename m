Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab1B1KdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:33:25 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:36445 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706Ab1B1KdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:33:24 -0500
Message-ID: <4D6B78BF.1020102@stericsson.com>
Date: Mon, 28 Feb 2011 11:28:15 +0100
From: Maxime Coquelin <maxime.coquelin-nonst@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "eduardo.valentin@nokia.com" <eduardo.valentin@nokia.com>
Cc: ext Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        ext Tony Lindgren <tony@atomide.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        Ambresh <a0393775@ti.com>,
        "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>,
        Jouni Hogander <jouni.hogander@nokia.com>,
        Paul Mundt <lethal@linux-sh.org>, Lee Jones <Lee.Jones@linaro.org>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        ext Nishanth Menon <nm@ti.com>, <loic.pallardy@stericsson.com>
Subject: Re: [PATCHv5 0/3] Introduce the /proc/socinfo and use it to export
 OMAP data
References: <1273587331-24604-1-git-send-email-eduardo.valentin@nokia.com> <AANLkTin7vRMreG3hOAk95MYZUCV-Kr6ac7gD7jgvX6Gf@mail.gmail.com> <20110216115729.GA29817@besouro.research.nokia.com>
In-Reply-To: <20110216115729.GA29817@besouro.research.nokia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eduardo,

On 02/16/2011 12:57 PM, Eduardo Valentin wrote:
> Hello Linus,
>
> On Tue, Feb 15, 2011 at 01:58:00PM +0100, ext Linus Walleij wrote:
>> 2010/5/11 Eduardo Valentin<eduardo.valentin@nokia.com>:
>>
>>> Here is the version 5 of the change to export OMAP data to userspace
>>> (name, revision, id code, production id and die id).
>>>
>>> Basically, this version is still attempting to create a new file under /proc.
>>> It is the /proc/socinfo, which should be used to export bits which are SoC specific
>>> (not CPU related, nor machine related).
>>>
>>> So, differences between previous version are:
>>> - merged patch 02/04 with 03/04 to avoid compilation breakages.
>>> - simplified the seq_file usage by using the single_open and single_release functions
>>> - exported a function to register a seq_operation .show callback
>>> - adapted the changes accordingly
>>>
>>> As usual, comments are welcome.
>> Eduardo, what has happened to this patchset?
> Got forgotten :-(. Unfortunately I didn't pushed it hard enough.
  I propose to refactor your patchset, moving from procfs to sysfs.
>> Do you want help in picking it up and try to polish it up?
> Yeah, but it would need a refactoring. IIRC, result of last discussion was that
> we should not mess with /proc. So, maybe moving back to something under sysfs.
> Perhaps /sys/devices/soc or so?
About the location of this new sysfs entry, where do you think it should be?
I propose to create a new directory named "soc" in /sys/devices/system/.

As platform vendors have several/different kind of IDs to export to 
sysfs, I propose each vendor to create file entries related to their IDs 
(eg. /sys/devices/system/soc/idcode for OMAP platforms).

However, I think we should have a common file entry to export the unique 
ID of the platforms. Indeed, user-space applications should have a 
unified way to get this kind of ID, regardless of the platform (eg. 
/sys/devices/system/soc/unique_id).

Do you agree with my proposal?

Thanks for your comments.

Regards,

Maxime Coquelin

