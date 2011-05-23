Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab1EWQr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:47:58 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:18583 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab1EWQr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:47:57 -0400
Message-ID: <4DDA8FBC.1090904@caviumnetworks.com>
Date: Mon, 23 May 2011 09:47:56 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: David Gibson <david@gibson.dropbear.id.au>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/6] of: Allow scripts/dtc/libfdt to be used from
 kernel code
References: <1305930343-31259-1-git-send-email-ddaney@caviumnetworks.com> <1305930343-31259-2-git-send-email-ddaney@caviumnetworks.com> <20110521063345.GB14828@yookeroo.fritz.box>
In-Reply-To: <20110521063345.GB14828@yookeroo.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 May 2011 16:47:56.0860 (UTC) FILETIME=[2AE1BFC0:01CC1969]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2011 11:33 PM, David Gibson wrote:
> On Fri, May 20, 2011 at 03:25:38PM -0700, David Daney wrote:
>> To use it you need to do this in your Kconfig:
>>
>> 	select LIBFDT
>>
>> And in the Makefile of the code using libfdt something like:
>>
>> ccflags-y := -include linux/libfdt_env.h -I$(src)/../../../scripts/dtc/libfdt
>>
>> Signed-off-by: David Daney<ddaney@caviumnetworks.com>
>> ---
>>   drivers/of/Kconfig          |    3 +++
>>   drivers/of/Makefile         |    2 ++
>>   drivers/of/libfdt/Makefile  |    3 +++
>>   drivers/of/libfdt/fdt.c     |    2 ++
>>   drivers/of/libfdt/fdt_ro.c  |    2 ++
>>   drivers/of/libfdt/fdt_wip.c |    2 ++
>
> No fdt_sw.c or fdt_rw.c?
>

I had no immediate need for them.  They could of course be added, but 
that would potentially waste space.

Let's see if I can make it into an archive library.

David Daney

>>   include/linux/libfdt.h      |    8 ++++++++
>>   include/linux/libfdt_env.h  |   13 +++++++++++++
>>   8 files changed, 35 insertions(+), 0 deletions(-)
>>   create mode 100644 drivers/of/libfdt/Makefile
>>   create mode 100644 drivers/of/libfdt/fdt.c
>>   create mode 100644 drivers/of/libfdt/fdt_ro.c
>

