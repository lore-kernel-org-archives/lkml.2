Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964965Ab2CXAPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 20:15:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53067 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab2CXAPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 20:15:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVFd=Zef2bH_3MinLEV_V+cEShrmRTe7Sr8HT2R46yHHw@mail.gmail.com>
References: <1332512984-79664-1-git-send-email-trenn@suse.de>
	<CAE9FiQVFd=Zef2bH_3MinLEV_V+cEShrmRTe7Sr8HT2R46yHHw@mail.gmail.com>
Date: Fri, 23 Mar 2012 17:15:37 -0700
X-Google-Sender-Auth: yKG1rfkxgqteO5qOc5XSgjZng1g
Message-ID: <CAE9FiQW-dNhZGYdpGEwsUbSG9okPyM-JR50GaASSLvAR0nBt8A@mail.gmail.com>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via initrd
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Renninger <trenn@suse.de>
Cc: eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 1:54 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> --- a/arch/x86/mm/init.c
>> +++ b/arch/x86/mm/init.c
>> @@ -391,6 +391,12 @@ void free_initrd_mem(unsigned long start, unsigned long end)
>>         *   - relocate_initrd()
>>         * So here We can do PAGE_ALIGN() safely to get partial page to be freed
>>         */
>> +#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
>> +       if (acpi_initrd_offset)
>> +               free_init_pages("initrd memory", start - acpi_initrd_offset,
>> +                               PAGE_ALIGN(end));
>> +       else
>> +#endif
>
> table already get copied to allocated ram, So you don't need to keep
> the portion in initrd range.
>
>>        free_init_pages("initrd memory", start, PAGE_ALIGN(end));
>>  }

oh, i missed it. that is offset

change following would be more clean?

 +#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
 +       /* offset back to free acpi tables */
 +       if (acpi_initrd_offset)
 +               start -= acpi_initrd_offset,
 +#endif

Yinghai
