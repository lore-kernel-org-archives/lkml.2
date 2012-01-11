Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab2AKQIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:08:20 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40234 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001Ab2AKQIS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:08:18 -0500
MIME-Version: 1.0
In-Reply-To: <20120104183712.GB14966@elte.hu>
References: <20111230193704.GA2874@redhat.com> <20120101145354.GA1791@elte.hu>
 <20120103093020.0cbcd735@jbarnes-desktop> <CAErSpo4YB6Rpe==-vbia9B_aJNtJ7BrDySs-jw5cGmeMv9zRgA@mail.gmail.com>
 <20120104163311.GB31667@redhat.com> <20120104183712.GB14966@elte.hu>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 11 Jan 2012 09:07:55 -0700
Message-ID: <CAErSpo7tvCz4Bi6TF2Khi9aY7wHyWL9Fu2dSD5v8zuOLYmL6oA@mail.gmail.com>
Subject: Re: Add Dell Studio 1557 to pci=nocrs blacklist
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Jones <davej@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-pci@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 11:37 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Dave Jones <davej@redhat.com> wrote:
>
>> The Dell Studio 1557 also doesn't suspend correctly when CRS is enabled.
>> Details at https://bugzilla.redhat.com/show_bug.cgi?id=769657
>>
>> Reported-by: Gregory S. Hoerner <ghoerner@transcendingthought.com>
>> Signed-off-by: Dave Jones <davej@redhat.com>
>>
>> --- linux-3.1.noarch/arch/x86/pci/acpi.c~     2012-01-04 11:19:36.783664477 -0500
>> +++ linux-3.1.noarch/arch/x86/pci/acpi.c      2012-01-04 11:23:42.403666272 -0500
>> @@ -75,6 +75,16 @@ static const struct dmi_system_id pci_us
>>       /* https://bugzilla.redhat.com/show_bug.cgi?id=769657 */
>>       {
>>               .callback = set_nouse_crs,
>> +             .ident = "Dell Studio 1557",
>> +             .matches = {
>> +                     DMI_MATCH(DMI_BOARD_VENDOR, "Dell Inc."),
>> +                     DMI_MATCH(DMI_PRODUCT_NAME, "Studio 1557");
>> +                     DMI_MATCH(DMI_BIOS_VERSION, "A09"),
>
> Btw., should we perhaps match on all things 'Studio*'? For these
> two systems i'm sure there's 20 other models we have not covered
> yet ...

+linux-pci

I think we should hold off on merging this patch upstream.  We don't
understand the root cause yet, and I haven't seen any evidence that
setting "pci=nocrs" actually makes a difference in PCI resource
allocation (https://bugzilla.redhat.com/show_bug.cgi?id=769657#c27)

Bjorn
