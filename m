Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402Ab2AKQJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:09:23 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38922 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757624Ab2AKQJV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:09:21 -0500
MIME-Version: 1.0
In-Reply-To: <20120104091015.0a8c1b2f@jbarnes-desktop>
References: <20120104163052.GA31667@redhat.com> <20120104091015.0a8c1b2f@jbarnes-desktop>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 11 Jan 2012 09:08:59 -0700
Message-ID: <CAErSpo58_=hOhKXwXqUyc9VqAYYyyY8jeV+zJur6Rc+Ff6RnfA@mail.gmail.com>
Subject: Re: Add Thinkpad SL510 to pci=nocrs blacklist
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-pci@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 10:10 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Wed, 4 Jan 2012 11:30:52 -0500
> Dave Jones <davej@redhat.com> wrote:
>
>> Enabling CRS by default breaks suspend on the Thinkpad SL510.
>> Details in https://bugzilla.redhat.com/show_bug.cgi?id=769657
>>
>> Reported-by: Stefan Kirrmann <stefan.kirrmann@gmail.com>
>> Signed-off-by: Dave Jones <davej@redhat.com>
>>
>> --- linux-3.1.noarch/arch/x86/pci/acpi.c~     2011-12-30 14:42:43.495717907 -0500
>> +++ linux-3.1.noarch/arch/x86/pci/acpi.c      2011-12-30 14:45:09.296198024 -0500
>> @@ -72,6 +72,16 @@ static const struct dmi_system_id pci_us
>>                       DMI_MATCH(DMI_BOARD_NAME, "0M273C"),
>>               },
>>       },
>> +     /* https://bugzilla.redhat.com/show_bug.cgi?id=769657 */
>> +     {
>> +             .callback = set_nouse_crs,
>> +             .ident = "Thinkpad SL510",
>> +             .matches = {
>> +                     DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
>> +                     DMI_MATCH(DMI_BOARD_NAME, "2847DFG"),
>> +                     DMI_MATCH(DMI_BIOS_VERSION, "6JET85WW (1.43 )"),
>> +             },
>> +     },
>>       {}
>>  };
>>
>>
>>
>
> Ah I see the Thinkpad patch now... applied this one too.   Thanks.

+linux-pci

I think we should hold off on this one, too.  We (at least I) don't
understand the root cause here.

Bjorn
