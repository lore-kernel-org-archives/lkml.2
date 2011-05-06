Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab1EFROd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 13:14:33 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16059 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab1EFROc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 13:14:32 -0400
Message-ID: <4DC42C72.1010306@caviumnetworks.com>
Date: Fri, 06 May 2011 10:14:26 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/6] of: Allow scripts/dtc/libfdt to be used from
 kernel code
References: <1304614949-30460-1-git-send-email-ddaney@caviumnetworks.com> <1304614949-30460-2-git-send-email-ddaney@caviumnetworks.com> <4DC3D3D5.6060007@suse.cz>
In-Reply-To: <4DC3D3D5.6060007@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 May 2011 17:14:31.0901 (UTC) FILETIME=[1093F0D0:01CC0C11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2011 03:56 AM, Michal Marek wrote:
> On 5.5.2011 19:02, David Daney wrote:
>> --- /dev/null
>> +++ b/drivers/of/libfdt/Makefile
>> @@ -0,0 +1,8 @@
>> +ccflags-y := -include linux/libfdt_env.h
>> -I$(src)/../../../scripts/dtc/libfdt
>> +
>> +obj-y = fdt.o fdt_wip.o fdt_ro.o
>> +
>> +
>> +$(obj)/%.o: $(src)/../../../scripts/dtc/libfdt/%.c FORCE
>> + $(call cmd,force_checksrc)
>> + $(call if_changed_rule,cc_o_c)
>
> It's just three source files, so you could use three one-line wrappers
> that #include ../../../scripts/dtc/libfdt/<file>.c instead of copying
> the %.c -> %.o rule here.
>

Good idea, that does seem cleaner.

I will adjust the patch.

David Daney
