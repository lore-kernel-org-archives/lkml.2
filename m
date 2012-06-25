Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab2FYJHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:07:36 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:52116
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667Ab2FYJHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:07:34 -0400
X-IronPort-AV: E=Sophos;i="4.77,471,1336341600"; 
   d="scan'208";a="148649625"
Message-ID: <4FE82A54.6080307@inria.fr>
Date: Mon, 25 Jun 2012 11:07:32 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Brice Goglin <brice.goglin@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Ulrich Drepper <drepper@gmail.com>, jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Subject: Re: SNB PCI root information
References: <CAOPLpQfUm-2ENkbnYfXEn1nf9FHnaRk3aqQTSTBWb-CsfCUCFA@mail.gmail.com> <CAE9FiQVzKr+nyBh=8-v+HEDF=7JqN2CqdTNx1=LHTq=c_OyZvg@mail.gmail.com> <CAErSpo40SDii6PTNisAnsn6SoB7SzPUGztWAg9vaZZv+ByQsPw@mail.gmail.com> <CAE9FiQVDnS9n28GQrKVVTU7GiMtJZLFN1T9vmOm5oSysvMEVhQ@mail.gmail.com> <CAErSpo4x8+M6hGAqJR2rjGEGk2AnnZfJkmaJrJedzhnKiRf2qw@mail.gmail.com> <CAOPLpQchY4gMYaw-Ew5uujD9JCu==VLjQ7Z_OjrT6akTgX4+iA@mail.gmail.com> <CAErSpo6JWKoFcbsLnyzPGXLKssobfudjcYMvYzfEpYZ-bzCHPg@mail.gmail.com> <CAE9FiQWOUZhUQYc66ceG5EMWQ0uO7L3odh0+XwRsLV2Bza2ZpQ@mail.gmail.com> <4FE22B28.9020402@gmail.com> <CAE9FiQUkGCQ0Y=n3i=bq388T8N-vrHP2LtMTFGwry2nA+uppwA@mail.gmail.com> <4FE2B788.3070505@gmail.com> <CAE9FiQWBB0JVCLWa40k9qYJXGrv_z=RgspgQW4x2di0uCUFXmA@mail.gmail.com> <4FE41B3E.7080609@gmail.com> <CAE9FiQWB-=qRQfJS=95a+L_N32bZ97MCdW3voDCNSCbVcCnERQ@mail.gmail.com> <4FE4D7B7.8000004@gmail.com> <CAE9FiQUOWjLz86JZQrN-v1PdKfLAV022CPrjeArmYM5bRD+drA@mail.gmail.com>
In-Reply-To: <CAE9FiQUOWjLz86JZQrN-v1PdKfLAV022CPrjeArmYM5bRD+drA@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 22/06/2012 22:41, Yinghai Lu a écrit :
> On Fri, Jun 22, 2012 at 1:38 PM, Brice Goglin <brice.goglin@gmail.com> wrote:
>> Le 22/06/2012 19:28, Yinghai Lu a écrit :
>>> On Fri, Jun 22, 2012 at 12:14 AM, Brice Goglin <brice.goglin@gmail.com> wrote:
>>>
>>>>> BIOS _PXM return 0 for both pci root buses?
>>>>>
>>>> Here's dmesg.
>>>> I can't say for sure whether _PXM returns 0 since I don't know how to
>>>> read all this :) But Linux puts the first socket cpumap in
>>>> /sys/bus/pci/devices/*/local_cpus (and that's wrong according to the
>>>> motherboard manual and according to the performance we see).
>>>>
>>> hi, looks like you system bios does not provide _PXM for the root bus.
>>>
>> So why does Linux say that all buses are close to socket 0 instead of
>> close to everything as usual?
>         if (bus && node != -1) {
> #ifdef CONFIG_ACPI_NUMA
>                 if (pxm >= 0)
>                         dev_printk(KERN_DEBUG, &bus->dev,
>                                    "on NUMA node %d (pxm %d)\n", node, pxm);
> #else
>                 dev_printk(KERN_DEBUG, &bus->dev, "on NUMA node %d\n", node);
> #endif
>         }
>
> so can you boot with "debug ignore_loglevel" ?
>

I can't find anything relevant in the debug log. The code has changed a
lot since my old SLES11 but I don't see any old message either. I guess
"bus && node != -1 && pxm>=0" evaluates to false.

Brice

