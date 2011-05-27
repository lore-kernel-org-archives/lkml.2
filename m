Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab1E0Qtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 12:49:40 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:14626 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab1E0Qtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 12:49:39 -0400
Message-ID: <4DDFD622.1000102@caviumnetworks.com>
Date: Fri, 27 May 2011 09:49:38 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: David Gibson <david@gibson.dropbear.id.au>,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/6] of: Allow scripts/dtc/libfdt to be used from
 kernel code
References: <1305930343-31259-1-git-send-email-ddaney@caviumnetworks.com> <1305930343-31259-2-git-send-email-ddaney@caviumnetworks.com> <20110521063345.GB14828@yookeroo.fritz.box> <4DDA8FBC.1090904@caviumnetworks.com> <20110527032402.GD7793@yookeroo.fritz.box>
In-Reply-To: <20110527032402.GD7793@yookeroo.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2011 16:49:39.0139 (UTC) FILETIME=[117F4930:01CC1C8E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2011 08:24 PM, David Gibson wrote:
> On Mon, May 23, 2011 at 09:47:56AM -0700, David Daney wrote:
>> On 05/20/2011 11:33 PM, David Gibson wrote:
>>> On Fri, May 20, 2011 at 03:25:38PM -0700, David Daney wrote:
>>>> To use it you need to do this in your Kconfig:
>>>>
>>>> 	select LIBFDT
>>>>
>>>> And in the Makefile of the code using libfdt something like:
>>>>
>>>> ccflags-y := -include linux/libfdt_env.h -I$(src)/../../../scripts/dtc/libfdt
>>>>
>>>> Signed-off-by: David Daney<ddaney@caviumnetworks.com>
>>>> ---
>>>>   drivers/of/Kconfig          |    3 +++
>>>>   drivers/of/Makefile         |    2 ++
>>>>   drivers/of/libfdt/Makefile  |    3 +++
>>>>   drivers/of/libfdt/fdt.c     |    2 ++
>>>>   drivers/of/libfdt/fdt_ro.c  |    2 ++
>>>>   drivers/of/libfdt/fdt_wip.c |    2 ++
>>>
>>> No fdt_sw.c or fdt_rw.c?
>>>
>>
>> I had no immediate need for them.  They could of course be added,
>> but that would potentially waste space.
>>
>> Let's see if I can make it into an archive library.
>
> That would be preferable.  It's more or less designed to work that way
> so that everything is available without using unnecessary space in the
> binary.
>

Well, I was looking at this some more:

Grant specifically requested that this go in drivers/of/libfdt, however 
I am fairly sure that building archive libraries there will require 
changes to the upper level Makefile infrastructure.

If I go back to lib/libfdt, like my first version, I can easily achieve 
archive library behavior, but then it is separated from from drivers/of.

Personally I am starting to like the lib/libfdt home more than 
drivers/of.  If Grant doesn't object, I think I will move it back there.

What do you think?

David Daney

