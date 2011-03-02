Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab1CBBNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 20:13:22 -0500
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:51427 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757677Ab1CBBNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 20:13:20 -0500
MIME-Version: 1.0
In-Reply-To: <4D6C7B56.9060109@codeaurora.org>
References: <1273587331-24604-1-git-send-email-eduardo.valentin@nokia.com>
	<AANLkTin7vRMreG3hOAk95MYZUCV-Kr6ac7gD7jgvX6Gf@mail.gmail.com>
	<20110216115729.GA29817@besouro.research.nokia.com>
	<4D6B78BF.1020102@stericsson.com>
	<4D6C7B56.9060109@codeaurora.org>
Date: Tue, 1 Mar 2011 19:13:16 -0600
Message-ID: <AANLkTikvhj49DftS9c_NouASY9_MbYPCfmSUdJg6pf-5@mail.gmail.com>
Subject: Re: [PATCHv5 0/3] Introduce the /proc/socinfo and use it to export
 OMAP data
From: Andrei Warkentin <andreiw@motorola.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Maxime Coquelin <maxime.coquelin-nonst@stericsson.com>,
        ext Nishanth Menon <nm@ti.com>, ext Tony Lindgren <tony@atomide.com>,
        Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
        ext Linus Walleij <linus.walleij@linaro.org>,
        Ambresh <a0393775@ti.com>,
        "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>,
        Lee Jones <Lee.Jones@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        David Brown <davidb@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        loic.pallardy@stericsson.com,
        "eduardo.valentin@nokia.com" <eduardo.valentin@nokia.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jouni Hogander <jouni.hogander@nokia.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 10:51 PM, Saravana Kannan
<skannan@codeaurora.org> wrote:
> On 02/28/2011 02:28 AM, Maxime Coquelin wrote:
>>
>> Hello Eduardo,
>>
>> On 02/16/2011 12:57 PM, Eduardo Valentin wrote:
>>>>
>>>> Eduardo, what has happened to this patchset?
>>>
>>> Got forgotten :-(. Unfortunately I didn't pushed it hard enough.
>>
>> I propose to refactor your patchset, moving from procfs to sysfs.
>
>>>> Do you want help in picking it up and try to polish it up?
>>>
>>> Yeah, but it would need a refactoring. IIRC, result of last discussion
>>> was that we should not mess with /proc. So, maybe moving back
>
>>> to something under sysfs. Perhaps /sys/devices/soc or so?
>>
>> About the location of this new sysfs entry, where do you think it should
>> be?
>> I propose to create a new directory named "soc" in /sys/devices/system/.
>>
>> As platform vendors have several/different kind of IDs to export to
>> sysfs, I propose each vendor to create file entries related to their IDs
>> (eg. /sys/devices/system/soc/idcode for OMAP platforms).
>
> I think the path /sys/devices/system/soc/ will work for the MSM too. I would
> have ideally liked it to be /sys/devices/system/soc/msm,
> /sys/devices/system/soc/omap, etc, but we can't get to pick names for
> devices under a class. So, we can make do with /sys/devices/system/soc/.
>
>> However, I think we should have a common file entry to export the unique
>> ID of the platforms. Indeed, user-space applications should have a
>> unified way to get this kind of ID, regardless of the platform (eg.
>> /sys/devices/system/soc/unique_id).
>
> I like the idea of have a common file across all implementations that will
> let user space identify what implementation is exporting the other files and
> how to interpret them.
>
> I would like to propose an "arch" file to identify the arch the soc info
> file are for. I'm guessing within an arch, the soc files would mostly be the
> same? If there are other minor differences, we can let the arch specific
> code deal with how the files are interpreted.
>
> Does "arch" work for everyone?
>

Sorry to butt in, but what kind of info are you guys talking about?
Like SOC revision, serial numbers, etc...?

What would an "arch" file mean? The name of the soc platform?
