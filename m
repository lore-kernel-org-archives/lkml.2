Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab1I0C2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 22:28:23 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:54950 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1I0C2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 22:28:22 -0400
Message-ID: <4E813464.80105@oracle.com>
Date: Mon, 26 Sep 2011 19:26:44 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, oneukum@suse.de, x86@kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: S4 resume broken since 2.6.39 (3.1, too)
References: <s5hmxdzyyzx.wl%tiwai@suse.de>	<201109212048.23074.rjw@sisk.pl>	<CAE9FiQVy4D0NhaN=PvPK_+L4Jv=+7huLy9U--LYW49GFZ9TyaQ@mail.gmail.com> <s5hty84fnv7.wl%tiwai@suse.de>
In-Reply-To: <s5hty84fnv7.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4E813479.0194,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2011 11:11 AM, Takashi Iwai wrote:

> At Thu, 22 Sep 2011 07:33:17 -0700,
> Yinghai Lu wrote:
>>
>> On Wed, Sep 21, 2011 at 11:48 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> It looks like init_memory_mapping() is sometimes called with "end"
>>> beyond the last mapped PFN and it explodes when we try to write stuff to
>>> that address during image restoration.
>>>
>>> IOW, the Yinghai's assumption that init_memory_mapping() would always be
>>> called with a "good end" on x86_64 was overomptimistic.
>>
>> for 64bit x86, kernel_physical_mapping_init() will use
>> map_low_page()/call early_memmap() to access ram for page_table that is above
>> rather last mapped PFN.
>>
>> the point is:
>> on system with 64g, usable ram will be [0,2048m), [4g, 64g)
>> init_memory_mapping will be called two times for them.
>> before putting page_table high,
>> page table will be two parts: one is just below 512M, and one below 2048m.
>> after putting page_table high,
>> page table will be two parts: one is just below 2048M, and one below 64G.
> 
> So, how can this change break S4 resume?


not sure.

seems resume has it's own page table during transition...


> Any hint for further debugging?


you may try to insert dead loop in arch/x86/power/hibernate_asm_64.S::restore_image or core_restore_code

to see which part cause reset.

Yinghai


