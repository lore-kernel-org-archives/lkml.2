Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab1EULAE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 07:00:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36093 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab1EULAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 07:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pd1Ukr/eciHCZpj2ua3gngpSECGqFZbOk7tHddHHbhL8j738sVIC+4PcswmRmxkU7y
         +9k2huVG5TTwKXaGCa+L7qqNF4TDLgjQBVYaEtUyU7n63iMtab2Yvhz1npYHhAfGCXcK
         jaPuAWE3CIFta4M3PfP6lACNmeaviliD/Vjrc=
MIME-Version: 1.0
In-Reply-To: <s5htycp6b25.wl%tiwai@suse.de>
References: <BANLkTi==cinS1bZc_ARRbnYT3YD+FQr8gA@mail.gmail.com>
	<20110519145921.GE9854@dumpdata.com>
	<4DD53E2B.2090002@ladisch.de>
	<BANLkTinO1xR4XTN2B325pKCpJ3AjC9YidA@mail.gmail.com>
	<4DD60F57.8030000@ladisch.de>
	<s5htycp6b25.wl%tiwai@suse.de>
Date: Sat, 21 May 2011 12:59:59 +0200
Message-ID: <BANLkTi=P6WP-+BiqEwCRTxaNTqNHT988wA@mail.gmail.com>
Subject: Re: mmap() implementation for pci_alloc_consistent() memory?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Takashi Iwai <tiwai@suse.de>, Clemens Ladisch <clemens@ladisch.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, linux-pci@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Clemens, Takashi,

On Fri, May 20, 2011 at 10:17 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Fri, 20 May 2011 08:51:03 +0200,
> Clemens Ladisch wrote:
>>
>> Leon Woestenberg wrote:
>> > On Thu, May 19, 2011 at 5:58 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
>> >>> On Thu, May 19, 2011 at 12:14:40AM +0200, Leon Woestenberg wrote:
>> >>> >     vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>> >>
>> >> So is this an architecture without coherent caches?
>> >
>> > My aim is to have an architecture independent driver.
>>
>> Please note that most MMU architectures forbid mapping the same memory
>> with different attributes, so you must use pgprot_noncached if and only
>> if dma_alloc_coherent actually uses it.  Something like the code below.
>>
>> And I'm not sure if you have to do some additional cache flushes when
>> mapping on some architectures.
>>
>> >> Or would you want to use pgprot_dmacoherent, if available?
>> >
>> > Hmm, let me check that.
>>
>> It's available only on ARM and Unicore32.
>>
>> There's also dma_mmap_coherent(), which does exactly what you want if
>> your buffer is physically contiguous, but it's ARM only.
>> Takashi tried to implement it for other architectures; I don't know
>> what came of it.
>
> PPC got this recently (thanks to Ben), but still missing in other
> areas.
>
> There was little uncertain issue on MIPS, and it looks difficult to
> achieve it on PA-RISC at all.  The development was stuck due to lack
> of time since then.
>
Thanks for all the insights, I wasn't aware there were arch-specific
calls that already solved the topic issue.

Having dma_mmap_coherent() there is good for one or two archs, but how
can we built portable drivers if the others arch's are still missing?

I assume this call is thus not officially DMA-API (yet)?

Clemens showed some pretty amazing preprocessor #if(def)s to cater for
the all the different arch's and their mapping/cache-coherency
behaviour, but that's not something I would like to put in a driver.

How would dma_mmap_coherent() look like on x86?


Regards,
-- 
Leon
