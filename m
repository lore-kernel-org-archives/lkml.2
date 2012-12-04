Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2LDPAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 10:00:18 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45228 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab2LDPAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 10:00:16 -0500
Message-ID: <50BE100E.1060007@ti.com>
Date: Tue, 4 Dec 2012 20:30:30 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: Vitaly Andrianov <vitalya@ti.com>, <m.szyprowski@samsung.com>,
        <kyungmin.park@samsung.com>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-keystone@list.ti.com>,
        Cyril Chemparathy <cyril@ti.com>
Subject: Re: [linux-keystone] [PATCH v2] drivers: cma: fix addressing on PAE
 machines
References: <1354549570-21445-1-git-send-email-vitalya@ti.com> <50BD9C45.7070501@ti.com> <xa1tsj7m3qza.fsf@mina86.com>
In-Reply-To: <xa1tsj7m3qza.fsf@mina86.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 December 2012 06:37 PM, Michal Nazarewicz wrote:
>> On Monday 03 December 2012 09:16 PM, Vitaly Andrianov wrote:
>>> This patch fixes a couple of bugs that otherwise impair CMA functionality on
>>> PAE machines:
>>>
>>>     - alignment must be a 64-bit type when running on systems with 64-bit
>>>       physical addresses.  If this is not the case, the limit calculation thunks
>>>       allocations down to an address range < 4G.
>>>
>>>     - The allocated range check is removed. On 32bit ARM kernel with LPAE
>>>       enabled the base may be allocated outside the fist 4GB of physical
>>>       memory (keystone SoC for example).
>
> On Tue, Dec 04 2012, Santosh Shilimkar wrote:
>> Any reason you have clubbed two fixes in one patch. Its better to keep
>> the two fixes separate patches.
>
> They are all related to the very same issue, and what the whole patch
> does is change the type used to store physical addresses from unsigned
> long to phys_addr_t.  This is really a single change.
>
Thanks for clarification. 64 bit alignment fix and the allocation range 
checks
can be two separate fixes and that is exactly what change log describes.
You have a last say though :-) No problem if you want to commit the
patch as is.

Regards
Santosh
