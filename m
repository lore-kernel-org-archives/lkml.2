Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab1CZIeQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 04:34:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38240 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab1CZIeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 04:34:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=o4lYkYNYYgszxFGjyyqMhZHWEoZGRmKB9tdOD1/O3WsuzoE7irXUiCu2O8j4cmMFkV
         6a0eImb5qT01760uS5meEtA5UKjyPOkFDjTubxzHNO+QD8ldaC83/oOyPHmY2/N6FVTc
         aGVwQwTB4SGLkIYRAF6ZUat3uaEu8JyzdoLsM=
MIME-Version: 1.0
In-Reply-To: <4D8DA2F5.1050008@fusionio.com>
References: <4D8B4A89.80608@fusionio.com>
	<AANLkTi=zJbUpcT+vbLARyxhA34F1se8pYq9No799Zqzh@mail.gmail.com>
	<4D8D87B0.3080107@fusionio.com>
	<AANLkTimy1QZiHtQGUrXLPMRGEy3iXNOB=34tFjgezhEu@mail.gmail.com>
	<4D8DA2F5.1050008@fusionio.com>
Date: Sat, 26 Mar 2011 09:34:09 +0100
X-Google-Sender-Auth: XRwJzGzq5B-XFQD_nedFf5gauIc
Message-ID: <AANLkTinu4Piaz5SAb4BmMi-Yd6OjRAKYyKpcEWmD0THU@mail.gmail.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 09:25, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2011-03-26 08:21, Geert Uytterhoeven wrote:
>> On Sat, Mar 26, 2011 at 07:29, Jens Axboe <jaxboe@fusionio.com> wrote:
>>> On 2011-03-25 22:35, Geert Uytterhoeven wrote:
>>>> On Thu, Mar 24, 2011 at 14:43, Jens Axboe <jaxboe@fusionio.com> wrote:
>>>>> Jens Axboe (20):
>>>>>      block: remove per-queue plugging
>>>>
>>>> This one (commit 7eaceaccab5f40bbfda044629a6298616aeaed50) breaks IDE
>>>> on Atari/m68k under ARAnyM. It hangs on:
>>>>
>>>> | ide: Falcon IDE controller
>>>> | Probing IDE interface ide0...
>>>> | hda: Sarge m68k, ATA DISK drive
>>>> | ide0 at 0xfff00000 on irq 15 (serialized)
>>>> | ide-gd driver 1.18
>>>> | hda: max request size: 128KiB
>>>> | hda: 2118816 sectors (1084 MB) w/256KiB Cache, CHS=2102/16/63
>>>>
>>>> The next expected line is the partition parsing:
>>>>
>>>> | hda: AHDI hda1 hda2
>>>
>>> Geert, does this work for you?
>>
>> Yep.Thanks!
>
> Great! I think we should place those blk_delay_queue() calls under the
> if (rq), that should workd to and be more optimal. Can I ask you to
> check that, too?
>
> So:
>
> if (rq) {
>        blk_requeue_request(q, rq);
>        blk_delay_queue(q, msecs_to_jiffies(3));
> }
>
> in both locations.

Works, too.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
