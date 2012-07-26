Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab2GZVul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:50:41 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:58889 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab2GZVuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:50:40 -0400
MIME-Version: 1.0
In-Reply-To: <1343338982.17538.45.camel@joe2Laptop>
References: <1343257978-7085-1-git-send-email-toshi.kani@hp.com>
 <1343257978-7085-2-git-send-email-toshi.kani@hp.com> <CAErSpo4=HDaWTusKf+tRU6aXmj-mC1i7CswnDzDLZii21i9NaQ@mail.gmail.com>
 <1343336330.3010.496.camel@misato.fc.hp.com> <20120726213730.GA2149@google.com>
 <1343338982.17538.45.camel@joe2Laptop>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 26 Jul 2012 15:50:18 -0600
Message-ID: <CAErSpo4cPuFLmp=b2JUUP-nDdtsFmJFda0az-9z9fEnys23L6w@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] ACPI: Add acpi_pr_<level>() interfaces
To: Joe Perches <joe@perches.com>
Cc: Toshi Kani <toshi.kani@hp.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 3:43 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2012-07-26 at 15:37 -0600, Bjorn Helgaas wrote:
>>     PNP0C01:00: new device for \_SB_.PCI0.ISA_.MBIO
>>
>> I fiddled with this a while ago; it would look something like this:
> []
>> +static noinline_for_stack
>> +char *acpi_name_string(char *buf, char *end, acpi_handle handle,
>> +                    struct printf_spec spec, const char *fmt)
>> +{
>> +     acpi_status status;
>> +     struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
>> +     u32 type = ACPI_SINGLE_NAME;
>> +     char *p = buf;
>> +
>> +     if (fmt[0] == 'A')
>> +             type = ACPI_FULL_PATHNAME;
>
> maybe if (fmt[1] == 'f')
>
>> @@ -982,6 +1007,9 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>>       }
>>
>>       switch (*fmt) {
>> +     case 'A':
>> +     case 'a':
>> +             return acpi_name_string(buf, end, ptr, spec, fmt);
>
> There are only so many letters, it might be better to
> just use 'a' and another 'f' after that if necessary
> for "full".
>
> And of course that should be #ifdef'd too

Yes.  I'm hesitant about this approach in general, because I don't
think printing the ACPI path is something we should be doing often.
It's not like a struct resource or a MAC address, where there are
dozens or hundreds of users.  I really think we should only print ACPI
paths in one or two places, so adding a %p extension would waste a
letter and encourage the wrong behavior.
