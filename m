Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab1I3Pji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:39:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40749 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab1I3Pjg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:39:36 -0400
MIME-Version: 1.0
In-Reply-To: <fc03678ef8baaa29a8ab3c086ba6bb78.squirrel@webmail.sf-mail.de>
References: <4E82017C.3010304@redhat.com>
	<CAPoiz9w4LyTkmAACHQYR5GSJ+TmN7ePJSb-UuRQ7EjY=QYVn5Q@mail.gmail.com>
	<4E8215B6.1020108@redhat.com>
	<20110930001633.GA11436@myri.com>
	<fc03678ef8baaa29a8ab3c086ba6bb78.squirrel@webmail.sf-mail.de>
Date: Fri, 30 Sep 2011 10:39:34 -0500
Message-ID: <CAMaF-rM4Lm6zqLm7XWT570Xizcqet36WFbf5HNf09wKyHiLKag@mail.gmail.com>
Subject: Re: Workaround for Intel MPS errata
From: Jon Mason <mason@myri.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Avi Kivity <avi@redhat.com>, Sven Schnelle <svens@stackframe.org>,
        Simon Kirby <sim@hostway.ca>, Eric Dumazet <eric.dumazet@gmail.com>,
        Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 2:03 AM, Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:
>> Hey Avi,
>> Can you try this patch?  It should resolve the issue you are seeing.
>>
>> Thanks,
>> Jon
>>
>>     PCI: Workaround for Intel MPS errata
>>
>>     Intel 5000 and 5100 series memory controllers have a known issue if
>> read
>>     completion coalescing is enabled (the default setting) and the PCI-E
>>     Maximum Payload Size is set to 256B.  To work around this issue,
>> disable
>>     read completion coalescing if the MPS is 256B.
>>
>>     http://www.intel.com/content/dam/doc/specification-update/5000-chipset-memory-controller-hub-specification-update.pdf
>>     http://www.intel.com/content/dam/doc/specification-update/5100-memory-controller-hub-chipset-specification-update.pdf
>>
>>     Reported-by: Avi Kivity <avi@redhat.com>
>>     Signed-off-by: Jon Mason <mason@myri.com>
>>
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index a919db2..13c733a 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -1361,6 +1361,80 @@ static int pcie_find_smpss(struct pci_dev *dev,
>> void *data)
>>       return 0;
>>  }
>>
>> +static void pcie_errata_check(int mps)
>> +{
>
> While this whole function is about Intel 5x00 devices the name of it is
> very generic (and in a very generic file). Maybe this can be changed, e.g.

I made it generic in naming because I'm betting there are other chips
out there that don't play nice with others.

> "fixup:" renamed to "fixup_intel_5x00:". Also I wonder if that shouldn't
> be a nop when CONFIG_PCI_QUIRKS is not set.

It probably should be a no-op for non-x86 too, as I doubt many other
arches use Intel memory controllers (maybe IA64).

Thanks,
Jon

>
> Eike
>
