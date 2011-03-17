Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1CQKQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 06:16:39 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1031 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1CQKQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 06:16:37 -0400
Message-ID: <4D81DF02.8090608@xs4all.net>
Date: Thu, 17 Mar 2011 11:14:26 +0100
From: Miquel van Smoorenburg <mikevs@xs4all.net>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Richard Weinberger <richard@nod.at>, Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, serge@hallyn.com, eparis@redhat.com,
        jmorris@namei.org, eugeneteo@kernel.org, drosenberg@vsecurity.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Miquel van Smoorenburg <mikevs@xs4all.net>
Subject: Re: [PATCH] [RFC] Make it easier to harden /proc/
References: <1300303907-22627-1-git-send-email-richard@nod.at> <201103162152.49615.richard@nod.at> <20110316210452.GA13624@p183.telecom.by> <201103162207.49182.richard@nod.at> <20110316211525.GA13711@p183.telecom.by>
In-Reply-To: <20110316211525.GA13711@p183.telecom.by>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 16-03-11 10:15 PM, Alexey Dobriyan wrote:
> On Wed, Mar 16, 2011 at 10:07:48PM +0100, Richard Weinberger wrote:
>> Am Mittwoch 16 März 2011, 22:04:52 schrieb Alexey Dobriyan:
>>> On Wed, Mar 16, 2011 at 09:52:49PM +0100, Richard Weinberger wrote:
>>>> Am Mittwoch 16 März 2011, 21:45:45 schrieb Arnd Bergmann:
>>>>> On Wednesday 16 March 2011 21:08:16 Richard Weinberger wrote:
>>>>>> Am Mittwoch 16 März 2011, 20:55:49 schrieb Kees Cook:
>>>>> I had expected that any dangerous sysctl would not be visible in
>>>>> an unpriviledge container anyway.
>>>>
>>>> No way.
>>>
>>> No way what exactly?
>>
>> Dangerous sysctls are not protected at all.
>> E.g. A jailed root can use /proc/sysrq-trigger.
>
> Yes, and it's suggested that you do not show it at all,
> instead of bloaing ctl_table.
>
> But this requires knowledge which /proc is root and which one is "root".
> :-(
>
> With current splitup into FOO_NS...

And what about sysfs, there's a lot of writable stuff there too. For 
example in /sys/module/*/parameters, /sys/block/*/device/queu , 
/sys/kernel/, /sys/platform/ etc. Perhaps things you don't want to be 
read too, such as some uevent files.

Shouldn't that be made inaccessible as well, preferably not visible?

Programs in containers may need sysfs for stuff like 
/sys/class/net/<device> , so just not mounting sysfs may not be an option.

Mike.
