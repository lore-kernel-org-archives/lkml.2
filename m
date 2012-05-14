Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab2ENJI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:08:26 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:55416 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755375Ab2ENJIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:08:24 -0400
MIME-Version: 1.0
In-Reply-To: <201205140859.52921.arnd@arndb.de>
References: <CAMP44s2eVtquLoB6Zjbs4nGVKP6e=Dxse4uicL4s8vmrFeJdTQ@mail.gmail.com>
	<CAMP44s1anUhxRqvdEVYdvu9+xedoQmRiEOHii3yaJQWfM2zauA@mail.gmail.com>
	<201205101049.58818.arnd@arndb.de>
	<201205140859.52921.arnd@arndb.de>
Date: Mon, 14 May 2012 11:08:22 +0200
Message-ID: <CAMP44s2mmK2DdkbJjPQ1Wcj4gRXTY33XobVAm9MrXdRvOeFbhw@mail.gmail.com>
Subject: Re: Big I/O latencies, except when iotop is hooked
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 14, 2012 at 10:59 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 10 May 2012, Arnd Bergmann wrote:
>> 176 is extremely bad, yes. A good value would be between 1 and 3.
>> The algorithm is probably not 'la' but 'dl' and the page size (-b)
>> could be smaller -- you have to test by passing '--blocksize=1024' to
>> the --open-au test and see where it starts getting drastically
>> smaller (if 4KB gives you about half the throughput of 8KB,
>> 8KB is the page size). Those two can make the result better.
>>
>> As I said, the erase block size is more likely to be 4MB, which
>> will make the flashsim result worse.
>>
>> Does flashsim give a better number for a trace taken with iotop
>> running?
>>
>> Can you send me or upload that iolog file?
>
> Hi Felipe,
>
> Any update?

Nope, sorry, my laptop got fried. I have a new one and I might be able
to test later today, I don't see why I would have any problems
reproducing this there, but lets see.

> I'd really be interested in the trace file so that we
> can look at data of a real-world case that hurts. I've discussed
> your problem in the Linaro storage team meeting, and the question
> came up whether this only happens with encryption enabled.

As I already said, this also happens without encryption.

> Which kind of encryption method do you actually use? Depending
> on how the encryption is implemented, two things could possibly
> go wrong that would not happen without it:

I just do 'cryptsetup luksFormat' I'm not sure what is their default.
According to the manpage it's aes-cbc-essiv:sha256. I tried with
different --align-payload values, but none that actually improved the
situation.

Anyway, the problem is visible even with plain ext4.

Cheers.

-- 
Felipe Contreras
