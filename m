Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1J0NS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 09:18:27 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45558 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1J0NSZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 09:18:25 -0400
MIME-Version: 1.0
In-Reply-To: <1319719533.23600.55.camel@nimitz>
References: <1319645292.3321.24.camel@br98xy6r>
	<20111026192449.GE355@redhat.com>
	<20111027073058.GA2422@osiris.boeblingen.de.ibm.com>
	<1319719533.23600.55.camel@nimitz>
Date: Thu, 27 Oct 2011 21:18:24 +0800
Message-ID: <CAM_iQpXxe_PTSh2LcFQOwBqjBeME1y0eZVn67Q7_GQB1RrNW1A@mail.gmail.com>
Subject: Re: kdump: No udev events for memory hotplug?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 8:45 PM, Dave Hansen <haveblue@us.ibm.com> wrote:
> On Thu, 2011-10-27 at 09:30 +0200, Heiko Carstens wrote:
>> > Are any events generated for memory add?
>>
>> Looks like uevents are only genereted when memory gets registered and
>> unregistered, but not when when it gets set online or offline.
>> To achieve that you would need to add similar code to
>> store_mem_state()/memory_block_change_state() in drivers/base/memory.c
>> like we have it already in store_online() in drivers/base/cpu.c
>
> Instead of doing it at that low a level, perhaps we should be generating
> events when 'totalram_pages' changes.  That way, we'll also trigger
> events when things like ballooning happen.
>

I think we should separate the memory hot-plug issues from ballooning issues,
so probably we need another uevent for this...
