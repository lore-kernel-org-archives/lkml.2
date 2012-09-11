Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab2IKAIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 20:08:06 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59848 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755815Ab2IKAIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 20:08:02 -0400
MIME-Version: 1.0
In-Reply-To: <CA+rthh-nAf8jejcfqjT+uBSVNjpv4y_+tzUD4P7p9TcW1furHA@mail.gmail.com>
References: <1346621844-31211-1-git-send-email-minipli@googlemail.com> <CA+rthh-nAf8jejcfqjT+uBSVNjpv4y_+tzUD4P7p9TcW1furHA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 10 Sep 2012 18:07:40 -0600
Message-ID: <CAErSpo7-c+UTnjQHuvF1H7CizH=aN5FBGcG95RMZj4mjUggTUQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: drop duplicate const in DECLARE_PCI_FIXUP_SECTION
To: Mathias Krause <minipli@googlemail.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 9, 2012 at 10:54 AM, Mathias Krause <minipli@googlemail.com> wrote:
> On Sun, Sep 2, 2012 at 11:37 PM, Mathias Krause <minipli@googlemail.com> wrote:
>> It's redundant and makes sparse complain about it.
>>
>> Signed-off-by: Mathias Krause <minipli@googlemail.com>
>> ---
>>  include/linux/pci.h |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 5faa831..aee24a8 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -1472,7 +1472,7 @@ enum pci_fixup_pass {
>>  /* Anonymous variables would be nice... */
>>  #define DECLARE_PCI_FIXUP_SECTION(section, name, vendor, device, class,        \
>>                                   class_shift, hook)                    \
>> -       static const struct pci_fixup const __pci_fixup_##name __used   \
>> +       static const struct pci_fixup __pci_fixup_##name __used         \
>>         __attribute__((__section__(#section), aligned((sizeof(void *)))))    \
>>                 = { vendor, device, class, class_shift, hook };
>>
>> --
>> 1.7.10.4
>>
>
> Ping? It's janitor work, but hey, it fixes a sparse warning.

Yep, it's worth doing; I'm just slow.  I applied it to my
"pci/trivial" branch.  Thanks!

Bjorn
